//
//  HSToolBarCell.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

class HSToolBarCell: UIButton {
    var barItem: HSToolBarItem? {
        didSet {
            self.loadBarData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadBarData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
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

        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        if item.image != nil && item.selectedImage != nil {
            if item.text == "" {
                self.imagePosition(style: .right, spacing: 0)
            } else {
                self.imagePosition(style: .top, spacing: 0)
            }
        }
    }
}
