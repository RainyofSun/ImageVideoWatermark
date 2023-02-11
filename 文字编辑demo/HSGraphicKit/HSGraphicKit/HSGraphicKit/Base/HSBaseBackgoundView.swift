//
//  HSBaseBackgoundView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/10.
//

import UIKit

// MARK: 整个图层的背景基类
class HSBaseBackgoundView: UIView {

    // 背景图片
    public var backgroundImage: UIImage? {
        didSet {
            if Thread.isMainThread {
                if let image = backgroundImage {
                    self.loadLayer()
                    self.layoutSubLayerFrame()
                    self.backgroundLayer.contents = image.cgImage
                }
            } else {
                DispatchQueue.main.async {
                    if let image = self.backgroundImage {
                        self.loadLayer()
                        self.layoutSubLayerFrame()
                        self.backgroundLayer.contents = image.cgImage
                    }
                }
            }
        }
    }
    
    private var backgroundLayer: CALayer = {
        let imgLayer = CALayer()
        imgLayer.contentsScale = UIScreen.main.scale
        return imgLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }

    // MARK: private methods
    private func loadLayer() {
        self.backgroundColor = .clear
        self.layer.addSublayer(backgroundLayer)
    }
    
    private func layoutSubLayerFrame() {
        self.backgroundLayer.frame = self.bounds
    }
}
