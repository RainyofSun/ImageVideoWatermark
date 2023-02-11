//
//  HSKeyboardTextView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/12.
//

import UIKit

class HSKeyboardTextView: HSPlaceHolderTextView, UITextViewDelegate {

    // 成为第一响应者回调
    public var becomeFirstResponsederClosure: (() -> Void)?
    // 注册第一响应者回调
    public var resignFirstResponsederClosure: (() -> Void)?
    // 高度变化回调
    public var textViewHeightChangeClosure: ((CGFloat) -> Void)?
    
    override func becomeFirstResponder() -> Bool {
        self.becomeFirstResponsederClosure?()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            self.resignFirstResponsederClosure?()
        }
        return result
    }
    //定义最大高度
    private var maxHeight:CGFloat = 60
    // 最大输入文字限制
    private let MaxLength = 100
    private var originalHeight: CGFloat = 0.0
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.textColor = .white
        
        self.delegate = self
        
        self.layer.contents = UIImage.init(named:"inputbg2")?.cgImage
        
        self.textContainerInset = UIEdgeInsets.init(top: 8, left: 0, bottom: 8, right: 40)
        self.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        originalHeight = frame.size.height
    }
    
    deinit {
        deallocPrint()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
        if text == "\n"{ // 输入换行符时收起键盘
            textView.resignFirstResponder() // 收起键盘
            return false
        }
        
        if text != "" {
             self.placeHoderLabel.isHidden = true // 隐藏
        }
        
        let textStr = NSString.init(format: "%@", text)
        if textStr.isEqual(to: "") && range.length == 1 && range.location == 0 {
            self.placeHoderLabel.isHidden = false // 隐藏
        }
        
        /// 字数统计
        let lengthOfString :NSInteger = textStr.length
        let fieldTextString : String = textView.text
        let proposedNewLength : Int =  fieldTextString.count - range.length + lengthOfString;
        
        if proposedNewLength >= MaxLength + 1 {
            print("已到字数限制")
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //获取frame值
        let frame = textView.frame
        //定义一个constrainSize值用于计算textview的高度
        let constrainSize = CGSize(width:frame.size.width,height:CGFloat(MAXFLOAT))
        //获取textview的真实高度
        var size = textView.sizeThatFits(constrainSize)
        //如果textview的高度大于最大高度高度就为最大高度并可以滚动，否则不能滚动
        if size.height >= maxHeight{
            size.height = maxHeight
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }
        // 如果新的高度大于之前的高度，再改变
        if size.height > originalHeight {
            //重新设置textview的高度约束
            self.textViewHeightChangeClosure?(size.height)
        }
    }
}
