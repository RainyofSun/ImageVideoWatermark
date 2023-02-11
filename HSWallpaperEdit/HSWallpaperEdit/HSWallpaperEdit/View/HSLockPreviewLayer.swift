//
//  HSLockPreviewLayer.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/23.
//

import UIKit

// MARK: 仿锁屏预览画面
class HSLockPreviewLayer: CALayer {

    private lazy var lockLayer: HSImageLayer = {
        let layer = HSImageLayer.init()
        layer.contents = UIImage.init(named: "screenLock")?.cgImage
        return layer
    }()
    
    private lazy var timeTextLayer: HSTextLayer = {
        let layer = HSTextLayer.init()
        layer.fontSize = 75
        layer.string = "9:41"
        layer.foregroundColor = HSSelectedTextColor.cgColor
        return layer
    }()
    
    private lazy var dateTextLayer: HSTextLayer = {
        let layer = HSTextLayer.init()
        layer.fontSize = 20
//        layer.string = NSDate().getNowWeekDay()+", \(NSDate().getCurrentMonth())"+" \(NSDate().getNowDay())"
        layer.foregroundColor = HSSelectedTextColor.cgColor
        return layer
    }()
    
    private lazy var cameraLayer: HSImageLayer = {
        let layer = HSImageLayer.init()
        layer.contents = UIImage.init(named: "CameraBtn")?.cgImage
        return layer
    }()
    
    private lazy var flashlightLayer: HSImageLayer = {
        let layer = HSImageLayer.init()
        layer.contents = UIImage.init(named: "FlashlightBtn")?.cgImage
        return layer
    }()
    
    private var timer: HSSafeTimer?
    
    override init() {
        super.init()
        self.loadPreviewLayer()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        self.loadPreviewLayer()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.layoutPreviewSubLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        deallocPrint()
    }
    
    public func reloadTime() {
        if timer == nil {
            timer = HSSafeTimer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reloadText), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    private func loadPreviewLayer() {
        self.addSublayer(lockLayer)
        self.addSublayer(timeTextLayer)
        self.addSublayer(dateTextLayer)
        self.addSublayer(cameraLayer)
        self.addSublayer(flashlightLayer)
    }
    
    private func layoutPreviewSubLayers() {
        self.lockLayer.frame = CGRect.init(x: K_SCREEN_WIDTH/2 - 12, y: 60, width: 23, height: 34)
        self.timeTextLayer.frame = CGRect.init(x: 0, y: self.lockLayer.frame.maxY + 20, width: K_SCREEN_WIDTH, height: 86)
        self.dateTextLayer.frame = CGRect.init(x: 0, y: self.timeTextLayer.frame.maxY, width: K_SCREEN_WIDTH, height: 26)
        self.flashlightLayer.frame = CGRect.init(x: 46, y: K_SCREEN_HEIGHT - 60 - getWindow().safeAreaInsets.bottom, width: 50, height: 50)
        self.cameraLayer.frame = CGRect.init(x: K_SCREEN_WIDTH - 96, y: K_SCREEN_HEIGHT - 60 - getWindow().safeAreaInsets.bottom, width: 50, height: 50)
    }
}

// MARK: Timer
extension HSLockPreviewLayer {
    @objc private func reloadText() {
        print("刷新文字")
    }
}
