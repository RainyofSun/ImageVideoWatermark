//
//  HSImageTextEditViewController.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/13.
//

import UIKit
import Toast_Swift

class HSImageTextEditViewController: UIViewController {

    // 视频地址
    open var wallpapaerVideoPath: String?
    // 壁纸封面地址
    open var wallpapaerCoverUrl: String?
    // 视频壁纸封面图片
    open var wallpapaerCoverImg: UIImage?
    
    // 文本编辑初始高度
    let toolBarOriginalHeight: CGFloat = 275.0
    // 文本编辑选项滚动时,toolBar的高度
    let toolBarScrollHeight: CGFloat = 425.0
    // 文本最大的展示高度
    var canvasMaxHeight: CGFloat = 0.0
    // 画布宽度 根据缩放的高度来定
    var canvasWidth: CGFloat = 0.0
    // 水印数量
    private var watermarkCount: CGFloat = 0.0
    
    // 背景画布
    private lazy var backgroundCanvas: HSCanvasTextView = {
        let canvasView = HSCanvasTextView.init()
        canvasView.willBecomeFirstResponderClosure = {[weak self] in
            if !(self?.backgroundCanvas.isFirstResponder ?? false) {
                // 如果backgroundCanvas是第一响应者,则不需要收起键盘
                UIApplication.shared.delegate?.window??.endEditing(true)
                // 水印元素失去第一响应者
                self?.firstResponderElement = nil
            }
        }
        canvasView.resignFirstResponderClosure = {[weak self] in
            // 失去第一响应者时,退下输入框
            
        }
        canvasView.showsHorizontalScrollIndicator = false
        return canvasView
    }()
    
    // 背景View 可设置背景图片或者绘制
    lazy var bgView: HSEmptyBackgroundView = {
        let view = HSEmptyBackgroundView.init(frame: CGRect.zero)
        return view
    }()
    
    // 工具栏
    private lazy var toolBar: HSToolBar = {
        let toolBar = HSToolBar.init(frame: CGRect.zero)
        return toolBar
    }()
    
