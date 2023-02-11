//
//  HSImageTextEditViewController.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/10.
//

import UIKit

class HSImageTextEditViewController: UIViewController {

    let toolHeight: CGFloat = 68.0
    let toolContentHeight: CGFloat = 193.0
    var toolTotalHeight: CGFloat = 0.0
    var toolShowStatusY: CGFloat = 0.0
    var toolHideStatusY: CGFloat = 0.0
    var maxHeight: CGFloat = 0.0
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    // 文本编辑View
    private lazy var textEditView: HSTextEditView = {
        let editView = self.createTextEditView()
        return editView
    }()
    
    // 图片编辑View
    private lazy var imageEditView: HSImageEditView = {
        let editView = self.loadImageEditView()
        return editView
    }()
    
    // 工具栏
    private lazy var toolBar: HSToolBar = {
        let toolBar = HSToolBar.init(frame: CGRect.zero)
        toolBar.items = getToolBarItems()
        toolBar.shouldSelectedCell = {[weak self] (index) in
            return self?.toolBarShouldSelected(index: index) ?? false
        }
        toolBar.didSelectedCell = {[weak self,weak view] (index) in
            self?.toolBarSelected(index: index)
        }
        return toolBar
    }()
    
    // 背景画布
    private lazy var backgroundCanvas: HSCanvasTextView = {
        let canvasView = HSCanvasTextView.init()
        canvasView.willBecomeFirstResponderClosure = {[weak self] in
            if !(self?.backgroundCanvas.isFirstResponder ?? false) {
                // 如果backgroundCanvas是第一响应者,则不需要收起键盘
                UIApplication.shared.delegate?.window??.endEditing(true)
            }
        }
        canvasView.resignFirstResponderClosure = {[weak self] in
            // 失去第一响应者时,退下输入框
            self?.removeTextViewInputView()
        }
        canvasView.showsHorizontalScrollIndicator = false
        canvasView.backgroundColor = .yellow
        return canvasView
    }()
    
    // 背景View 可设置背景图片或者绘制
    lazy var bgView: HSJaggedLayerView = {
        let view = HSJaggedLayerView.init(frame: CGRect.zero)
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.initializationData()
        self.loadEditSubViews()
        self.layoutEditSubviews()
        self.addKeyboardObserver()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    deinit {
        self.removeKeyboardObserver()
        HSImageEditManager.imageEditShared.toolBar = nil
        HSTextStyleEditManager.textEditShared.toolBar = nil
        HSTextInputManager.inputShared.freeRefrence()
        deallocPrint()
    }
    
    func initializationData() {
        toolTotalHeight = toolHeight + toolContentHeight
        toolShowStatusY = self.view.bounds.height - toolTotalHeight - self.navHeight() - self.statusBarHeight() - self.safeWindowAreaInsetsBottom()
        toolHideStatusY = self.view.bounds.height - toolHeight - self.navHeight() - self.statusBarHeight() - self.safeWindowAreaInsetsBottom()
        maxHeight = UIScreen.main.bounds.height - toolHeight - self.safeAreaInsetsBottom() - self.navHeight() - self.statusBarHeight()
    }
    
    func loadEditSubViews() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.addSubview(bgView)
        bgView.addSubview(self.backgroundCanvas)
        self.view.addSubview(toolBar)
        HSImageEditManager.imageEditShared.toolBar = toolBar
        HSTextStyleEditManager.textEditShared.toolBar = toolBar
    }
    
    func layoutEditSubviews() {
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-self.safeAreaInsetsBottom() - toolHeight)
        }
        
        self.backgroundCanvas.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.bgView.snp_bottomMargin)
            make.top.equalTo(self.view.snp_topMargin).offset(5)
        }
        
        toolBar.frame = CGRect.init(x: 0, y: toolHideStatusY, width: self.view.bounds.width, height: toolHeight)
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 加载工具栏
    private func getToolBarItems() -> [HSToolBarItem] {
        let item0 = HSToolBarItem()
        item0.text = "text"
        item0.selectedText = "text"
        item0.image = UIImage.init(named: "icon_tool_text_default")
        item0.selectedImage = UIImage.init(named: "icon_tool_text_selected")
        item0.textColor = UIColor.gray
        item0.selectedTextColor = UIColor.red
        
        let item1 = HSToolBarItem()
        item1.text = "text_box"
        item1.selectedText = "text_box"
        item1.image = UIImage.init(named: "icon_tool_textbox_default")
        item1.selectedImage = UIImage.init(named: "icon_tool_textbox_selected")
        item1.textColor = UIColor.gray
        item1.selectedTextColor = .red

        let item2 = HSToolBarItem()
        item2.text = "picture"
        item2.selectedText = "picture"
        item2.image = UIImage.init(named: "icon_tool_img_default")
        item2.selectedImage = UIImage.init(named: "icon_tool_img_selected")
        item2.textColor = UIColor.gray
        item2.selectedTextColor = .red
        
        let item3 = HSToolBarItem()
        item3.text = ""
        item3.selectedText = ""
        item3.image = UIImage.init(named: "icon_tool_close_selected")
        item3.selectedImage = UIImage.init(named: "icon_tool_close_selected")
        item3.textColor = UIColor.gray
        item3.selectedTextColor = UIColor.gray
        let width = item3.image?.size.width ?? 0.0
        item3.itemWidth = width > 0 ? width + 15 : width
        
        return [item0,item1,item2,item3]
    }
}

