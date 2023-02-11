//
//  HSTextAlignmentEditView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

// MARK: 文本段落编辑View
class HSTextAlignmentEditView: UIView {

    var textAlignment: NSTextAlignment = .left {
        didSet {
            self.updateAlignmentButton(alignment: textAlignment)
        }
    }

    var lineSpacing: CGFloat = 0.0 {
        didSet {
            lineSpacingSlider.setThumbImage(UIImage.ge_creataImage(string: String(format: "%.0f", lineSpacing)), for: .normal)
            lineSpacingSlider.value = Float(lineSpacing)
        }
    }
    
    var headIndent: CGFloat = 0.0
    
    let minLineSpacing: CGFloat = 0.0
    let maxLineSpacing: CGFloat = 100.0
    
    var headIndentChange: ((_ size: CGFloat) -> Void)?
    var textAlignmentChange: ((_ alignment: NSTextAlignment) -> Void)?
    var lineSpacingChange: ((_ spaceing: CGFloat) -> Void)?
    
    private var selectedButton: UIButton?
    
    private lazy var plusLineSpacingButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_rowspacingplus_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_rowspacingplus_disable"), for: .disabled)
        view.addTarget(self, action: #selector(clickPlusLineSpacing), for: .touchUpInside)
        return view
    }()
    
    private lazy var minusLineSpacingButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_rowspacingminus_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_rowspacingminus_disable"), for: .disabled)
        view.addTarget(self, action: #selector(clickMinusLineSpacing), for: .touchUpInside)
        return view
    }()
    
    private lazy var lineSpacingSlider: UISlider = {
        let view = UISlider()
        view.minimumTrackTintColor = .cyan
        view.setThumbImage(UIImage.ge_creataImage(string: String(format: "%.0f", minLineSpacing)), for: .normal)
        view.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        view.minimumValue = Float(minLineSpacing)
        view.maximumValue = Float(maxLineSpacing)
        return view
    }()
    
    private lazy var leftButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_alignleft_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_alignleft_selected"), for: .selected)
        view.isSelected = true
        view.addTarget(self, action: #selector(clickLeft), for: .touchUpInside)
        selectedButton = view
        return view
    }()
    
    private lazy var centerButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_aligncenter_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_aligncenter_selected"), for: .selected)
        view.addTarget(self, action: #selector(clickCenter), for: .touchUpInside)
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_alignright_default"), for: .normal)
        view.setImage(UIImage.init(named: "icon_tool_alignright_selected"), for: .selected)
        view.addTarget(self, action: #selector(clickRight), for: .touchUpInside)
        return view
    }()

    private lazy var plusHeadIndentButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_indentleft_default"), for: .normal)
        view.addTarget(self, action: #selector(clickPlusHeadIndent), for: .touchUpInside)
        return view
    }()

    private lazy var minusHeadIndentButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "icon_tool_indentright_default"), for: .normal)
        view.addTarget(self, action: #selector(clickMinusHeadIndent), for: .touchUpInside)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadAlignmentData()
        self.loadAlignmentViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutAlignmentSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    private func loadAlignmentData() {
        self.isHidden = true
    }
    
    private func loadAlignmentViews() {
        self.addSubview(plusLineSpacingButton)
        self.addSubview(minusLineSpacingButton)
        self.addSubview(lineSpacingSlider)
        self.addSubview(leftButton)
        self.addSubview(centerButton)
        self.addSubview(rightButton)
        self.addSubview(plusHeadIndentButton)
        self.addSubview(minusHeadIndentButton)
    }
    
    private func layoutAlignmentSubviews() {
        let leftSpacing: CGFloat = 16.0
        let top1: CGFloat = 36.0
        let top2: CGFloat = 112.0
        let spacing: CGFloat = 12.0
        let buttonWidth: CGFloat = 44.0
        let buttonHeight: CGFloat = buttonWidth
        let sliderWidth: CGFloat = self.frame.width - ((leftSpacing + spacing + buttonWidth) * 2)
        leftButton.frame = CGRect(x: leftSpacing, y: top1, width: buttonWidth, height: buttonHeight)
        centerButton.frame = CGRect(x: leftButton.frame.maxX + leftSpacing, y: top1, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: centerButton.frame.maxX + leftSpacing, y: top1, width: buttonWidth, height: buttonHeight)
        plusHeadIndentButton.frame = CGRect(x: rightButton.frame.maxX + leftSpacing, y: top1, width: buttonWidth, height: buttonHeight)
        minusHeadIndentButton.frame = CGRect(x: plusHeadIndentButton.frame.maxX + leftSpacing, y: top1, width: buttonWidth, height: buttonHeight)
        
        minusLineSpacingButton.frame = CGRect(x: leftSpacing , y: top2, width: buttonWidth, height: buttonHeight)
        lineSpacingSlider.frame = CGRect(x: minusLineSpacingButton.frame.maxX + spacing, y: top2, width: sliderWidth, height: buttonHeight)
        plusLineSpacingButton.frame = CGRect(x: lineSpacingSlider.frame.maxX + spacing, y: top2, width: buttonWidth, height: buttonHeight)
    }
}

// MARK: Target
extension HSTextAlignmentEditView {
    @objc private func clickPlusLineSpacing() {
        let newValue = lineSpacing + 1
        lineSpacing = min(maxLineSpacing, newValue)
        self.lineSpacingChange?(lineSpacing)
    }
    
    @objc private func sliderChange() {
        lineSpacing = CGFloat(lineSpacingSlider.value)
        self.lineSpacingChange?(lineSpacing)
    }
    
    @objc private func clickMinusLineSpacing() {
        let newValue = lineSpacing - 1
        lineSpacing = max(minLineSpacing, newValue)
        self.lineSpacingChange?(lineSpacing)
    }
    
    @objc private func clickLeft() {
        guard !leftButton.isSelected else {
            return
        }
        self.updateAlignmentButton(alignment: .left)
        self.textAlignmentChange?(.left)
    }
    
    @objc private func clickCenter() {
        guard !centerButton.isSelected else {
            return
        }
        self.updateAlignmentButton(alignment: .center)
        self.textAlignmentChange?(.center)
    }
    
    @objc private func clickRight() {
        guard !rightButton.isSelected else {
            return
        }
        self.updateAlignmentButton(alignment: .right)
        self.textAlignmentChange?(.right)
    }
    
    @objc private func clickPlusHeadIndent() {
        headIndent += 1
        self.headIndentChange?(headIndent)
    }
    
    @objc private func clickMinusHeadIndent() {
        headIndent -= 1
        self.headIndentChange?(headIndent)
    }
    
    private func updateAlignmentButton(alignment: NSTextAlignment) {
        selectedButton?.isSelected = false
        var newSelectedButton: UIButton
        switch alignment {
        case .left:
            newSelectedButton = leftButton
        case .center:
            newSelectedButton = centerButton
        case .right:
            newSelectedButton = rightButton
        default:
            newSelectedButton = leftButton
        }
        selectedButton = newSelectedButton
        selectedButton?.isSelected = true
    }
}
