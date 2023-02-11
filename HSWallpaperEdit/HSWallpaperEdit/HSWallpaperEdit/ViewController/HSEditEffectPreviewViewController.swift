//
//  HSEditEffectPreviewViewController.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/19.
//

import UIKit

class HSEditEffectPreviewViewController: UIViewController {

    // 水印编辑画布尺寸
    open var canvasSize: CGSize?
    // 水印数据模型
    open var elementInfo: [HSBaseEditViewModel]?
    // 壁纸背景
    open var backgroundImg: UIImage? {
        didSet {
            previewImgLayer.contents = backgroundImg?.cgImage
        }
    }
    
    // 预览背景
    private lazy var previewImgLayer: CALayer = {
        let imgLayer: CALayer = CALayer.init()
        imgLayer.contentsScale = UIScreen.main.scale
        return imgLayer
    }()
    
    // 返回按钮
    private lazy var backBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "icon_back"), for: .normal)
        view.setImage(UIImage.init(named: "icon_back"), for: .highlighted)
        view.contentMode = .left
        return view
    }()
    
    // 锁屏预览按钮
    private lazy var lockPreviewBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "icon_Check"), for: .normal)
        view.setImage(UIImage.init(named: "icon_Check"), for: .highlighted)
        view.contentMode = .center
        return view
    }()
    
    // 锁屏预览
    private lazy var lockPreviewLayer: HSLockPreviewLayer = {
        return HSLockPreviewLayer.init()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPreviewViews()
        self.layoutPreviewSubviews()
        self.buildWaterMarkLayer()
    }
    
    deinit {
        deallocPrint()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backBtn.isHidden = false
        lockPreviewBtn.isHidden = false
        lockPreviewLayer.removeFromSuperlayer()
    }
    
    private func loadPreviewViews() {
        self.view.backgroundColor = HSDarkBGColor
        self.view.layer.addSublayer(previewImgLayer)
        self.view.addSubview(backBtn)
        self.view.addSubview(lockPreviewBtn)
        backBtn.addTarget(self, action: #selector(backForwardVC), for: .touchUpInside)
        lockPreviewBtn.addTarget(self, action: #selector(lockPreviewEffect(sender:)), for: .touchUpInside)
    }
    
    private func layoutPreviewSubviews() {
        backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(self.safeAreaInsetsTop() + self.statusBarHeight() + 11)
            make.size.equalTo(CGSize.init(width: backBtn.currentImage!.size.width * 1.5, height: backBtn.currentImage!.size.height))
        }
        
        lockPreviewBtn.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(backBtn)
            make.size.equalTo(CGSize.init(width: lockPreviewBtn.currentImage!.size.width * 1.5, height: lockPreviewBtn.currentImage!.size.height * 1.5))
        }

        var preViewW: CGFloat = 0
        var previewH: CGFloat = 0
        
        if HSTransitionMarkFrame.transitionFrameShared.elementScaleStruct.videoWHScale >
           HSTransitionMarkFrame.transitionFrameShared.elementScaleStruct.screenWHScale {
            // 以高为基准进行缩放
            previewH = K_SCREEN_HEIGHT
            preViewW = previewH * HSTransitionMarkFrame.transitionFrameShared.elementScaleStruct.videoWHScale
        }
        if HSTransitionMarkFrame.transitionFrameShared.elementScaleStruct.videoWHScale <=
           HSTransitionMarkFrame.transitionFrameShared.elementScaleStruct.screenWHScale {
            // 以宽为基准进行缩放
            preViewW = K_SCREEN_WIDTH
            previewH = preViewW / HSTransitionMarkFrame.transitionFrameShared.elementScaleStruct.videoWHScale
        }
        
        previewImgLayer.frame = CGRect.init(x: (K_SCREEN_WIDTH - preViewW) * 0.5, y: (K_SCREEN_HEIGHT - previewH) * 0.5, width: preViewW, height: previewH)
        
        lockPreviewLayer.frame = self.view.frame
    }
}

// MARK: Target
extension HSEditEffectPreviewViewController {
    // 返回按钮
    @objc private func backForwardVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // lock全屏预览
    @objc private func lockPreviewEffect(sender: UIButton) {
        backBtn.isHidden = true
        sender.isHidden = true
        lockPreviewLayer.reloadTime()
        self.view.layer.addSublayer(lockPreviewLayer)
    }
}

// MARK: 创建水印
extension HSEditEffectPreviewViewController {
    
    // 创建水印
    private func buildWaterMarkLayer() {
        guard let markInfo = elementInfo else {
            return
        }
        for item in markInfo {
            let tempModel: HSBaseEditViewModel = item as HSBaseEditViewModel
            let imgLayer: HSImageLayer = HSImageLayer.init()
            let centerY: CGFloat = previewImgLayer.frame.height * (tempModel.viewCenter!.y / canvasSize!.height)
            let centerX: CGFloat = previewImgLayer.frame.width * (tempModel.viewCenter!.x / canvasSize!.width)
            let H: CGFloat = previewImgLayer.frame.height * (tempModel.viewBounds!.height / canvasSize!.height)
            let W: CGFloat = previewImgLayer.frame.width * (tempModel.viewBounds!.width / canvasSize!.width)
            imgLayer.contents = tempModel.elemenetType == .IMAGE ? tempModel.originImage?.cgImage : tempModel.textSnap?.cgImage
            imgLayer.bounds = CGRect.init(origin: .zero, size: CGSize.init(width: W, height: H))
            imgLayer.position = CGPoint.init(x: centerX, y: centerY)
            imgLayer.transform = tempModel.layerTransform ?? CATransform3D.init()
            self.view.layer.addSublayer(imgLayer)
        }
    }
}