// MARK: 工具栏内容控制、工具栏按钮事件
extension HSImageTextEditViewController {
    // ToolBar 选中事件
    private func toolBarSelected(index: Int?) {
        if let itemIndex = index {
            var contentView: UIView
            switch itemIndex {
            case 0:
                if self.backgroundCanvas.isAllowedEdit && self.backgroundCanvas.isFirstResponder {
                    self.backgroundCanvas.inputView = nil
                }
                contentView = self.textEditView
                self.setTextViewInputView()
            case 1:
                contentView = HSTextStyleEditManager.textEditShared.textBoxEditView()
                self.showToolBarContent(content: contentView)
            case 2:
                contentView = self.imageEditView
                self.imageEditView.brightness = HSImageEditManager.imageEditShared.getBrightness()
                self.imageEditView.contrast = HSImageEditManager.imageEditShared.getContrast()
                self.showToolBarContent(content: contentView)
            default:
                break
            }
        } else {
            if self.backgroundCanvas.isAllowedEdit && self.backgroundCanvas.isFirstResponder {
                let _ = self.backgroundCanvas.resignFirstResponder()
            }
            self.hideToolBarContent()
            // 重置图片编辑标识位
            HSImageEditManager.imageEditShared.active = false
        }
    }
    
    // ToolBar 是否允许被选中
    private func toolBarShouldSelected(index: Int?) -> Bool {
        if index == 0 {
            // 首位默认被选中
            return true
        }
        if self.backgroundCanvas.isAllowedEdit && self.backgroundCanvas.isFirstResponder {
            // 如果背景允许编辑,并且处于第一响应者状态,取消第一响应者
            let _ = self.backgroundCanvas.resignFirstResponder()
        }
        switch index {
        case 1:
            // 添加文本编辑元素
            self.addTextBox()
        case 2:
            // 添加图片编辑元素,如果当前正处于图片元素编辑状态,直接选中,否则添加新的图片编辑元素
            if HSImageEditManager.imageEditShared.active {
                return true
            } else {
                self.chooseImageFromAlbum()
                return false
            }
        default:
            break
        }
        self.hideToolBarContent()
        HSImageEditManager.imageEditShared.active = false
        return false
    }
    
    // 添加文本编辑元素
    private func addTextBox() {
        let size = CGSize.init(width: 200, height: 80)
        let frame = self.backgroundCanvas.getContentBottomPoint(size: size)
        if frame.maxY > maxHeight {
            self.overHeightAlert()
        } else {
            let view = HSTextEditElementView.init(frame: frame, editType: .TEXT)
            self.backgroundCanvas.addSubview(view)
            let _ = view.becomeFirstResponder()
        }
    }
    
