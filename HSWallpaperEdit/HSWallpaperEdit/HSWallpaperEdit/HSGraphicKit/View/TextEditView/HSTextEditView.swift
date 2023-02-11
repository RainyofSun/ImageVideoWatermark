//
//  HSTextEditView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

// MARK: 文字编辑界面
class HSTextEditView: UIView {

    // 文本编辑回调
    // 文字大小
    var textFontSizeChanged: ((CGFloat) -> Void)?
    // 文字样式
    var textStyleChanged: ((HSTextStyleEditView.TextStyle, Bool) -> Void)?
    
    // 头缩进
    var textHeadIndentChanged: ((_ size: CGFloat) -> Void)?
    // 排版
    var textAlignmentChanged: ((_ alignment: NSTextAlignment) -> Void)?
    // 行高
    var textLineSpacingChanged: ((_ spacing: CGFloat) -> Void)?
    
    var textAttributeStrChangedClosure: ((NSAttributedString) -> Void)?
    
    var showAlignment: Bool = true {
        didSet {
            if !showAlignment {
                textAlignmentButton.isHidden = true
            }
        }
    }
    
    lazy var textStyleButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_fontstyle_default"), for: .normal)
        view.addTarget(self, action: #selector(clickTextStyle), for: .touchUpInside)
        let color = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)
        view.setBackgroundImage(UIImage.ge_createImage(color: color), for: .normal)
        view.setBackgroundImage(UIImage.ge_createImage(color: UIColor.white), for: .selected)
        view.isSelected = true
        return view
    }()
    lazy var textAlignmentButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_align_default"), for: .normal)
        view.addTarget(self, action: #selector(clickTextAlignment), for: .touchUpInside)
        let color = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)
        view.setBackgroundImage(UIImage.ge_createImage(color: color), for: .normal)
        view.setBackgroundImage(UIImage.ge_createImage(color: UIColor.white), for: .selected)
        return view
    }()
    
    lazy var textStyleEditView: HSTextStyleEditView = {
        let view = HSTextStyleEditView.init(frame: CGRect.zero)
        view.sizeChange = {[weak self] (size) in
            self?.textFontSizeChanged?(size)
        }
        view.styleChange = {[weak self] (style, isSelected) in
            self?.textStyleChanged?(style, isSelected)
        }
        return view
    }()
    
    lazy var textAlignmentEditView: HSTextAlignmentEditView = {
        let view = HSTextAlignmentEditView.init(frame: CGRect.zero)
        view.headIndentChange = {[weak self] (size) in
            self?.textHeadIndentChanged?(size)
        }
        view.textAlignmentChange = {[weak self] (alignment) in
            self?.textAlignmentChanged?(alignment)
        }
        view.lineSpacingChange = {[weak self] (spacing) in
            self?.textLineSpacingChanged?(spacing)
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadTextEditViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutTextEditSubviews()
    }
    
    deinit {
        deallocPrint()
    }
 
    private func loadTextEditViews() {
        self.backgroundColor = .white
        self.addSubview(textStyleButton)
        self.addSubview(textAlignmentButton)
        self.addSubview(textStyleEditView)
        self.addSubview(textAlignmentEditView)
    }
    
    private func layoutTextEditSubviews() {
        let buttonWidth: CGFloat = 48.0
        let buttonHeight: CGFloat = 98.0
        
        textStyleButton.frame = CGRect.init(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        textAlignmentButton.frame = CGRect.init(x: 0, y: buttonHeight, width: buttonWidth, height: buttonHeight)
        textStyleEditView.frame = CGRect.init(x: buttonWidth, y: 0, width: self.frame.width - buttonWidth, height: self.frame.height)
        textAlignmentEditView.frame = CGRect.init(x: buttonWidth, y: 0, width: self.frame.width - buttonWidth, height: self.frame.height)
    }
}

// MARK: Target
extension HSTextEditView {
    @objc func clickTextStyle() {
        guard !textStyleButton.isSelected else {
            return
        }
        textStyleButton.isSelected = true
        textAlignmentButton.isSelected = false
        textStyleEditView.isHidden = false
        textAlignmentEditView.isHidden = true
    }
    
    @objc func clickTextAlignment() {
        guard !textAlignmentButton.isSelected else {
            return
        }
        textStyleButton.isSelected = false
        textAlignmentButton.isSelected = true
        textStyleEditView.isHidden = true
        textAlignmentEditView.isHidden = false
    }
}
