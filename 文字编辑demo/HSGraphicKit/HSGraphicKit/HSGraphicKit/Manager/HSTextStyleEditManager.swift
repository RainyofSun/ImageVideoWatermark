//
//  HSTextStyleEditManager.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

// MARK: 单例 -- 修改文字样式管理类
class HSTextStyleEditManager: NSObject {
    
    var toolBar: HSToolBar?
    var attributeStr: NSAttributedString?
    
    // 定义编辑回调处理
    typealias EditTextDoneHandler = (NSAttributedString) -> Void
    var editTextDoneHandler: EditTextDoneHandler?
    
    // 定义注销响应者回调处理
    typealias TextResignFirstHandler = () -> Void
    var textResignFirstHandler: TextResignFirstHandler?
    
    static let textEditShared = HSTextStyleEditManager.init()
    
    public func textBoxEditView() -> HSTextEditView {
        let editTextView = HSTextEditView.init(frame: .zero)
        editTextView.textFontSizeChanged = {[weak self] (size) in
            self?.fontSizeChange(size)
        }
        editTextView.textStyleChanged = {[weak self] (style, isSelected) in
            self?.textStyleChange(style, isSelected)
        }
        editTextView.textHeadIndentChanged = {[weak self] (size) in
            self?.textHeadIndentChange(size)
        }
        editTextView.textAlignmentChanged = {[weak self] (alignment) in
            self?.textAlignmentChange(alignment)
        }
        editTextView.textLineSpacingChanged = {[weak self] (lineSpacing) in
            self?.textLineSpacingChange(lineSpacing)
        }
        return editTextView
    }
    
    public func startEditText(attributed: NSAttributedString?, done: @escaping EditTextDoneHandler, resignFirst: @escaping TextResignFirstHandler) {
        self.attributeStr = attributed
        self.editTextDoneHandler = done
        if let resignHandler = self.textResignFirstHandler {
            resignHandler()
        }
        self.textResignFirstHandler = resignFirst
        self.toolBar?.setSelected(index: 1)
    }
    
    public func continueEdit(attributed: NSAttributedString?, done: @escaping EditTextDoneHandler, resignFirst: @escaping TextResignFirstHandler) {
        if self.toolBar?.currentIndex == 1 {
            self.attributeStr = attributed
            self.editTextDoneHandler = done
            self.textResignFirstHandler = resignFirst
        } else {
            self.endTextEditAndClearCacheData()
        }
    }
    
    public func editTextEnd(attributedText: NSAttributedString) {
        self.editTextDoneHandler?(attributedText)
    }
    
    // 结束编辑状态,清空管理类数据缓存
    public func endTextEditAndClearCacheData() {
        self.editTextDoneHandler = nil
        self.textResignFirstHandler = nil
        self.toolBar?.hide()
    }
}

extension HSTextStyleEditManager {
    private func fontSizeChange(_ size: CGFloat) {
        guard let attributed = attributeStr else {
            return
        }
        let mutable = HSTextService.setAttributedString(attributed, fontSize: size, range: NSRange.init(location: 0, length: attributed.length))
        self.attributeStr = mutable
        editTextEnd(attributedText: mutable)
    }
    
    private func textStyleChange(_ style: HSTextStyleEditView.TextStyle, _ isSeledcted: Bool) {
        guard let attributed = attributeStr else {
            return
        }
        let range = NSRange.init(location: 0, length: attributed.length)
        var mutable: NSAttributedString
        switch style {
        case .bold:
            mutable = HSTextService.setAttributedString(attributed, isBold: isSeledcted, range: range)
        case .obliqueness:
            mutable = HSTextService.setAttributedString(attributed, isObliqueness: isSeledcted, range: range)
        case .strikethrough:
            mutable = HSTextService.setAttributedString(attributed, isStrikethrough: isSeledcted, range: range)
        case .underline:
            mutable = HSTextService.setAttributedString(attributed, isUnderline: isSeledcted, range: range)
        }
        self.attributeStr = mutable
        editTextEnd(attributedText: mutable)
    }
    
    private func textHeadIndentChange(_ size: CGFloat) {
        guard let attributed = attributeStr else {
            return
        }
        let range = NSRange.init(location: 0, length: attributed.length)
        let mutable = HSTextService.setAttributedString(attributed, headIndent: size, range: range)
        editTextEnd(attributedText: mutable)
    }
    
    private func textAlignmentChange(_ alignment: NSTextAlignment) {
        guard let attributed = attributeStr else {
            return
        }
        let range = NSRange.init(location: 0, length: attributed.length)
        let mutable = HSTextService.setAttributedString(attributed, alignment: alignment, range: range)
        editTextEnd(attributedText: mutable)
    }
    
    private func textLineSpacingChange(_ lineSpacing: CGFloat) {
        guard let attributed = attributeStr else {
            return
        }
        let range = NSRange.init(location: 0, length: attributed.length)
        let mutable = HSTextService.setAttributedString(attributed, lineSpacing: lineSpacing, range: range)
        editTextEnd(attributedText: mutable)
    }
}
