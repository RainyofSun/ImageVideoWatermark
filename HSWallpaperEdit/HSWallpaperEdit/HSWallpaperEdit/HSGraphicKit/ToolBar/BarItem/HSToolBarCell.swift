//
//  HSToolBarCell.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

class HSToolBarCell: UIButton {
    
    let lineImageLayer: CALayer = {
        let layer = CALayer.init()
        layer.isHidden = true
        return layer
    }()
    
    var barItem: HSToolBarItem? {
        didSet {
            self.loadBarData()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.lineImageLayer.isHidden = !self.isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadBarCellViews()
        self.loadBarData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGSize = barItem?.lineImage?.size ?? .zero
        self.lineImageLayer.frame = CGRect.init(x: (self.bounds.width - size.width) * 0.5, y: self.bounds.height - 2 - (barItem?.lineBottomDistance ?? 0), width: size.width, height: size.height)
    }
    
    deinit {
        deallocPrint()
    }
    
    private func loadBarCellViews() {
        self.layer.addSublayer(lineImageLayer)
    }
    
    private func loadBarData() {
        guard let item = barItem else { return }
        if item.text != nil {
            self.setTitle(item.text, for: .normal)
        }
        if item.selectedText != nil {
            self.setTitle(item.selectedText, for: .selected)
        }
        if item.textColor != nil {
            self.setTitleColor(item.textColor, for: .normal)
        }
        if item.selectedTextColor != nil {
            self.setTitleColor(item.selectedTextColor, for: .selected)
        }
        if item.image != nil {
            self.setImage(item.image, for: .normal)
        }
        if item.selectedImage != nil {
            self.setImage(item.selectedImage, for: .selected)
        }

        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        if item.image != nil && item.selectedImage != nil {
            if item.text == nil {
                self.imagePosition(style: .right, spacing: 0)
            } else {
                self.imagePosition(style: .top, spacing: 0)
            }
        }
        if item.lineImage != nil {
            self.lineImageLayer.contents = item.lineImage?.cgImage
        }
    }
}
