//
//  HSPlaceHolderTextView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

import UIKit
import SnapKit

// MARK: 占位文字视图
class HSPlaceHolderTextView: UITextView {

    public var placeholder: String? {
        didSet {
            placeHoderLabel.text = placeholder
            guard let placehoderText = placeholder, !placehoderText.isEmpty else {
                self.placeHoderLabel.isHidden = true
                return
            }
            self.placeHoderLabel.isHidden = self.hasText
        }
    }

    // 是否允许进行编辑,默认不允许编辑
    public var isAllowedEdit: Bool = false {
        didSet {
            self.isEditable = isAllowedEdit
        }
    }
    
    override var text: String! {
        didSet {
            self.placeHoderLabel.isHidden = !text.isEmpty
        }
    }
    
    lazy var placeHoderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.isEditable = false
        self.loadSubViews()
        self.addNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeNotification()
        deallocPrint()
    }
    
    // MARK: Private Methods
    private func loadSubViews() {
        self.addSubview(placeHoderLabel)
        placeHoderLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textValueDidChanged(notification:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Notification
    @objc func textValueDidChanged(notification: Notification) {
        guard let placehoderText = placeholder,!placehoderText.isEmpty else {
            return
        }
        if let textView = notification.object as? HSPlaceHolderTextView {
            self.placeHoderLabel.isHidden = textView.hasText
        }
    }
}
