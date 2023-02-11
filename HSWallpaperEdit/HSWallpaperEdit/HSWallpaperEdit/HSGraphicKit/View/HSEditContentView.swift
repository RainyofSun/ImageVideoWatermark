//
//  HSEditContentView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

import UIKit

// MARK: 图文编辑的主体内容
class HSEditContentView: UIView {

    var editType: HSEditType = .TEXT
    let minLabelHeight: CGFloat = 50

    // 编辑样式回调
    public var editTextStyleClosure: (() -> Void)?
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.attributedText = defaultAttribute()
        label.numberOfLines = 0
        if let attri = label.attributedText {
            label.attributedText = attributesAddParagraphStyle(attri: attri)
        }
        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    public var text: String? {
        set {
            if newValue?.isEmpty ?? true {
                textLabel.text = DEFAULT_TEXT
            } else {
                textLabel.text = newValue
            }
            if let attri = textLabel.attributedText {
                textLabel.attributedText = attributesAddParagraphStyle(attri: attri)
            }
        }
        get {
            return textLabel.text
        }
    }
    
    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    public var labelWidth: CGFloat {
        get {
            return textLabel.bounds.width
        }
    }
    
    init(frame: CGRect, editType: HSEditType) {
        super.init(frame: frame)
        self.editType = editType
        self.loadUI()
        self.loadSubViews()
        self.layoutSubview()
    }
    
    private func layoutSubview() {
        if editType == .TEXT {
            textLabel.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(10)
                make.right.equalTo(-10)
            }
        }
        if editType == .IMAGE {
            imageView.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(5)
                make.bottom.right.equalToSuperview().offset(-5)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func getLabelHeight(width: CGFloat) -> CGFloat {
        let size = calculateTextSize(text: text ?? DEFAULT_TEXT, maxSize: CGSize.init(width: width, height: CGFloat(MAXFLOAT)))
        return size.height < minLabelHeight ? minLabelHeight : (size.height + 3)
    }
    
    private func loadUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    private func loadSubViews() {
        if editType == .TEXT {
            self.addSubview(self.textLabel)
        }
        if editType == .IMAGE {
            self.addSubview(self.imageView)
        }
    }
    
    private func calculateTextSize(text: String, maxSize: CGSize) -> CGSize {
        var size = CGSize.zero
        if let attri = self.textLabel.attributedText {
            size = attri.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
        } else {
            let textNS = text as NSString
            size = textNS.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)], context: nil).size
        }
        return size
    }
    
    private func defaultAttribute() -> NSAttributedString {
        let font: UIFont = UIFont.init(name: DEFAULT_TEXT_FONT_NAME, size: DEFAULT_TEXT_FONT_SIZE)!
        let color: UIColor = .white
        let attriStr: NSAttributedString = NSAttributedString.init(string: DEFAULT_TEXT, attributes: [.font:font,.foregroundColor:color])
        return attriStr
    }
    
    private func attributesAddParagraphStyle(attri: NSAttributedString) -> NSAttributedString {
        var range = NSRange.init(location: 0, length: attri.length)
        let newParagraph = NSMutableParagraphStyle.init()
        newParagraph.alignment = .center
        if let paragraph = attri.attribute(.paragraphStyle, at: 0, effectiveRange: &range) {
            if let paragraph = paragraph as? NSParagraphStyle {
                newParagraph.setParagraphStyle(paragraph)
            }
        }
        newParagraph.lineBreakMode = .byWordWrapping
        let abString = NSMutableAttributedString.init(attributedString: attri)
        abString.addAttributes([.paragraphStyle:newParagraph], range: range)
        return abString
    }
}
