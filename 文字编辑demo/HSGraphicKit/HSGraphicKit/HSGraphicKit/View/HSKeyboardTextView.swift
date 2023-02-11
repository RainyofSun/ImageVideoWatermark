//
//  HSKeyboardTextView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/12.
//

import UIKit

class HSKeyboardTextView: HSPlaceHolderTextView {

    // 成为第一响应者回调
    public var becomeFirstResponsederClosure: (() -> Void)?
    // 注册第一响应者回调
    public var resignFirstResponsederClosure: (() -> Void)?
    
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
    
    deinit {
        deallocPrint()
    }

}
