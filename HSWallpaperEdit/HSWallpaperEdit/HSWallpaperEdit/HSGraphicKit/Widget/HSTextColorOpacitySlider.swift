//
//  HSTextColorOpacitySlider.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

class HSTextColorOpacitySlider: UISlider {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSliderStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    private func setupSliderStyle() {
        // 左右轨的图片
        let stetchLeftTrack: UIImage = UIImage.init(named: "slider_qing")!
        let stetchRightTrack: UIImage = UIImage.init(named: "slider_gray")!
        //滑块图片
        let thumbImage: UIImage = UIImage.init(named: "slider_bulk")!
        
        self.backgroundColor = .clear
        self.value = 1.0
        self.minimumValue = 0
        self.maximumValue = 1.0
        
        self.setMinimumTrackImage(stetchLeftTrack, for: .normal)
        self.setMaximumTrackImage(stetchRightTrack, for: .normal)
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        self.setThumbImage(thumbImage, for: .highlighted)
        self.setThumbImage(thumbImage, for: .normal)
    }
}
