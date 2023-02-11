//
//  HSTextInputManager.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/12.
//

import UIKit

// MARK: 文字框输入时键盘和文字处理,单例 -- 管理多个EditContentView的文字输入
class HSTextInputManager: NSObject {
    public lazy var textInputView: HSKeyboardInputView = {
        let view = HSKeyboardInputView.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 70))
        view.confirmClosure = {[weak self] (text) in
            self?.inputDone(text: text)
        }
        view.resignFirstClosure = {[weak self] in
            self?.resignFirst()
        }
        view.updateInputViewConstant = {[weak self] (height: CGFloat) in
            self?.updateInputViewConstant(height: height)
        }
        return view
    }()
    
    // 定义输入回调处理
    typealias InputDoneHandler = (String) -> Void
    var inputDoneHandler: InputDoneHandler?
    
    // 定义输入回调处理
    typealias ResignFirstHandler = () -> Void
    var resignFirstHandler: ResignFirstHandler?
    
    static let inputShared = HSTextInputManager.init()
    override init() {}
    
    public func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhiden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 键盘弹出将要输入,当输入框为第一响应者时,editContentView也需要边框
    public func startInputText(text: String, done: @escaping InputDoneHandler, resignFirst: @escaping ResignFirstHandler) {
        self.inputDoneHandler = done
        if let resignHandler = self.resignFirstHandler {
            resignHandler()
        }
        self.resignFirstHandler = resignFirst
        self.addKeyboardObserver()
        getWindow().addSubview(textInputView)
        textInputView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(70)
        }
        textInputView.text = text == "添加文字" ? "" : text
    }
    
    // 点击确定 输入结束
    public func inputDone(text: String) {
        self.inputDoneHandler?(text)
        textInputView.removeFromSuperview()
        self.removeKeyboardObserver()
    }
    
    // 被动结束输入: 即点击其他视图元素（包括背景）editContentView 会统一resignFirst
    // 当单击self.editContentView，editContentView会先resignFirst，再becomeFirst
    public func resignFirst() {
        self.resignFirstHandler?()
        self.removeKeyboardObserver()
        UIView.animate(withDuration: 0.3) {
            self.textInputView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        } completion: { isFinished in
            self.textInputView.removeFromSuperview()
        }
    }
    
    // 释放内存引用
    public func freeRefrence() {
        self.resignFirstHandler = nil
        self.removeKeyboardObserver()
        self.textInputView.removeFromSuperview()
    }
    
    private func updateInputViewConstant(height: CGFloat) {
        self.textInputView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
    }
}

// MARK: 键盘监听 控制输入框高度
extension HSTextInputManager{

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        if let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.5) {
                self.textInputView.transform = CGAffineTransform.init(translationX: 0, y: -keyboardRect.size.height)
            }
        }
    }
    
    @objc func keyboardWillhiden(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        if let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.5) {
                self.textInputView.transform = CGAffineTransform.init(translationX: 0, y: 0)
            }
        }
    }
}
