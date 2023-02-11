//
//  HSStickerCollectionViewCell.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

class HSStickerCollectionViewCell: UICollectionViewCell {
    
    public var stickerThumbImg: UIImage? {
        didSet {
            if let img = stickerThumbImg {
                imgLayer.contents = img.cgImage
            }
        }
    }
    
    private lazy var imgLayer: CALayer = {
        let layer = CALayer.init()
        return layer
    }()
    
    private lazy var imgView: UIImageView = UIImageView.init()
    
    override var isSelected: Bool {
        didSet {
            self.contentView.layer.contents = isSelected ? UIImage.init(named:"sticker_selected")?.cgImage : UIImage.init()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.addSublayer(imgLayer)
        self.contentView.backgroundColor = HSStickerCellBGColor
        self.contentView.clipRound(roundBounds: self.contentView.bounds, radius: CGSize.init(width: 4.0, height: 4.0), corner: .allCorners)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgLayer.frame = CGRect.init(x: self.bounds.width * 0.5 - 25, y: self.bounds.height * 0.5 - 25, width: 50, height: 50)
    }
    
    deinit {
        deallocPrint()
    }
}
