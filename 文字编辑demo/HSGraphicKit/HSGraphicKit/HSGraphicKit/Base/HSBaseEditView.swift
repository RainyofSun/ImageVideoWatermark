//
//  HSBaseEditView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

import UIKit

// 编辑类型(支持文字、图片)
enum HSEditType: Int {
    case TEXT,IMAGE
}

// MARK: 文字的编辑的主体边框和手势制定
class HSBaseEditView: UIView {

    // 边框伸缩距离边界的最小值
    let contentLayoutConstant: CGFloat = 20
    // label标签左侧距离边框的距离
    let contentLabelLeftConstant: CGFloat = 10
    // 边框伸缩宽度的最小值
    let minContentLayoutWidthConstant: CGFloat = 100
    // 初始旋转角度
    var oldRadious: CGFloat = 0.0
    // 旋转角度
    var rotateRadious: CGFloat = 0.0
    // 编辑类型 默认为 文字编辑
    var editType: HSEditType = .TEXT
    // 拖动放大的最初手势位置
    var panScaleBeginPoint: CGPoint = .zero
    // 四角操作位大小
    let badgeBounds: CGFloat = 40
    // 数据操作
    var viewModel: HSBaseEditViewModel!
    
    var image: UIImage? {
        didSet {
            contentView.image = image
        }
    }
    
    var text: String? {
        didSet {
            contentView.text = text
        }
    }
    
    // 呈现内容
    lazy var contentView: HSEditContentView = {
        let tempView = HSEditContentView.init(frame: CGRect.zero, editType: editType)
        return tempView
    }()
    
    private lazy var topLeftView: HSEditTagView = {
        let tagView = HSEditTagView()
        tagView.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin]
        return tagView
    }()
    
    private lazy var topRightView: HSEditTagView = {
        let tagView = HSEditTagView()
        tagView.autoresizingMask = [.flexibleRightMargin,.flexibleTopMargin]
        return tagView
    }()
    
    private lazy var bottomLeftView: HSEditTagView = {
        let tagView = HSEditTagView()
        tagView.autoresizingMask = [.flexibleLeftMargin,.flexibleBottomMargin]
        return tagView
    }()
    
    private lazy var bottomRightView: HSEditTagView = {
        let tagView = HSEditTagView()
        tagView.autoresizingMask = [.flexibleRightMargin,.flexibleBottomMargin]
        return tagView
    }()
    
    private lazy var singleTap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(singleTapHandle(sender:)))
        return gesture
    }()
    
    private lazy var doubleTap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(doubleTapHandle(sender:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()
    
    private lazy var panGap: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureHandle(sender:)))
        return gesture
    }()
    
    private lazy var pinch: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandle(sender:)))
        return gesture
    }()
    
    private lazy var rotation: UIRotationGestureRecognizer = {
        let gesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationHandle(sender:)))
        return gesture
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            self.becomeActive()
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        self.resginActive()
        return result
    }
    
    init(frame: CGRect = .zero, editType: HSEditType) {
        self.editType = editType
        super.init(frame: frame)
        self.loadViewData()
        self.loadSubViews()
        self.layoutSubview()
        self.addGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // subView超出view范围处理
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == nil {
            for subView in self.subviews{
                let myPoint = subView.convert(point, to: self)
                if subView.bounds.contains(myPoint) {
                    return subView
                }
            }
        }
        return view
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 记录绘制的数据
        let frame = self.frame
        let contentFrame = CGRect.init(x: frame.origin.x + 20, y: frame.origin.y + 20, width: frame.width - 2 * contentLayoutConstant, height: frame.height - 2 * contentLayoutConstant)
        let layerData = HSImageTextLayerModel.init()
        layerData.x = contentFrame.origin.x
        layerData.y = contentFrame.origin.y
        layerData.width = contentFrame.width
        layerData.height = contentFrame.height
        layerData.type = editType.rawValue
        viewModel.data = layerData
        viewModel.originImage = image
    }
    
    deinit {
        deallocPrint()
    }
    
    // MARK: Public methods
    public func addContent(_ view: UIView) {
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Private methods
    private func loadViewData() {
        viewModel = HSBaseEditViewModel.init()
    }
    
    private func loadSubViews() {
        self.isOpaque = false
        self.addSubview(contentView)

        topLeftView.imgName = "icon_edit_delete"
        self.addSubview(topLeftView)
        
        topRightView.imgName = self.editType == .TEXT ? "icon_edit_edit" : "icon_edit_crop"
        self.addSubview(topRightView)
        
        // TODO: 图片时才显示旋转
        bottomLeftView.imgName = "icon_edit_spin"
        self.addSubview(bottomLeftView)
        
        bottomRightView.imgName = "icon_edit_zoom"
        self.addSubview(bottomRightView)
    }
    
    private func layoutSubview() {
        contentView.snp.makeConstraints { make in
            make.top.left.equalTo(contentLayoutConstant)
            make.bottom.right.equalTo(-contentLayoutConstant)
        }
        
        topLeftView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.size.equalTo(CGSize.init(width: badgeBounds, height: badgeBounds))
        }
        
        topRightView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize.init(width: badgeBounds, height: badgeBounds))
        }
        
        bottomLeftView.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview()
            make.size.equalTo(CGSize.init(width: badgeBounds, height: badgeBounds))
        }
        
        bottomRightView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.size.equalTo(CGSize.init(width: badgeBounds, height: badgeBounds))
        }
    }
    
    private func addGestures() {
        //添加锚点
        self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        // 单击选中元素
        self.addGestureRecognizer(singleTap)
        // 双击元素快速开始编辑图片/文字
        self.addGestureRecognizer(doubleTap)
        // 拖拽手势
        self.addGestureRecognizer(panGap)
        // 旋转手势
        self.addGestureRecognizer(rotation)
        
        // 左上↖️点击删除
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(deleteTapHandle(_ :)))
        topLeftView.addGestureRecognizer(deleteTap)
        
        // 右上↗️点击开始编辑文字或者裁剪图片
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(tagViewTapHandle(sender:)))
        topRightView.addGestureRecognizer(singleTap)
        
        // 左下↙️拖动旋转
        let panRotateGap = UIPanGestureRecognizer.init(target: self, action: #selector(panRotateHandle(sender:)))
        bottomLeftView.addGestureRecognizer(panRotateGap)
        bottomLeftView.isUserInteractionEnabled = true
        
        // 右下↘️拖动缩放
        let panGap3 = UIPanGestureRecognizer(target: self, action: #selector(panScaleHandle(_:)))
        bottomRightView.addGestureRecognizer(panGap3)
        bottomRightView.isUserInteractionEnabled = true
        panGap.require(toFail: panGap3)
    }
}

