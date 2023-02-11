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
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        self.contentsScale = UIScreen.main.scale
        self.alignmentMode = .center
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(in ctx: CGContext) {
        let height: CGFloat = self.bounds.height
        let fontSize = self.fontSize
        let yDiff: CGFloat = (height - fontSize)/2 + fontSize/10
        
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
