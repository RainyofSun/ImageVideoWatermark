//
//  HSTextLayer.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/13.
//

import UIKit

// MARK: 可以垂直居中的TextLayer
class HSTextLayer: CATextLayer {
    
    override init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
        self.alignmentMode = .center
        self.isWrapped = true
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        self.contentsScale = UIScreen.main.scale
        self.alignmentMode = .center
        self.isWrapped = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        deallocPrint()
    }
}
