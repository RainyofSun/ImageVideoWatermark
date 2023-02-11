//
//  HSVideoTextWatermarkModel.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/13.
//

import UIKit

// MARK: 文本水印信息
class HSVideoTextWatermarkModel: HSVideoWatermarkInfoModel {
    // 富文本信息
    var attributedString: NSAttributedString?
    // 富文本字号 --> 标签缩放之后需要重新对富文本字体字号进行仿射变化
    var attributeFontSize: CGFloat?
    
    /// 对富文本字体进行仿射变化
    public func transformAttributeString() -> NSAttributedString {
        let finalSize: CGSize = self.getTransformSize()
        var widthScale: CGFloat = 0.0
        var heightScale: CGFloat = 0.0
        if let originalViewSize = self.originalSize {
            widthScale = finalSize.width / originalViewSize.width
            heightScale = finalSize.height / originalViewSize.height
        }
        let fontDes: UIFontDescriptor = UIFontDescriptor.init()
        let matrixFontDes: UIFontDescriptor = fontDes.withMatrix(CGAffineTransform.init(scaleX: widthScale, y: heightScale))
        let matrixFont: UIFont = UIFont.init(descriptor: matrixFontDes, size: attributeFontSize!)
        let matrixAttributeStr: NSMutableAttributedString = NSMutableAttributedString.init(attributedString: attributedString!)
        matrixAttributeStr.addAttribute(.font, value: matrixFont, range: NSRange.init(location: 0, length: attributedString!.length))
        return matrixAttributeStr.copy() as! NSAttributedString
    }
    
    deinit {
        deallocPrint()
    }
}