    // 预览按钮
    private lazy var previewBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "icon_preview"), for: .normal)
        view.setImage(UIImage.init(named: "icon_preview"), for: .highlighted)
        return view
    }()

    // 当前获取焦点的元素 --> 当前controller 持有选中编辑的元素,controller 释放的时候需要释放引用
    private var firstResponderElement: HSBaseEditView?
    
    // 缩放比
    private var elementScale: ElementScaleStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializationData()
        self.loadEditViews()
        self.layoutEditViews()
        UITextView.appearance().tintColor = HSMouseColor
    }
    
    // TODO: 处理侧滑返回的情况
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.popGestureClose()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.popGestureOpen()
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let _ = self.backgroundCanvas.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let coverImg = self.wallpapaerCoverImg {
            bgView.backgroundImage = coverImg
        } else {
            if let coverUrl = self.wallpapaerCoverUrl {
                // 加载网络图片
                let isNetPic: Bool = coverUrl.hasPrefix("http")
                if isNetPic {
                    print("加载网络图片")
                } else {
                    bgView.backgroundImage = UIImage.init(contentsOfFile: coverUrl)
                }
            }
        }
    }
    
    deinit {
        self.firstResponderElement = nil
        deallocPrint()
    }
    
    private func initializationData() {
        let videoSize: CGSize = HSTransitionMarkFrame.transitionFrameShared.getVideoSize(videoPath: self.wallpapaerVideoPath ?? "")
        elementScale = HSTransitionMarkFrame.transitionFrameShared.getScaleFactor(videoSize: videoSize)
        if elementScale!.videoWHScale > elementScale!.screenWHScale {
            // 以视频高为基准进行缩放
            canvasMaxHeight = videoSize.height * CANVAS_HEIGHT_SCALE_FACTOR / elementScale!.heightScale
            canvasWidth = canvasMaxHeight * elementScale!.videoWHScale
        }
        if elementScale!.videoWHScale <= elementScale!.screenWHScale {
            // 以视频宽为基准进行缩放
            canvasWidth = videoSize.width * CANVAS_HEIGHT_SCALE_FACTOR / elementScale!.widthScale
            canvasMaxHeight = canvasWidth / elementScale!.videoWHScale
        }
    }
    
    private func loadEditViews() {
        toolBar.toolBarDeleagte = self
        previewBtn.addTarget(self, action: #selector(previewEditEffect(_:)), for: .touchUpInside)
        self.view.backgroundColor = HSMainBGColor
        self.view.addSubview(bgView)
        self.view.addSubview(previewBtn)
        bgView.addSubview(backgroundCanvas)
        self.view.addSubview(toolBar)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.addTextBox()
        }
    }
    
    private func layoutEditViews() {
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.statusBarHeight())
            make.size.equalTo(CGSize.init(width: canvasWidth, height: canvasMaxHeight))
        }
        backgroundCanvas.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        toolBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.safeWindowAreaInsetsBottom())
            make.height.equalTo(toolBarOriginalHeight)
        }
        previewBtn.snp.makeConstraints { make in
            make.right.equalTo(-25)
            make.bottom.equalTo(toolBar.snp.top).offset(-10)
            make.size.equalTo(previewBtn.currentImage!.size)
        }
    }
    
    // 添加文本元素
    fileprivate func addTextBox() {
        let size: CGSize = CGSize.init(width: 200, height: 80)
        var frame = self.backgroundCanvas.getContentBottomPoint(size: size)
        if frame.maxY > canvasMaxHeight {
            frame = self.backgroundCanvas.getUpOffsetBottomPoint()
        }
        let view: HSTextEditElementView = HSTextEditElementView.init(frame: frame, editType: .TEXT)
        var textHeight: CGFloat = view.contentView.getLabelHeight(width: view.contentView.labelWidth)
        textHeight += view.contentLayoutConstant * 2
        view.tag = self.backgroundCanvas.subviews.count - 1
        self.backgroundCanvas.addSubview(view)
        view.becomeFirstResponderClousre = {[weak self] (tempView: HSBaseEditView) in
            self?.firstResponderElement = tempView
        }
        view.showEditMenuClousre = {[weak self] (textElement: HSTextEditElementView, tagView: HSEditTagView) in
            self?.showTextEditMenu(sender: tagView)
        }
        view.deleteElementClousre = {[weak self] in
            self?.watermarkCount -= 1
        }
        let _ = view.resignFirstResponder()
    }
    
    // 复制文本元素
    fileprivate func copyTextBox() {
        let size: CGSize = CGSize.init(width: 200, height: 80)
        var frame = self.backgroundCanvas.getContentBottomPoint(size: size)
        if frame.maxY > canvasMaxHeight {
            frame = self.backgroundCanvas.getUpOffsetBottomPoint()
        }
        if let firstResponder = self.firstResponderElement {
            frame.size = firstResponder.bounds.size
        }
        let view: HSTextEditElementView = HSTextEditElementView.init(frame: frame, editType: .TEXT)
        view.contentView.textLabel.attributedText = self.firstResponderElement?.attributeText
        self.backgroundCanvas.addSubview(view)
        view.transform = self.firstResponderElement?.transform ?? CGAffineTransform.init()
        view.becomeFirstResponderClousre = {[weak self] (tempView: HSBaseEditView) in
            self?.firstResponderElement = tempView
        }
        view.showEditMenuClousre = {[weak self] (textElement: HSTextEditElementView, tagView: HSEditTagView) in
            self?.showTextEditMenu(sender: tagView)
        }
        view.deleteElementClousre = {[weak self] in
            self?.watermarkCount -= 1
        }
        let _ = view.resignFirstResponder()
    }
    
    // 添加图片贴纸元素
    fileprivate func addImageBox(_ sticker: UIImage) {
        let scaleImg: UIImage = HSImageTool.scaleToSize(img: sticker, width: DEFAULT_STICKER_SIZE)
        let aspectRatio = scaleImg.size.width / scaleImg.size.height
        let size: CGSize = CGSize.init(width: DEFAULT_STICKER_SIZE, height: DEFAULT_STICKER_SIZE/aspectRatio)
        var frame = self.backgroundCanvas.getContentBottomPoint(size: size)
        if frame.maxY > canvasMaxHeight {
            frame = self.backgroundCanvas.getUpOffsetBottomPoint()
        }
        let view = HSImageEditElementView.init(frame: frame, editType: .IMAGE)
        view.image = scaleImg
        view.becomeFirstResponderClousre = {[weak self] (tempView: HSBaseEditView) in
            self?.firstResponderElement = tempView
        }
        view.showEditMenuClousre = {[weak self] (imgElement: HSImageEditElementView, tagView: HSEditTagView) in
            self?.showImageEditMenu(sender: tagView)
        }
        view.deleteElementClousre = {[weak self] in
            self?.watermarkCount -= 1
        }
        self.backgroundCanvas.addSubview(view)
        let _ = view.becomeFirstResponder()
    }
    
    // 复制图片贴纸元素
    fileprivate func copyImageBox(_ sticker: UIImage) {
        let scaleImg: UIImage = HSImageTool.scaleToSize(img: sticker, width: DEFAULT_STICKER_SIZE)
        let aspectRatio = scaleImg.size.width / scaleImg.size.height
        let size: CGSize = CGSize.init(width: DEFAULT_STICKER_SIZE, height: DEFAULT_STICKER_SIZE/aspectRatio)
        var frame = self.backgroundCanvas.getContentBottomPoint(size: size)
        if frame.maxY > canvasMaxHeight {
            frame = self.backgroundCanvas.getUpOffsetBottomPoint()
        }
        if let firstResponder = self.firstResponderElement {
            frame.size = firstResponder.bounds.size
        }
        let view = HSImageEditElementView.init(frame: frame, editType: .IMAGE)
        view.image = scaleImg
        view.transform = self.firstResponderElement?.transform ?? CGAffineTransform.init()
        view.becomeFirstResponderClousre = {[weak self] (tempView: HSBaseEditView) in
            self?.firstResponderElement = tempView
        }
        view.showEditMenuClousre = {[weak self] (imgElement: HSImageEditElementView, tagView: HSEditTagView) in
            self?.showImageEditMenu(sender: tagView)
        }
        view.deleteElementClousre = {[weak self] in
            self?.watermarkCount -= 1
        }
        self.backgroundCanvas.addSubview(view)
        let _ = view.becomeFirstResponder()
    }
}

