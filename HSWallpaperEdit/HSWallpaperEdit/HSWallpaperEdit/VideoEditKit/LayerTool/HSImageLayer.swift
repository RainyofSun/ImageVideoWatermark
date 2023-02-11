//
//  HSImageLayer.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/20.
//

import UIKit

class HSImageLayer: CALayer {
    
    override init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
        self.contentsGravity = .resizeAspectFill
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        self.contentsScale = UIScreen.main.scale
        self.contentsGravity = .resizeAspectFill
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        deallocPrint()
    }
}
