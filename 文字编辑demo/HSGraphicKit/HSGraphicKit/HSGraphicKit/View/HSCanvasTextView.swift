//
//  HSCanvasTextView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

import UIKit

// MARK: 背景画布,所有编辑元素均添加到此图层上
class HSCanvasTextView: HSPlaceHolderTextView {

    // 成为第一响应者回调
    public var willBecomeFirstResponderClosure: (() -> Void)?
    // 注销第一响应者回调
    public var resignFirstResponderClosure: (() -> Void)?
    
    // 每次点击TextView 都会调用becomeFirstResponder
    override func becomeFirstResponder() -> Bool {
        self.willBecomeFirstResponderClosure?()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            self.resignFirstResponderClosure?()
        }
        return result
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.delaysContentTouches = false
        self.canCancelContentTouches = true
        self.bounces = false
        self.textColor = .black
        self.showsVerticalScrollIndicator = false
        self.textContainerInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            let textContentSize = self.sizeThatFits(CGSize.init(width: self.frame.width, height: CGFloat(MAXFLOAT)))
            var contentRect = CGRect.zero
            for view in self.subviews {
                if view is HSBaseEditView {
                    contentRect = contentRect.union(view.frame)
                    break
                }
            }
            contentRect.size.width = self.frame.width
            if contentRect.size.height < self.frame.height {
                contentRect.size.height = self.frame.height + 1
            } else {
                contentRect.size.height += 10
            }
            if textContentSize.height > contentRect.size.height {
                contentRect.size.height = textContentSize.height + 10
            }
            UIView.animate(withDuration: 0.2) {
                self.contentSize = contentRect.size
            }
        }
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is HSBaseEditView {
            return false
        }
        return true
    }
    
    deinit {
        deallocPrint()
    }
}

// MARK: 文本计算
extension HSCanvasTextView {
    // 返回文本内容 topInset + textHeight + margin高度
    public func getTextContentHeight() -> CGFloat {
        let attri = self.attributedText
        let padding = self.textContainer.lineFragmentPadding
        let width = self.frame.width - 2 * padding - 20
        let size = attri?.hs_sizeFittingWidth(width)
        return ceil((size?.height ?? 0) + self.textContainerInset.top + 10)
    }
    
    // 文本和EditView 相比较,获取TextView的最大的ContentSize
    public func getMaxContentSize() -> CGSize {
        var contentRect = CGRect.zero
        for view in self.subviews {
            if view is HSBaseEditView {
                contentRect = contentRect.union(view.frame)
            }
        }
        contentRect.size.width = frame.width
        let textContentHeight = getTextContentHeight()
        if textContentHeight > contentRect.height {
            // 文字获取的带有Padding需要返回 + 20
            contentRect.size.height = textContentHeight + 20
        } else {
            // 加 Margin 10
            contentRect.size.height += 10
        }
        return contentRect.size
    }
    
    // 依据新视图的Size 计算出新的TextView 的contentSize和新视图的frame
    // - parameter size: 新视图的Size
    // - returns: 新视图的Frame
    public func getContentBottomPoint(size: CGSize) -> CGRect {
        var contentRect = getMaxContentSize()
        let origin = CGPoint.init(x: (contentRect.width - size.width) * 0.5, y: contentRect.height)
        let frame = CGRect.init(origin: origin, size: size)
        contentRect.height += size.height
        self.contentSize = contentRect
        
        let offset = self.contentSize.height - self.bounds.height
        if offset > 0 {
            self.setContentOffset(CGPoint.init(x: 0, y: offset), animated: true)
        }
        return frame
    }
    
    public func getNSRange(_ from: UITextRange) -> NSRange {
        let beginning = self.beginningOfDocument
        let start = from.start
        let end = from.end
        let location = self.offset(from: beginning, to: start)
        let length = self.offset(from: start, to: end)
        return NSRange.init(location: location, length: length)
    }
    
    public func getTextRange(_ from: NSRange) -> UITextRange? {
        let beginning = self.beginningOfDocument
        guard let start = self.position(from: beginning, offset: from.location) else {
            return nil
        }
        guard let end = self.position(from: start, offset: from.length) else {
            return nil
        }
        return self.textRange(from: start, to: end)
    }
}