// MARK: ToolBarProtocol
extension HSImageTextEditViewController: ToolBarProtocol {
    func toolBarAddNewTextElement() {
        if watermarkCount >= MAX_MARK_COUNT {
            self.showToast(toast: "The mark number has reached the maximum")
            return
        }
        watermarkCount += 1
        addTextBox()
    }
    
    func toolBarAddNewStickerElement(sticker: UIImage) {
        if watermarkCount >= MAX_MARK_COUNT {
            self.showToast(toast: "The mark number has reached the maximum")
            return
        }
        watermarkCount += 1
        addImageBox(sticker)
    }
    
    func toolBarShowSystemKeyboard() {
        if self.firstResponderElement == nil || self.firstResponderElement?.editType == .IMAGE {
            self.showToast(toast: "Please selected text element")
        }
        if let tempView: HSBaseEditView = self.firstResponderElement, tempView.editType == .TEXT {
            let textView: HSTextEditElementView = tempView as! HSTextEditElementView
            textView.editContentText()
        }
    }
    
    func toolBarChangeTextFont(fontName: String) {
        if self.firstResponderElement == nil {
            self.showToast(toast: "Please selected text element")
        }
        if let tempView: HSBaseEditView = self.firstResponderElement, tempView.editType == .TEXT {
            let textView: HSTextEditElementView = tempView as! HSTextEditElementView
            textView.editTextStyle(editStyle: .TextFont, change: fontName)
        }
    }
    
    func toolBarChangeTextColor(textColor: UIColor) {
        if self.firstResponderElement == nil {
            self.showToast(toast: "Please selected text element")
        }
        if let tempView: HSBaseEditView = self.firstResponderElement, tempView.editType == .TEXT {
            let textView: HSTextEditElementView = tempView as! HSTextEditElementView
            textView.editTextColor(textColor: textColor)
        }
    }
    
    func toolBarChangeTextShadow(textShadow: NSShadow) {
        if self.firstResponderElement == nil {
            self.showToast(toast: "Please selected text element")
        }
        if let tempView: HSBaseEditView = self.firstResponderElement, tempView.editType == .TEXT {
            let textView: HSTextEditElementView = tempView as! HSTextEditElementView
            textView.editTextShadow(textShadow: textShadow)
        }
    }
    
