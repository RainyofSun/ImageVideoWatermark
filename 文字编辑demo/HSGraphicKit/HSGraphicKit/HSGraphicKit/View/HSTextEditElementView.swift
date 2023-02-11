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
    
    var originSize: CGSize = .zero
    
    deinit {
        deallocPrint()
    }
    
    func updateSize() {
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
        } completion: { isFinshed in
            self.setTextLabelFrame(width: labWidth, height: labHeight)
        }
    }
    
    private func setTextLabelFrame(width: CGFloat, height: CGFloat) {
        let x = self.frame.origin.x + self.contentLayoutConstant + self.contentLabelLeftConstant
        let y = self.frame.origin.y + self.contentLayoutConstant
        let labelFrame = CGRect.init(x: x, y: y, width: width, height: height)
        self.viewModel.frame = labelFrame
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
        // 若图片正处于编辑状态,结束图片的编辑态
        HSImageEditManager.imageEditShared.endImageEditAndClearCacheData()
        // 快速切换两个文本元素的编辑态
        self.continueEditTextContent()
    }
    
    // 覆写tagView的点击手势开始编辑
    override func tagViewTapHandle(sender: UITapGestureRecognizer) {
        super.tagViewTapHandle(sender: sender)
        // 开始文字样式修改
        self.editTextStyle()
    }
    
    // 覆写拖拽缩放手势
    override func panScaleHandle(_ sender: UIPanGestureRecognizer) {
        if scaleTextEditView {
            super.panScaleHandle(sender)
            return
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
            if labelWidth < minContentLayoutWidthConstant {
                return
            }
            let labelHeight = contentView.getLabelHeight(width: labelWidth)
            let allHeight = labelHeight + contentLayoutConstant * 2
            
            let newSize = CGSize.init(width: newWidth, height: allHeight)
            let origin = bounds.origin
            UIView.animate(withDuration: 0.2) {
                self.bounds = CGRect.init(origin: origin, size: newSize)
                self.center = center
            } completion: { isFinished in
                self.setTextLabelFrame(width: labelWidth, height: labelHeight)
            }
            break
        default:
            break
        }
    }
    
    // 双击文本框快速开始编辑文字
    private func editContentText() {
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
    private func editTextStyle() {
        let attributedStr = contentView.textLabel.attributedText
        HSTextStyleEditManager.textEditShared.startEditText(attributed: attributedStr) { [weak self] (attributedText) in
            self?.contentView.textLabel.attributedText = attributedText
            self?.updateSize()
        } resignFirst: { [weak self] in
            self?.resginActive()
        }
        // 当输入框为第一响应者时,editContentView也需要边框
        self.becomeActive()
    }
    
    // 快速切换两个文本元素的编辑状态
    private func continueEditTextContent() {
        let attributeStr = contentView.textLabel.attributedText
        HSTextStyleEditManager.textEditShared.continueEdit(attributed: attributeStr) { [weak self] (attributedText) in
            self?.contentView.textLabel.attributedText = attributedText
            self?.updateSize()
        } resignFirst: { [weak self] in
            self?.resginActive()
        }
    }
}
