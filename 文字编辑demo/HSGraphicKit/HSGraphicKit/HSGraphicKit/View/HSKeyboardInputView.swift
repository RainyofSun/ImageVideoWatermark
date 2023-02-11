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
    
    // 最大输入文字限制
    private let barMaxLength = 30
    private lazy var textView: HSKeyboardTextView = {
        let view = HSKeyboardTextView()
        view.resignFirstResponsederClosure = {[weak self] in
            self?.resignFirstClosure?()
        }
        view.font = UIFont.systemFont(ofSize: 14)
        view.backgroundColor = HSBGColor
        view.textColor = .black
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.isAllowedEdit = true
        return view
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = HSLayerColor
        button.setImage(UIImage.init(named: "icon_btn_coficton_default"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(checkText), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = HSTOPLineColor
        return view
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
        self.backgroundColor = .white
        self.addSubview(lineView)
        self.addSubview(textView)
        self.addSubview(submitButton)
    }
    
    private func layoutInputSubviews() {
        lineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.right.bottom.equalTo(-10)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        textView.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(self.submitButton.snp.left).offset(-10)
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
        guard text.utf16.count <= barMaxLength else {
            print("文字超出最大长度")
            return
        }
        self.confirmClosure?(text)
    }
}
