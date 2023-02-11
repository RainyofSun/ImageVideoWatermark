//
//  HSKeyboardInputView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/12.
//

import UIKit

class HSKeyboardInputView: UIView {
    
    public var text: String? {
        didSet {
            textView.text = text
            let _ = textView.becomeFirstResponder()
        }
    }
    
    // 确定提交
    public var confirmClosure: ((String) -> Void)?
    // 当注销第一响应者成功时回调
    public var resignFirstClosure: (() -> Void)?
    // 更新约束
    public var updateInputViewConstant: ((CGFloat) -> Void)?
    
    // 文本框初始高度
    private let inputTextViewHeight: CGFloat = 40
    
    private lazy var deleteBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "delete_input"), for: .normal)
        view.setImage(UIImage.init(named: "delete_input"), for: .highlighted)
        return view
    }()
    
    private lazy var textView: HSKeyboardTextView = {
        let view = HSKeyboardTextView()
        view.resignFirstResponsederClosure = {[weak self] in
            self?.resignFirstClosure?()
        }
        view.textViewHeightChangeClosure = {[weak self] (diff: CGFloat) in
            self?.changeFrame(diff: diff)
        }
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        view.font = UIFont.systemFont(ofSize: 15)
        view.backgroundColor = HSMainBGColor
        view.isAllowedEdit = true
        return view
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "icon_confirm"), for: .normal)
        button.setImage(UIImage.init(named: "icon_confirm"), for: .highlighted)
        button.addTarget(self, action: #selector(checkText), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadInputViews()
        self.layoutInputSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }

    private func loadInputViews() {
        self.layer.contents = UIImage.init(named:"inputbg1")?.cgImage
        deleteBtn.addTarget(self, action: #selector(deleteAllText(sender:)), for: .touchUpInside)
        self.addSubview(textView)
        self.addSubview(deleteBtn)
        self.addSubview(submitButton)
    }
    
    private func layoutInputSubviews() {
        
        submitButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        textView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.height.equalTo(inputTextViewHeight)
            make.right.equalTo(self.submitButton.snp.left).offset(-8)
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalTo(textView)
            make.right.equalTo(self.textView.snp.right).offset(-10)
            make.size.equalTo(deleteBtn.currentImage!.size)
        }
    }
    
    private func changeFrame(diff: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.updateInputViewConstant?(diff + 30)
            self.textView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(10)
                make.right.equalTo(self.submitButton.snp.left).offset(-8)
                make.height.equalTo(diff)
            }
        } completion: { _ in
            self.layoutIfNeeded()
        }
    }
}

// MARK: Target
extension HSKeyboardInputView {
    @objc private func checkText() {
        guard let text = self.textView.text, !text.isEmpty else {
            self.confirmClosure?("")
            return
        }
        self.confirmClosure?(text)
    }
    
    @objc private func deleteAllText(sender: UIButton) {
        self.text = ""
        self.changeFrame(diff: inputTextViewHeight)
    }
}
