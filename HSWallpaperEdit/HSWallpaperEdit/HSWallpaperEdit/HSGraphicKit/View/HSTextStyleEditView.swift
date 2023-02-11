//
//  HSTextStyleEditView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

// MARK: 文本编辑样式类
class HSTextStyleEditView: UIView {
    
    enum TextStyle {
        case bold
        case obliqueness
        case underline
        case strikethrough
    }
    
    var fontSize: CGFloat = 12.0 {
        didSet {
            sizeSlider.setThumbImage(UIImage.ge_creataImage(string: String(format: "%0.f", fontSize)), for: .normal)
            sizeSlider.value = Float(fontSize)
        }
    }
    
    var isBold: Bool = false {
        didSet {
            boldButton.isSelected = isBold
        }
    }
    
    var isObliqueness: Bool = false {
        didSet {
            obliquenessButton.isSelected = isObliqueness
        }
    }
    
    var isUnderLine: Bool = false {
        didSet {
            underlineButton.isSelected = isUnderLine
        }
    }
    
    var isStrikethrough: Bool = false {
        didSet {
            strikethroughButton.isSelected = isStrikethrough
        }
    }
    
    let minFontSize: CGFloat = 16.0
    let maxFontSize: CGFloat = 100.0
    
    var sizeChange: ((_ size: CGFloat) -> Void)?
    var styleChange: ((_ style:HSTextStyleEditView.TextStyle, _ isSelectd: Bool) -> Void)?
    
    private lazy var plusSizeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_fontsizeplus_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_fontsizeplus_disable"), for: .disabled)
        view.addTarget(self, action: #selector(clickPlusSize), for: .touchUpInside)
        return view
    }()
    
    private lazy var minusSizeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_fontsizeminus_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_fontsizeminus_disable"), for: .disabled)
        view.addTarget(self, action: #selector(clickMinusSize), for: .touchUpInside)
        return view
    }()
    
    private lazy var sizeSlider: UISlider = {
        let view = UISlider()
        view.minimumTrackTintColor = .cyan
        view.setThumbImage(UIImage.ge_creataImage(string: String(format: "%.0f", minFontSize)), for: .normal)
        view.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        view.minimumValue = Float(minFontSize)
        view.maximumValue = Float(maxFontSize)
        return view
    }()
    
    private lazy var boldButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_bold_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_bold_selected"), for: .selected)
        view.addTarget(self, action: #selector(clickBold), for: .touchUpInside)
        return view
    }()
    
    private lazy var obliquenessButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_inclined_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_inclined_selected"), for: .selected)
        view.addTarget(self, action: #selector(clickObliqueness), for: .touchUpInside)
        return view
    }()
    
    private lazy var underlineButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_underline_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_underline_selected"), for: .selected)
        view.addTarget(self, action: #selector(clickUnderline), for: .touchUpInside)
        return view
    }()
    
    private lazy var strikethroughButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_strikethrough_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_strikethrough_selected"), for: .selected)
        view.addTarget(self, action: #selector(clickStrikethrough), for: .touchUpInside)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadTextStyleData()
        self.loadTextStyleViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutTextStyleSubviews()
    }
    
    deinit {
        deallocPrint()
    }
    
    private func loadTextStyleData() {
        
    }
    
    private func loadTextStyleViews() {
        self.addSubview(plusSizeButton)
        self.addSubview(minusSizeButton)
        self.addSubview(sizeSlider)
        self.addSubview(boldButton)
        self.addSubview(obliquenessButton)
        self.addSubview(underlineButton)
        self.addSubview(strikethroughButton)
    }
    
    private func layoutTextStyleSubviews() {
        let leftSpacing: CGFloat = 16.0
        let top1: CGFloat = 36.0
        let top2: CGFloat = 112.0
        let spacing: CGFloat = 12.0
        let buttonWidth: CGFloat = 44.0
        let buttonHeight: CGFloat = buttonWidth
        let sliderWidth: CGFloat = self.frame.width - ((leftSpacing + spacing + buttonWidth) * 2)
        minusSizeButton.frame = CGRect.init(x: leftSpacing, y: top1, width: buttonWidth, height: buttonHeight)
        sizeSlider.frame = CGRect.init(x: minusSizeButton.frame.maxX + spacing, y: top1, width: sliderWidth, height: buttonHeight)
        plusSizeButton.frame = CGRect.init(x: sizeSlider.frame.maxX + spacing, y: top1, width: buttonWidth, height: buttonHeight)
        boldButton.frame = CGRect.init(x: leftSpacing, y: top2, width: buttonWidth, height: buttonHeight)
        obliquenessButton.frame = CGRect.init(x: boldButton.frame.maxX + leftSpacing, y: top2, width: buttonWidth, height: buttonHeight)
        underlineButton.frame = CGRect.init(x: obliquenessButton.frame.maxX + leftSpacing, y: top2, width: buttonWidth, height: buttonHeight)
        strikethroughButton.frame = CGRect.init(x: underlineButton.frame.maxX + leftSpacing, y: top2, width: buttonWidth, height: buttonHeight)
    }
}

// MARK: Target
extension HSTextStyleEditView {
    @objc func clickPlusSize() {
        let newValue = fontSize + 1
        fontSize = min(maxFontSize, newValue)
        self.sizeChange?(fontSize)
    }
    
    @objc func sliderChange() {
        fontSize = CGFloat(sizeSlider.value)
        self.sizeChange?(fontSize)
    }
    
    @objc func clickMinusSize() {
        let newValue = fontSize - 1
        fontSize = max(minFontSize, newValue)
        self.sizeChange?(fontSize)
    }
    
    @objc func clickBold() {
        boldButton.isSelected = !boldButton.isSelected
        self.styleChange?(.bold, boldButton.isSelected)
    }
    
    @objc func clickObliqueness() {
        obliquenessButton.isSelected = !obliquenessButton.isSelected
        self.styleChange?(.obliqueness, obliquenessButton.isSelected)
    }
    
    @objc func clickUnderline() {
        underlineButton.isSelected = !underlineButton.isSelected
        self.styleChange?(.underline, underlineButton.isSelected)
    }
    
    @objc func clickStrikethrough() {
        strikethroughButton.isSelected = !strikethroughButton.isSelected
        self.styleChange?(.strikethrough, strikethroughButton.isSelected)
    }
}
