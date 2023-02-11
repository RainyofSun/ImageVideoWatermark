//
//  HSTextStyleEditManager.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

public enum TextEditStyle {
case TextFont
case TextColor
case TextShadowColor
case TextStrokeColor
case TextShadowSize
case TextStrokeSize
}

// MARK: 单例 -- 修改文字样式管理类
class HSTextStyleEditManager: NSObject {
    
    var attributeStr: NSAttributedString?
    
    // 定义编辑回调处理
    typealias EditTextDoneHandler = (NSAttributedString) -> Void
    var editTextDoneHandler: EditTextDoneHandler?
    
    // 定义注销响应者回调处理
    typealias TextResignFirstHandler = () -> Void
    var textResignFirstHandler: TextResignFirstHandler?
    
    static let textEditShared = HSTextStyleEditManager.init()
    
    public func startEditText(attributed: NSAttributedString?, done: @escaping EditTextDoneHandler, resignFirst: @escaping TextResignFirstHandler) {
        self.attributeStr = attributed
        self.editTextDoneHandler = done
        if let resignHandler = self.textResignFirstHandler {
            resignHandler()
        }
        self.textResignFirstHandler = resignFirst
    }
    
    public func editTextEnd(attributedText: NSAttributedString) {
        self.editTextDoneHandler?(attributedText)
    }
    
    /// 结束编辑状态,清空管理类数据缓存
    public func endTextEditAndClearCacheData() {
        self.editTextDoneHandler = nil
        self.textResignFirstHandler = nil
    }
    
    /// 字符串的富文本改变全部以字符串的形式传递
    public func dealContentAttributeStyle(style: TextEditStyle, change: String) {
        switch style {
        case .TextFont:
            self.fontChange(change)
        case .TextStrokeColor:
            self.strokeColorChange(change)
        case .TextStrokeSize:
            self.strokeSizeChange(change)
        case .TextShadowColor,.TextShadowSize,.TextColor:
            break
        }
    }
    
    /// 字符串字体颜色的改变
    public func dealContentAttributeColorChange(textColor: UIColor) {
        self.textColorChange(textColor)
    }
    
    /// 字符串阴影改变
    public func dealContentAttributeShadowChange(textShadow: NSShadow) {
        self.shadowColorChange(textShadow)
    }
}

extension HSTextStyleEditManager {
    private func strokeSizeChange(_ strokeSize: String) {
        guard let attribute = attributeStr else {
            return
        }
        let mutable: NSAttributedString = HSTextService.setAttributedString(attribute, strokeWidth: CGFloat(Double(strokeSize) ?? 0), range: NSRange.init(location: 0, length: attribute.length))
        self.attributeStr = mutable
        editTextEnd(attributedText: mutable)
    }
    
    private func strokeColorChange(_ strokeColor: String) {
        guard let attribute = attributeStr else {
            return
        }
        let mutable: NSAttributedString = HSTextService.setAttributedString(attribute, strokeColor: UIColor.init(hexString: strokeColor), range: NSRange.init(location: 0, length: attribute.length))
        self.attributeStr = mutable
        editTextEnd(attributedText: mutable)
    }
    
    private func shadowColorChange(_ textShadow: NSShadow) {
        guard let attribute = attributeStr else {
            return
        }
        let mutable: NSAttributedString = HSTextService.setAttributedString(attribute, textShadow: textShadow, range: NSRange.init(location: 0, length: attribute.length))
        self.attributeStr = mutable
        editTextEnd(attributedText: mutable)
    }
    
    private func textColorChange(_ textColor: UIColor) {
        guard let attribute = attributeStr else {
            return
        }
        let mutable: NSAttributedString = HSTextService.setAttributedString(attribute, textColor: textColor, range: NSRange.init(location: 0, length: attribute.length))
        self.attributeStr = mutable
        editTextEnd(attributedText: mutable)
    }
    
    private func fontChange(_ fontName: String) {
        guard let attribute = attributeStr else {
            return
        }
        let mutable: NSAttributedString = HSTextService.setAttributedString(attribute, fontName: fontName, range: NSRange.init(location: 0, length: attribute.length))
        self.attributeStr = mutable
        editTextEnd(attributedText: mutable)
    }
    
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
