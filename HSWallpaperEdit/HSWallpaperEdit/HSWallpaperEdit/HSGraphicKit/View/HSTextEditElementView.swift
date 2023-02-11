//
//  HSTextEditElementView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

// MARK: 文本框编辑View 个别事件交互需要重写
class HSTextEditElementView: HSBaseEditView {
    
    // 文本编辑拖动时,是否开启放大缩小;若不开启,则拖动过程中只改变宽高,不放大缩小,宽度变化,高度自适应;默认开启状态
    public var scaleTextEditView: Bool = true
    // 点击展示编辑菜单回调
    typealias ShowEditMenuClousre = ((HSTextEditElementView,HSEditTagView) -> Void)
    var showEditMenuClousre: ShowEditMenuClousre?
    
    var originSize: CGSize = .zero
    
    deinit {
        deallocPrint()
    }
    
    // 双击文本框快速开始编辑文字
    public func editContentText() {
        let text = contentView.text ?? ""
        HSTextInputManager.inputShared.startInputText(text: text) { [weak self] (text) in
            self?.contentView.text = text
            let _ = self?.becomeFirstResponder()
            self?.updateSize()
        } resignFirst: { [weak self] in
            self?.resginActive()
        }
        // 当输入框为第一响应者时，editContentView也需要边框)
        self.becomeActive()
    }
    
    // 编辑文本框样式
    public func editTextStyle(editStyle: TextEditStyle, change: String) {
        let attributedStr = contentView.textLabel.attributedText
        HSTextStyleEditManager.textEditShared.startEditText(attributed: attributedStr) { [weak self] (attributedText) in
            self?.contentView.textLabel.attributedText = attributedText
            self?.updateSize()
        } resignFirst: { [weak self] in
            self?.resginActive()
        }
        // 当输入框为第一响应者时,editContentView也需要边框
        self.becomeActive()
        HSTextStyleEditManager.textEditShared.dealContentAttributeStyle(style: editStyle, change: change)
    }
    
    // 编辑文本颜色变化
    public func editTextColor(textColor: UIColor) {
        let attributedStr = contentView.textLabel.attributedText
        HSTextStyleEditManager.textEditShared.startEditText(attributed: attributedStr) { [weak self] (attributedText) in
            self?.contentView.textLabel.attributedText = attributedText
            self?.updateSize()
        } resignFirst: { [weak self] in
            self?.resginActive()
        }
        // 当输入框为第一响应者时,editContentView也需要边框
        self.becomeActive()
        HSTextStyleEditManager.textEditShared.dealContentAttributeColorChange(textColor: textColor)
    }
    
    // 编辑文本Shadow变化
    public func editTextShadow(textShadow: NSShadow) {
        let attributedStr = contentView.textLabel.attributedText
        HSTextStyleEditManager.textEditShared.startEditText(attributed: attributedStr) { [weak self] (attributedText) in
            self?.contentView.textLabel.attributedText = attributedText
            self?.updateSize()
        } resignFirst: { [weak self] in
            self?.resginActive()
        }
        // 当输入框为第一响应者时,editContentView也需要边框
        self.becomeActive()
        HSTextStyleEditManager.textEditShared.dealContentAttributeShadowChange(textShadow: textShadow)
    }
    
    private func updateSize() {
        let bounds = self.bounds
        var center = self.center
        if center.y < 0 {
            center.y = 0
        }
        
        let labWidth = contentView.labelWidth
        let labHeight = contentView.getLabelHeight(width: labWidth)
        let allHeight = labHeight + contentLayoutConstant * 2;
        
        let newSize = CGSize.init(width: bounds.width, height: allHeight)
        let origin = bounds.origin
        UIView.animate(withDuration: 0.2) {
            self.bounds = CGRect.init(origin: origin, size: newSize)
            self.center = center
        }
    }
}

// MARK: 重写部分手势
extension HSTextEditElementView {
    // 覆写双击手势,快速开始文字输入
    override func doubleTapHandle(sender: UITapGestureRecognizer) {
        super.doubleTapHandle(sender: sender)
        // 开始文字输入
        self.editContentText()
    }
    
    // 覆写单击手势选中元素
    override func singleTapHandle(sender: UITapGestureRecognizer) {
        super.singleTapHandle(sender: sender)
    }
    
    // 覆写tagView的点击手势开始编辑
    override func tagViewTapHandle(sender: UITapGestureRecognizer) {
        super.tagViewTapHandle(sender: sender)
        // 弹出编辑菜单
        self.showEditMenuClousre?(self,self.topRightTagView)
    }
    
    // 覆写拖拽缩放手势
    override func panScaleHandle(_ sender: UIPanGestureRecognizer) {
        if scaleTextEditView {
            super.panScaleHandle(sender)
        }
        let location = sender.location(in: self)
        switch sender.state {
        case.began:
            panScaleBeginPoint = location
            originSize = self.bounds.size
            break
        case.changed:
            let bounds = self.bounds
            var center = self.center
            if center.y < 0 {
                center.y = 0
            }
            let changeX = location.x - panScaleBeginPoint.x
            let newWidth = originSize.width + changeX
            let labelWidth = newWidth - contentLayoutConstant * 2 - contentLabelLeftConstant * 2
            if labelWidth < minTextContentLayoutWidthConstant {
                return
            }
            let labelHeight = contentView.getLabelHeight(width: labelWidth)
            let allHeight = labelHeight + contentLayoutConstant * 2
            let newSize = CGSize.init(width: newWidth, height: allHeight)
            let origin = bounds.origin
            UIView.animate(withDuration: 0.2) {
                self.bounds = CGRect.init(origin: origin, size: newSize)
                self.center = center
            }
            break
        default:
            break
        }
    }
}
