//
//  HSTextColorElementView.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

class HSTextColorElementView :UIButton {
    
    public var backgroundColorStr: String? {
        didSet {
            let isBegin: Bool = backgroundColorStr!.hasPrefix("#")
            if isBegin {
                self.backgroundColor = UIColor.init(hexString: backgroundColorStr!)
            } else {
                self.setBackgroundImage(UIImage.init(named: backgroundColorStr!), for: .normal)
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            outerCircleLayer.isHidden = !isSelected
        }
    }
    
    private lazy var outerCircleLayer: CALayer = {
        let layer: CALayer = CALayer.init()
        layer.contents = UIImage.init(named: "color_circle_selected")?.cgImage
        layer.isHidden = true
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCirclyLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        outerCircleLayer.frame = self.bounds
        self.layer.cornerRadius = self.bounds.height * 0.5
        self.clipsToBounds = true
    }
    
    deinit {
        deallocPrint()
    }
    
    private func setupCirclyLayer() {
        self.layer.addSublayer(outerCircleLayer)
    }
}