    // 选择新的图片进行编辑
    private func chooseImageFromAlbum() {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    // 添加图片元素
    private func addImageFromLibary(image: UIImage) {
        let scaleImage = HSImageTool.scaleToSize(img: image, width: 300)
        let aspectRatio = scaleImage.size.width / scaleImage.size.height
        let size = CGSize.init(width: 300.0, height: 300.0/aspectRatio)
        let frame = self.backgroundCanvas.getContentBottomPoint(size: size)
        if frame.maxY > maxHeight {
            self.overHeightAlert()
            // 可以考虑超出边界之后放置在中心的位置
        } else {
            let view = HSImageEditElementView.init(frame: frame, editType: .IMAGE)
            view.image = scaleImage
            self.backgroundCanvas.addSubview(view)
            let _ = view.becomeFirstResponder()
        }
    }
    
    // 弹出工具栏内容
    private func showToolBarContent(content: UIView) {
        self.toolBar.show(contentView: content, frame: CGRect.init(x: 0, y: toolShowStatusY, width: self.view.bounds.width, height: toolTotalHeight))
        UIView.animate(withDuration: 0.3) {
            self.backgroundCanvas.snp.remakeConstraints { make in
                make.top.equalTo(5)
                make.bottom.equalTo(self.toolBar.snp.top)
                make.left.right.equalToSuperview()
            }
        } completion: { isFinished in
            self.backgroundCanvas.updateConstraints()
            self.view.layoutIfNeeded()
            self.getEditLocation()
        }
    }
    
    // 隐藏工具栏
    private func hideToolBarContent() {
        if self.backgroundCanvas.inputView == self.textEditView {
            self.removeTextViewInputView()
        } else {
            toolBar.hide(frame: CGRect.init(x: 0, y: toolHideStatusY, width: self.view.bounds.width, height: toolHeight))
            UIView.animate(withDuration: 0.3) {
                self.backgroundCanvas.snp.remakeConstraints { make in
                    make.top.equalTo(5)
                    make.bottom.equalTo(-5)
                    make.left.right.equalToSuperview()
                }
            } completion: { isFinished in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // 获取当前编辑的位置
    private func getEditLocation() {
        var editViewFrame: CGRect = .zero
        for view in self.backgroundCanvas.subviews {
            if view is HSBaseEditView && view.isFirstResponder {
                editViewFrame = view.frame
                break
            }
        }
        let contentOffsetY = self.backgroundCanvas.contentOffset.y
        if editViewFrame.maxY > contentOffsetY + self.backgroundCanvas.frame.height {
            let offsetY = editViewFrame.maxY - self.backgroundCanvas.bounds.height
            let offset = CGPoint.init(x: 0, y: offsetY)
            self.backgroundCanvas.setContentOffset(offset, animated: true)
        }
    }
    
    // 设置输入view
    private func setTextViewInputView() {
        let _ = self.backgroundCanvas.resignFirstResponder()
        UIView.animate(withDuration: 0.1) {
            self.textEditView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.toolContentHeight)
            self.backgroundCanvas.inputView = self.textEditView
            let _ = self.backgroundCanvas.becomeFirstResponder()
        }
    }
    
    // 移除输入View
    private func removeTextViewInputView() {
        let _ = self.backgroundCanvas.resignFirstResponder()
        self.textEditView.frame = .zero
        self.backgroundCanvas.inputView = nil
        toolBar.frame = CGRect.init(x: 0, y: toolHideStatusY, width: self.view.bounds.width, height: toolHeight)
        self.view.addSubview(toolBar)
        let _ = self.backgroundCanvas.resignFirstResponder()
    }
}

//MARK: UIImagePicker Delegate
extension HSImageTextEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
                self?.addImageFromLibary(image: image)
            }
        }
    }
}