// MARK: 边框和tag状态
extension HSBaseEditView {
    
    // 编辑框获取焦点时
    public func becomeActive() {
        topLeftView.isHidden = false
        topRightView.isHidden = false
        bottomLeftView.isHidden = false
        bottomRightView.isHidden = false
        
        panGap.isEnabled = true
        pinch.isEnabled = true
        rotation.isEnabled = true
        
        contentView.layer.borderWidth = 2
    }
    
    // 编辑框失去焦点时
    public func resginActive() {
        topLeftView.isHidden = true
        topRightView.isHidden = true
        bottomLeftView.isHidden = true
        bottomRightView.isHidden = true
        
        panGap.isEnabled = false
        pinch.isEnabled = false
        rotation.isEnabled = false
        
        contentView.layer.borderWidth = 0
    }
    
    // 缩放时取消tagView的缩放效果
    private func tagsViewCancelTransform(transform: CGAffineTransform) {
        topLeftView.transform = transform.inverted()
        topRightView.transform = transform.inverted()
        bottomLeftView.transform = transform.inverted()
        bottomRightView.transform = transform.inverted()
        contentView.textLabel.transform = transform.inverted()
    }
}

// MARK: 手势处理
extension HSBaseEditView {
    // 点击View 获取焦点,并且进入编辑模式
    @objc func singleTapHandle(sender: UITapGestureRecognizer) {
        // 判断自己是否是第一响应者,若不是，切换自己为第一响应者
        if self.canBecomeFirstResponder && !self.isFirstResponder {
            let _ = self.becomeFirstResponder()
        }
        // 子类覆写分别操作元素的选中状态
    }
    
    // 双击进入编辑模式
    @objc func doubleTapHandle(sender: UITapGestureRecognizer) {
        // 子类覆写分别开始文字编辑、图片编辑
    }
    