    func toolBarChangeTextStrokeColor(textColor: String) {
        if self.firstResponderElement == nil {
            self.showToast(toast: "Please selected text element")
        }
        if let tempView: HSBaseEditView = self.firstResponderElement, tempView.editType == .TEXT {
            let textView: HSTextEditElementView = tempView as! HSTextEditElementView
            textView.editTextStyle(editStyle: .TextStrokeColor, change: textColor)
        }
    }
    
    func toolBarChangeTextStrokeSize(size: CGFloat) {
        if self.firstResponderElement == nil {
            self.showToast(toast: "Please selected text element")
        }
        if let tempView: HSBaseEditView = self.firstResponderElement, tempView.editType == .TEXT {
            let textView: HSTextEditElementView = tempView as! HSTextEditElementView
            textView.editTextStyle(editStyle: .TextStrokeSize, change: String(format: "%f", size))
        }
    }
    
    func toolBarUpdateHeight(scrollOffset: CGFloat, isScrollDown: Bool) {
//        let isTop: Bool = scrollOffset <= 0
//        var height: CGFloat = self.toolBar.frame.height
//        if isTop && scrollOffset >= 0 {
//            height -= scrollOffset
//            if height <= toolBarOriginalHeight {
//                height = toolBarOriginalHeight
//            }
//        } else {
//            height += scrollOffset
//            if height >= toolBarScrollHeight {
//                height = toolBarScrollHeight
//            }
//        }
//        if height == self.toolBar.frame.height {
//            return
//        }
//        UIView.animate(withDuration: 0.3) {
//            self.toolBar.snp.updateConstraints { make in
//                make.height.equalTo(height)
//            }
//        } completion: { finished in
//            self.view.layoutIfNeeded()
//        }
    }
    
    func toolBarBackClousre() {
        self.showExitEditAlert()
    }
    
    func toolBarEditWallpaperEnd() {
        // 转换数据模型
        let waterInfoModels: [HSBaseEditViewModel] = transformModel()
        let img: UIImage = self.bgView.takeScreenshot()
        let videoGeneratedVC: HSVideoGeneratedViewController = HSVideoGeneratedViewController.init()
        videoGeneratedVC.effectImg = img
        videoGeneratedVC.elementInfo = waterInfoModels
        videoGeneratedVC.canvasSize = CGSize.init(width: canvasWidth, height: canvasMaxHeight)
        if let videoPath = self.wallpapaerVideoPath {
            videoGeneratedVC.wallpaperPath = videoPath
        }
        self.navigationController?.pushViewController(videoGeneratedVC, animated: true)
    }
}

// MARK: 展示弹窗
extension HSImageTextEditViewController {
    // 展示Toast
    private func showToast(toast: String) {
        self.view.makeToast(toast,position:.center)
    }
    
