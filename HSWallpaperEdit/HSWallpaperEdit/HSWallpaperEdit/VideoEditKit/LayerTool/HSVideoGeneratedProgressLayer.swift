//
//  HSVideoGeneratedProgressLayer.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/20.
//

import UIKit

class HSVideoGeneratedProgressLayer: CALayer {
    
    // 合成进度
    open var generatedProcess: CGFloat? {
        didSet {
            if let process = generatedProcess {
                if Thread.current.isMainThread {
                    var tempRect: CGRect = self.gradientLayer.frame
                    tempRect.size.width = grayLayerW * process
                    self.gradientLayer.frame = tempRect
                } else {
                    DispatchQueue.main.async { [weak self] in
                        var tempRect: CGRect = (self?.gradientLayer.frame)!
                        tempRect.size.width = self!.grayLayerW * process
                        self?.gradientLayer.frame = tempRect
                    }
                }
            }
        }
    }
    
    private lazy var grayLayer: CALayer = {
        let layer = CALayer.init()
        layer.backgroundColor = HSUnSelectedTextColor.cgColor
        layer.cornerRadius = 5
        layer.masksToBounds = true
        return layer
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer.init()
        layer.colors = [HSGradientColor1.cgColor,HSGradientColor2.cgColor]
        layer.startPoint = CGPoint.init(x: 0, y: 0.5)
        layer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        return layer
    }()
    
    private lazy var textLayer: CATextLayer = {
        let layer = CATextLayer.init()
        layer.string = "Live wallpaper is generating, \nJust a moment please."
        layer.isWrapped = true
        layer.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        layer.fontSize = 17
        layer.foregroundColor = HSSelectedTextColor.cgColor
        layer.alignmentMode = .center
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    
    private let grayLayerW: CGFloat = K_SCREEN_WIDTH * 0.8
    
    override init() {
        super.init()
        self.setupStyle()
        self.layoutGeneratedSubLayers()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        self.setupStyle()
        self.layoutGeneratedSubLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    private func setupStyle() {
        self.backgroundColor = HSDarkBGColor.cgColor
        self.addSublayer(grayLayer)
        self.grayLayer.addSublayer(gradientLayer)
        self.addSublayer(textLayer)
    }
    
    private func layoutGeneratedSubLayers() {
        self.grayLayer.frame = CGRect.init(x: K_SCREEN_WIDTH * 0.1, y: 32, width: grayLayerW, height: 10)
        self.textLayer.frame = CGRect.init(x: K_SCREEN_WIDTH * 0.1, y: 60, width: K_SCREEN_WIDTH * 0.8, height: 45)
        self.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: 0.01, height: 10)
    }
}