// MARK: Observer 键盘监听 控制工具栏高度
extension HSImageTextEditViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if self.backgroundCanvas.isAllowedEdit && self.backgroundCanvas.isFirstResponder {
                let frame = self.toolBar.frame
                let newFrame = CGRect.init(x: 0, y: toolHideStatusY - keyboardRect.height + safeWindowAreaInsetsBottom(), width: frame.width, height: frame.height)
                UIView.animate(withDuration: 0.2) {
                    self.toolBar.frame = newFrame
                    self.backgroundCanvas.snp.remakeConstraints { make in
                        make.top.equalTo(5)
                        make.bottom.equalTo(self.toolBar.snp.top)
                        make.left.right.equalToSuperview()
                    }
                } completion: { isFinished in
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let rect = CGRect.init(x: 0, y: toolHideStatusY, width: self.view.bounds.width, height: toolHeight)
        UIView.animate(withDuration: 0.2) {
            self.toolBar.frame = rect
            self.backgroundCanvas.snp.remakeConstraints { make in
                make.top.equalTo(5)
                make.bottom.equalTo(-5)
                make.left.right.equalToSuperview()
            }
        } completion: { isFinished in
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: 文字编辑
extension HSImageTextEditViewController {
    private func createTextEditView() -> HSTextEditView {
        let editView = HSTextEditView.init(frame: .zero)
        editView.textFontSizeChanged = {[weak self] (size) in
            self?.fontSizeChange(size)
        }
        editView.textStyleChanged = {[weak self] (style, isSelected) in
            self?.textStyleChange(style, isSelected)
        }
        editView.textHeadIndentChanged = {[weak self] (size) in
            self?.headIndentChange(size)
        }
        editView.textAlignmentChanged = {[weak self] (alignment) in
            self?.textAlignmentChange(alignment)
        }
        editView.textLineSpacingChanged = {[weak self] (spacing) in
            self?.textLineSpacingChange(spacing)
        }
        return editView
    }
    
    private func fontSizeChange(_ size: CGFloat) {
        guard let (editRange, selectedRange) = getEditRange() else {
            return
        }
        guard let attri = self.backgroundCanvas.attributedText else {
            return
        }
        let mutable = HSTextService.setAttributedString(attri, fontSize: size, range: editRange)
        self.backgroundCanvas.attributedText = mutable
        if selectedRange.length > 0 {
            self.backgroundCanvas.selectedRange = selectedRange
        }
    }
    
    private func textStyleChange(_ style: HSTextStyleEditView.TextStyle, _ isSelected: Bool) {
        guard let (editRange, selectedRange) = getEditRange() else {
            return
        }
        guard let attri = self.backgroundCanvas.attributedText else {
            return
        }
        var mutable: NSAttributedString
        switch style {
        case.bold:
            mutable = HSTextService.setAttributedString(attri, isBold: isSelected, range: editRange)
        case.obliqueness:
            mutable = HSTextService.setAttributedString(attri, isObliqueness: isSelected, range: editRange)
        case.strikethrough:
            mutable = HSTextService.setAttributedString(attri, isStrikethrough: isSelected, range: editRange)
        case.underline:
            mutable = HSTextService.setAttributedString(attri, isUnderline: isSelected, range: editRange)
        }
        self.backgroundCanvas.attributedText = mutable
        if selectedRange.length > 0 {
            self.backgroundCanvas.selectedRange = selectedRange
        }
    }
    
    private func headIndentChange(_ size: CGFloat) {
        guard let (editRange, selectedRange) = getEditRange() else {
            return
        }
        guard let attri = self.backgroundCanvas.attributedText else {
            return
        }
        let mutable = HSTextService.setAttributedString(attri, headIndent: size, range: editRange)
        self.backgroundCanvas.attributedText = mutable
        if selectedRange.length > 0 {
            self.backgroundCanvas.selectedRange = selectedRange
        }
    }
    
    private func textAlignmentChange(_ alignment: NSTextAlignment) {
        guard let (editRange, selectedRange) = getEditRange() else {
            return
        }
        guard let attri = self.backgroundCanvas.attributedText else {
            return
        }
        let mutable = HSTextService.setAttributedString(attri, alignment: alignment, range: editRange)
        self.backgroundCanvas.attributedText = mutable
        if selectedRange.length > 0 {
            self.backgroundCanvas.selectedRange = selectedRange
        }
    }
    
    private func textLineSpacingChange(_ lineSpacing: CGFloat) {
        guard let (editRange, selectedRange) = getEditRange() else {
            return
        }
        guard let attri = self.backgroundCanvas.attributedText else {
            return
        }
        let mutable = HSTextService.setAttributedString(attri, lineSpacing: lineSpacing, range: editRange)
        self.backgroundCanvas.attributedText = mutable
        if selectedRange.length > 0 {
            self.backgroundCanvas.selectedRange = selectedRange
        }
    }
    
    // 获取编辑的Range
    private func getEditRange() -> (NSRange, NSRange)? {
        if self.backgroundCanvas.text.count < 1 {
            return nil
        }
        let range: NSRange = self.backgroundCanvas.selectedRange
        var targetRange: NSRange = range
        if targetRange.length < 1 {
            targetRange = NSRange.init(location: 0, length: self.backgroundCanvas.text.utf16.count)
        }
        return (targetRange, range)
    }
}

// MARK: Image 编辑
extension HSImageTextEditViewController {
    private func loadImageEditView() -> HSImageEditView {
        let imageEditView = HSImageEditView.init(frame: .zero)
        imageEditView.brightnessChangedClosure = {[weak self] (brightness) in
            self?.brightnessChanged(brightness)
        }
        imageEditView.contrastChangedClosure = {[weak self] (contrast) in
            self?.contrastChanged(contrast)
        }
        return imageEditView
    }
    
    /// 亮度
    /// - Parameter brightness: 亮度
    private func brightnessChanged(_ brightness: Float) {
        HSImageEditManager.imageEditShared.editImageEnd(brightness: brightness, contrast: nil)
    }
    
    /// 对比度
    /// - Parameter contrast: 对比度
    private func contrastChanged(_ contrast: Float) {
        HSImageEditManager.imageEditShared.editImageEnd(brightness: nil, contrast: contrast)
    }
}

// MARK: Alert
extension HSImageTextEditViewController {
    private func overHeightAlert() {
        let alert = UIAlertController.init(title: "", message: "超出视图边界", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