    // 展示编辑结束的弹窗
    private func showExitEditAlert() {
        let view = HSEditWallpaperEndAlert.init(frame: self.view.frame)
        view.show(contentView: self.view)
        view.alertTitle = "Abandon the modification?"
        view.alertContent = "The current operation will not be saved after returning."
        view.alertClosure = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // 展示元素越界弹窗
    private func overHeightAlert() {
        let alert = UIAlertController.init(title: "", message: "超出视图边界", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    // 弹出文本编辑菜单
    private func showTextEditMenu(sender: UIView) {
        for item in 0..<self.backgroundCanvas.subviews.count {
            print("layer --------- \(item)")
        }
        let topModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
        topModel.title = "top"
        topModel.image = "menu_top"
        topModel.disImage = "menu_top_disable"
        topModel.isEnabled = self.elementLayerCanMoveUp()
        
        let bottomModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
        bottomModel.title = "bottom"
        bottomModel.image = "menu_bottom"
        bottomModel.disImage = "menu_bottom_disable"
        bottomModel.isEnabled = self.elememtLayerCanMoveDown()
        
        let copyModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
        copyModel.title = "copy"
        copyModel.image = "menu_copy"
        
        let editModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
        editModel.title = "edit"
        editModel.image = "menu_edit"
        
        let models: [HSPopOverMenuModel] = [topModel,bottomModel,copyModel,editModel]
        let config: HSConfiguration = HSConfiguration.init()
        config.backgoundTintColor = HSDarkBGColor
        config.menuRowHeight = 50
        config.menuWidth = config.menuItemWidth * CGFloat(models.count)
        config.textFont = UIFont.systemFont(ofSize: 11, weight: .regular)
        config.noDismissalIndexes = [0,1]
        
        HSPopOverMenu.showForSender(sender: sender, with: models, popOverPosition: .automatic, config: config) { [weak self] (selectedCell: HSMenuItem) in
            if selectedCell.tag == models.count - 1 {
                // 编辑文字
                self?.toolBarShowSystemKeyboard()
            }
            if selectedCell.tag == models.count - 2 {
                if self!.watermarkCount >= MAX_MARK_COUNT {
                    self?.showToast(toast: "The mark number has reached the maximum")
                    return
                }
                self?.watermarkCount += 1
                // 复制当前的元素
                self?.copyTextBox()
            }
            if selectedCell.tag == models.count - 3 {
                // 图层下移
                selectedCell.isEnabled = (self?.elementLayerMoveDown())!
                // 图层能否上移
                HSPopOverMenu.shared.changeMenuItemState(itemIndex: 0, isEnabled: self?.elementLayerCanMoveUp() ?? false)
            }
            if selectedCell.tag == 0 {
                // 图层上移
                selectedCell.isEnabled = (self?.elementLayerMoveUp())!
                // 图层能否下移
                HSPopOverMenu.shared.changeMenuItemState(itemIndex: models.count - 3, isEnabled: self?.elememtLayerCanMoveDown() ?? false)
            }
        } cancel: {
            
        }
    }
    
    // 弹出图片编辑菜单
    private func showImageEditMenu(sender: UIView) {
        let topModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
        topModel.title = "top"
        topModel.image = "menu_top"
        topModel.disImage = "menu_top_disable"
        topModel.isEnabled = self.elementLayerCanMoveUp()
        
        let bottomModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
        bottomModel.title = "bottom"
        bottomModel.image = "menu_bottom"
        bottomModel.disImage = "menu_bottom_disable"
        bottomModel.isEnabled = self.elememtLayerCanMoveDown()
        
        let copyModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
        copyModel.title = "copy"
        copyModel.image = "menu_copy"
        
        let models: [HSPopOverMenuModel] = [topModel,bottomModel,copyModel]
        let config: HSConfiguration = HSConfiguration.init()
        config.backgoundTintColor = HSDarkBGColor
        config.menuRowHeight = 50
        config.menuWidth = config.menuItemWidth * CGFloat(models.count)
        config.textFont = UIFont.systemFont(ofSize: 11, weight: .regular)
        config.noDismissalIndexes = [0,1]
        
        HSPopOverMenu.showForSender(sender: sender, with: models, popOverPosition: .automatic, config: config) {[weak self] (selectedCell: HSMenuItem) in
            if selectedCell.tag == models.count - 1 {
                if self!.watermarkCount >= MAX_MARK_COUNT {
                    self?.showToast(toast: "The mark number has reached the maximum")
                    return
                }
                self?.watermarkCount += 1
                // 复制图层
                if let imgElement = self?.firstResponderElement, imgElement.editType == .IMAGE {
                    let imgStickerView: HSImageEditElementView = imgElement as! HSImageEditElementView
                    self?.copyImageBox(imgStickerView.contentView.image!)
                }
            }
            if selectedCell.tag == models.count - 2 {
                // 图层下移
                selectedCell.isEnabled = (self?.elementLayerMoveDown())!
                // 图层能否上移
                HSPopOverMenu.shared.changeMenuItemState(itemIndex: 0, isEnabled: self?.elementLayerCanMoveUp() ?? false)
            }
            if selectedCell.tag == 0 {
                // 图层上移
                selectedCell.isEnabled = (self?.elementLayerMoveUp())!
                // 图层能否下移
                HSPopOverMenu.shared.changeMenuItemState(itemIndex: models.count - 2, isEnabled: self?.elememtLayerCanMoveDown() ?? false)
            }
        } cancel: {
            
        }
    }
}

// MARK: 图层移动
extension HSImageTextEditViewController {
    // 图层能否上移
    private func elementLayerCanMoveUp() -> Bool {
        let canMove: Bool = false
        guard let firstResponder = self.firstResponderElement else {
            return canMove
        }
        guard let layerIndex = self.backgroundCanvas.subviews.firstIndex(of: firstResponder) else {
            return canMove
        }
        print("layer Index up \(layerIndex)")
        if layerIndex >= self.backgroundCanvas.subviews.count - 1 {
            return canMove
        }
        return !canMove
    }
    
    // 图层能否下移
    private func elememtLayerCanMoveDown() -> Bool {
        let canMove: Bool = false
        guard let firstResponder = self.firstResponderElement else {
            return canMove
        }
        guard let layerIndex = self.backgroundCanvas.subviews.firstIndex(of: firstResponder) else {
            return canMove
        }
        print("layer Index down \(layerIndex)")
        // 最开始三个为内部的自定义的view,最小的元素Index 为 3
        if layerIndex <= 3 {
            return canMove
        }
        return !canMove
    }
    
    // 图层上移
    private func elementLayerMoveUp() -> Bool {
        let canMove: Bool = false
        guard let firstResponder = self.firstResponderElement else {
            return canMove
        }
        guard let layerIndex = self.backgroundCanvas.subviews.firstIndex(of: firstResponder) else {
            return canMove
        }
        print("layer Index move up \(layerIndex)")
        self.backgroundCanvas.exchangeSubview(at: layerIndex, withSubviewAt: (layerIndex + 1))
        if (layerIndex + 1) >= self.backgroundCanvas.subviews.count - 1 {
            print("已经移动到了最顶层")
            return canMove
        }
        return !canMove
    }
    
    // 图层下移
    private func elementLayerMoveDown() -> Bool {
        let canMove: Bool = false
        guard let firstResponder = self.firstResponderElement else {
            return canMove
        }
        guard let layerIndex = self.backgroundCanvas.subviews.firstIndex(of: firstResponder) else {
            return canMove
        }
        print("layer Index move down \(layerIndex)")
        self.backgroundCanvas.exchangeSubview(at: layerIndex, withSubviewAt: (layerIndex - 1))
        // 最开始三个为内部的自定义的view,最小的元素Index 为 3
        if (layerIndex - 1) <= 3  {
            print("已经移动到了最底层")
            return canMove
        }
        return !canMove
    }
}

// MARK: 数据转换
extension HSImageTextEditViewController {
    // 数据转换
    private func transformModel() -> [HSBaseEditViewModel] {
        var waterMarkModels: [HSBaseEditViewModel] = [HSBaseEditViewModel].init()
        for item in 0..<self.backgroundCanvas.subviews.count {
            let tempView: UIView = self.backgroundCanvas.subviews[item]
            if tempView is HSBaseEditView {
                let textView: HSBaseEditView = tempView as! HSBaseEditView
                textView.viewModel.viewCenter = textView.center
                textView.viewModel.layerTransform = textView.layer.transform
                textView.viewModel.sublayerTransform = textView.layer.sublayerTransform
                textView.viewModel.viewTransform = textView.transform
                if textView.editType == .TEXT {
                    textView.viewModel.viewBounds = textView.contentView.textLabel.bounds.size
                    textView.viewModel.textSnap = textView.contentView.textLabel.takeScreenshot()
                }
                if textView.editType == .IMAGE {
                    textView.viewModel.viewBounds = textView.contentView.imageView.bounds.size
                }
                waterMarkModels.append(textView.viewModel)
            }
        }
        return waterMarkModels
    }
}

// MARK: Target
extension HSImageTextEditViewController {
    // 点击跳转预览
    @objc private func previewEditEffect(_ :UIButton) {
        // 转换数据模型
        let waterInfoModels: [HSBaseEditViewModel] = transformModel()
        let previewVC: HSEditEffectPreviewViewController = HSEditEffectPreviewViewController.init()
        previewVC.backgroundImg = self.bgView.backgroundImage
        previewVC.elementInfo = waterInfoModels
        previewVC.canvasSize = CGSize.init(width: canvasWidth, height: canvasMaxHeight)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}