    @objc func panGestureHandle(sender: UIPanGestureRecognizer) {
        // 在父视图中的偏移量
        let translation = sender.translation(in: self.superview)
        if sender.state == .changed {
            self.center = CGPoint.init(x: self.center.x + translation.x, y: self.center.y + translation.y)
            // 归零
            sender.setTranslation(.zero, in: self.superview)
            // 记录起始位置
            viewModel.origin = CGPoint.init(x: self.frame.origin.x - contentLayoutConstant, y: self.frame.origin.y - contentLayoutConstant)
        }
    }
    
    // 拖动旋转手势
    @objc func panRotateHandle(sender: UIPanGestureRecognizer) {
        let touchPoint: CGPoint = sender.location(in: self)
        let superTouchPoint: CGPoint = sender.location(in: self.superview)
        let centerPoint: CGPoint = self.center
        let state = sender.state
        switch state {
        case.began:
            let yDistance = touchPoint.y - centerPoint.y
            let xDistance = touchPoint.x - centerPoint.x
            let radious = atan2(yDistance, xDistance)
            oldRadious = radious
            rotateRadious = 0
            break
        case.changed:
            let yDistance = touchPoint.y - centerPoint.y
            let xDistance = touchPoint.x - centerPoint.x
            let radious = atan2(yDistance, xDistance)
            let moveRadious = radious - oldRadious
            
            if abs(centerPoint.x - superTouchPoint.x) < 50 && abs(centerPoint.y - superTouchPoint.y) < 50 {
                return
            }
            rotateRadious += moveRadious
            oldRadious = radious
            self.transform = self.transform.rotated(by: rotateRadious)
            viewModel.rotate = rotateRadious
            break
        default:
            break
        }
    }
    
    // 拖拽缩放
    @objc func panScaleHandle(_ sender: UIPanGestureRecognizer) {

        let location = sender.location(in: self)
        switch sender.state {
        case .began:
            panScaleBeginPoint = location
            break
        case .changed:
            let size = self.frame.size
            var scale: CGFloat = 0.0
            let changeX = location.x - panScaleBeginPoint.x
            let changeY = location.y - panScaleBeginPoint.y

            scale = (size.height + changeY) / size.height / 2
            scale += (size.width + changeX) / size.width / 2
            if size.width * scale < minContentLayoutWidthConstant {
                scale = 1.0
            }
            self.transform = self.transform.scaledBy(x: scale, y: scale)
            self.tagsViewCancelTransform(transform: self.transform)
            viewModel.scale = scale
        default:
            break
        }
    }
    
    // 捏合手势
    @objc func pinchHandle(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            if self.frame.width * sender.scale > minContentLayoutWidthConstant {
                self.transform = self.transform.scaledBy(x: sender.scale, y: sender.scale)
                viewModel.scale = sender.scale
                self.tagsViewCancelTransform(transform: self.transform)
                sender.scale = 1
            }
        }
    }
    
    // 旋转手势
    @objc func rotationHandle(sender: UIRotationGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            self.transform = self.transform.rotated(by: sender.rotation)
            viewModel.rotate = sender.rotation
            sender.rotation = 0.0
        }
    }
    
    // 点击手势编辑文字或者裁剪图片
    @objc func tagViewTapHandle(sender: UITapGestureRecognizer) {
        // 空方法交由子类覆写,分别实现文字编辑、图片裁剪功能
    }
    
    // 左上删除
    @objc func deleteTapHandle(_ sender: UITapGestureRecognizer) {
        UIApplication.shared.delegate?.window??.becomeFirstResponder()
        self.superview?.resignFirstResponder()
        self.removeFromSuperview()
        UIApplication.shared.delegate?.window??.endEditing(true)
    }
    
    func distanceBetweenTwoPoint(point1: CGPoint, point2: CGPoint) -> Float {
        return sqrtf(powf(Float(point1.x - point2.x), 2) + powf(Float(point1.y - point2.y), 2))
    }
    
    func getRotateRadius(a: Float, b: Float) -> CGFloat {
        let result = (powf(a, 2) + powf(b, 2) - sqrtf(powf(a, 2) + powf(b, 2))) / 2 * a * b
        return CGFloat(cosf(result))
    }
}
