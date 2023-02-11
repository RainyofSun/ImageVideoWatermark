//
//  HSMenuItem.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

public class HSMenuItem: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let img = self.currentImage {
            let imgX: CGFloat = (self.bounds.size.width - img.size.width) * 0.5
            let imgY: CGFloat = 8.5
            let imgSize: CGSize = img.size
            self.imageView?.frame = CGRect.init(x: imgX, y: imgY, width: imgSize.width, height: imgSize.height)
        }
        var frame: CGRect = self.titleLabel!.frame
        frame.origin.y = (self.imageView?.frame.maxY)! + 4
        self.titleLabel?.frame = frame
        self.titleLabel?.center.x = self.imageView?.center.x ?? self.center.x
        self.titleLabel?.sizeToFit()
    }
    
    deinit {
        deallocPrint()
    }

    public func setupCellWith(menuName: HSMenuObject, menuImage: Imageable?, configuration: HSConfiguration) {
        self.titleLabel?.font = configuration.textFont
        self.setTitleColor(configuration.textColor, for: .normal)
        self.setTitleColor(configuration.textDisableColor, for: .disabled)
        var iconImage: UIImage? = nil
        var disableImage: UIImage? = nil
        var selectedImg: UIImage? = nil
        if menuName is String {
            self.setTitle((menuName as! String), for: .normal)
            self.setTitle((menuName as! String), for: .disabled)
            iconImage = menuImage?.getImage()
        } else if menuName is HSPopOverMenuModel {
            let menuModel: HSPopOverMenuModel = menuName as! HSPopOverMenuModel
            self.setTitle(menuModel.title, for: .normal)
            self.setTitle(menuModel.title, for: .disabled)
            self.isSelected = menuModel.selected
            self.isEnabled = menuModel.isEnabled
            iconImage = menuModel.image?.getImage()
            disableImage = menuModel.disImage?.getImage()
            selectedImg = menuModel.disImage?.getImage()
        }
        if iconImage != nil {
            self.setImage(iconImage, for: .normal)
        }
        if disableImage != nil {
            self.setImage(disableImage, for: .disabled)
        }
        if selectedImg != nil {
            self.setImage(selectedImg, for: .selected)
        }
        self.layoutIfNeeded()
    }
}
