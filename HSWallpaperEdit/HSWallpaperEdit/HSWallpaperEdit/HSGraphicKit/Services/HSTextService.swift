//
//  HSTextService.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

class HSTextService: NSObject {
    /// 修改字体
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - fontSize: 字体大小
    ///   - range: 设置范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, fontSize: CGFloat, range: NSRange?) -> NSAttributedString {
        var newRange: NSRange
        if let range = range {
            newRange = range
        } else {
            newRange = NSRange(location: 0, length: attributedString.length)
        }
        let newString = NSMutableAttributedString(attributedString: attributedString)
        attributedString.enumerateAttribute(.font, in: newRange, options: .longestEffectiveRangeNotRequired) { (font, fontRange, stop) in
            if let font = font as? UIFont {
                let newFont = font.withSize(fontSize)
                newString.addAttribute(.font, value: newFont, range: fontRange)
                newString.stripOriginalFont()
            }
        }
        return newString
    }
    
    /// 修改字体
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - fontName: 字体
    ///   - range: 设置范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, fontName: String, range: NSRange?) -> NSAttributedString {
        var newRange: NSRange
        if let range = range {
            newRange = range
        } else {
            newRange = NSRange(location: 0, length: attributedString.length)
        }
        let newString = NSMutableAttributedString(attributedString: attributedString)
        return newString.setFont(UIFont.init(name: fontName, size: DEFAULT_TEXT_FONT_SIZE) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize), range: newRange)
    }
    
    /// 修改文字颜色
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - fontName: 字体
    ///   - range: 设置范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, textColor: UIColor, range: NSRange?) -> NSAttributedString {
        var newRange: NSRange
        if let range = range {
            newRange = range
        } else {
            newRange = NSRange(location: 0, length: attributedString.length)
        }
        let newString = NSMutableAttributedString(attributedString: attributedString)
        return newString.setTextColor(textColor, range: newRange)
    }
    
    /// 设置加粗
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - isBold: 加粗
    ///   - range: 设置范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, isBold: Bool, range: NSRange?) -> NSAttributedString {
        let width: CGFloat = isBold ? -3 : 0
        return attributedString.setStrokeWidth(width, range: range)
    }
    
    /// 设置倾斜度
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - isObliqueness: 是否倾斜
    ///   - range: 设置范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, isObliqueness: Bool, range: NSRange?) -> NSAttributedString {
        let obliqueness: CGFloat = isObliqueness ? 0.3 : 0.0
        return attributedString.setObliqueness(obliqueness, range: range)
    }
    
    
    /// 设置下划线
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - isUnderline: 是否添加下划线
    ///   - range: 设置范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, isUnderline: Bool, range: NSRange?) -> NSAttributedString {
        let underlineStyle: Int = isUnderline ? NSUnderlineStyle.single.rawValue : 0
        return attributedString.setUnderlineStyle(underlineStyle, range: range)
    }
    
    /// 设置删除线样式
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - isStrikethrough: 是否添加删除线样式
    ///   - range: 设置范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, isStrikethrough: Bool, range: NSRange?) -> NSAttributedString {
        let strikethroughStyle: Int = isStrikethrough ? NSUnderlineStyle.single.rawValue : 0
        return attributedString.setStrikethroughStyle(strikethroughStyle, range: range)
    }
    
    
    /// 设置段落样式
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - lineSpacing: 行间距
    ///   - range: 范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, lineSpacing: CGFloat, range: NSRange?) -> NSAttributedString {
        var range = NSRange(location: 0, length: attributedString.length)
        let newParagraph = NSMutableParagraphStyle()
        if let paragraph = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: &range) {
            if let paragraph = paragraph as? NSParagraphStyle {
                newParagraph.setParagraphStyle(paragraph)
            }
        }
        newParagraph.lineSpacing = lineSpacing
        return attributedString.setParagraphStyle(newParagraph)
    }
    
    /// 设置段落样式
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - alignment: 对齐方式
    ///   - range: 范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, alignment: NSTextAlignment, range: NSRange?) -> NSAttributedString {
        var range = NSRange(location: 0, length: attributedString.length)
        let newParagraph = NSMutableParagraphStyle()
        if let paragraph = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: &range) {
            if let paragraph = paragraph as? NSParagraphStyle {
                newParagraph.setParagraphStyle(paragraph)
            }
        }
        newParagraph.alignment = alignment
        return attributedString.setParagraphStyle(newParagraph)
    }
    
    /// 设置段落样式
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - headIndent: 头缩进
    ///   - range: 范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, headIndent: CGFloat, range: NSRange?) -> NSAttributedString {
        var range = NSRange(location: 0, length: attributedString.length)
        let newParagraph = NSMutableParagraphStyle()
        if let paragraph = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: &range) {
            if let paragraph = paragraph as? NSParagraphStyle {
                newParagraph.setParagraphStyle(paragraph)
            }
        }
        newParagraph.firstLineHeadIndent = headIndent
        newParagraph.headIndent = headIndent
        return attributedString.setParagraphStyle(newParagraph)
    }
    
    /// 设置字符间距
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - kernNum: 字符间距
    ///   - range: 范围
    /// - Returns: 结果属性字符串
    static func setAttributeString(_ attributedString: NSAttributedString, kernNum: CGFloat, range: NSRange?) -> NSAttributedString {
        return attributedString.setKernStyle(kernNum, range: range)
    }
    
    /// 设置字符描边 负值实心描边 正直空心描边 0 无效果
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - strokeWidth: 描边宽度
    ///   - range: 范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, strokeWidth: CGFloat, range: NSRange?) -> NSAttributedString {
        return attributedString.setStrokeWidth(strokeWidth, range: range)
    }
    
    /// 设置字符描边颜色
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - strokeColor: 描边颜色
    ///   - range: 范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributedString: NSAttributedString, strokeColor: UIColor, range: NSRange?) -> NSAttributedString {
        return attributedString.setStrokeColor(strokeColor, range: range)
    }
    
    /// 设置字符阴影
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - textShadow: 阴影
    ///   - range: 范围
    /// - Returns: 结果属性字符串
    static func setAttributedString(_ attributeString: NSAttributedString, textShadow: NSShadow, range: NSRange?) -> NSAttributedString {
        let shadow: NSShadow = NSShadow.init()
        shadow.shadowOffset = textShadow.shadowOffset
        shadow.shadowColor = textShadow.shadowColor
        shadow.shadowBlurRadius = textShadow.shadowBlurRadius
        return attributeString.setShadowStyle(shadow, range: range)
    }
    
    /// 设置字符拉伸
    /// - Parameters:
    ///   - attributedString: 属性字符串
    ///   - expansionNum: 字符拉伸 正值横向拉伸，负值横向压缩，默认0（不拉伸）
    ///   - range: 范围
    /// - Returns: 结果属性字符串
    static func setAttributeString(_ attributeString: NSAttributedString, expansionNum: CGFloat, range: NSRange?) -> NSAttributedString {
        return attributeString.setExpansionStyle(expansionNum, range: range)
    }
}
