//
//  HSVideoGeneratedViewController.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/20.
//

import UIKit

class HSVideoGeneratedViewController: UIViewController {

    // 水印编辑画布尺寸
    open var canvasSize: CGSize?
    // 视频壁纸本地文件路径
    open var wallpaperPath: String?
    
    // 水印数据模型
    open var elementInfo: [HSBaseEditViewModel]?
    // 预览效果图
    open var effectImg: UIImage? {
        didSet {
            effectImgView.image = effectImg
        }
    }
    
    private lazy var effectImgView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var processLayer: HSVideoGeneratedProgressLayer = {
        let layer = HSVideoGeneratedProgressLayer.init()
        return layer
    }()
    
    private var marksLayer: [HSImageLayer] = [HSImageLayer].init()
    private lazy var videoEditManager: HSVideoEditManager = {
        let manager = HSVideoEditManager.init()
        manager.videoEditEndClousre = {[weak self] (destinationPath: String, thumbImage: UIImage?) in
            self?.generateLivePhoto(videoPath: destinationPath, thumbImg: thumbImage)
        }
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadGeneratedViews()
        self.layoutGeneratedSubviews()
        self.exportVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        for item in marksLayer {
            item.removeFromSuperlayer()
        }
        marksLayer.removeAll()
        deallocPrint()
    }
    
    private func loadGeneratedViews() {
        self.view.backgroundColor = HSMainBGColor
        self.view.addSubview(effectImgView)
        self.view.layer.addSublayer(processLayer)
    }
    
    private func layoutGeneratedSubviews() {
        effectImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.navHeight() + self.safeAreaInsetsTop() + self.statusBarHeight())
            make.size.equalTo(CGSize.init(width: K_SCREEN_WIDTH * 0.685, height: K_SCREEN_HEIGHT * 0.684))
        }
        
        let layerH: CGFloat = 170 + self.safeAreaInsetsBottom()
        processLayer.frame = CGRect.init(x: 0, y: K_SCREEN_HEIGHT - layerH, width: K_SCREEN_WIDTH, height: layerH)
    }
    
    private func exportVideo() {
        self.buildWaterMarkLayer()
        if let videoPath = self.wallpaperPath {
            videoEditManager.mixVideoWithText(URL.init(fileURLWithPath: videoPath), marks: marksLayer)
        }
    }
    
    private func generateLivePhoto(videoPath: String, thumbImg: UIImage?) {
        var photoURL: URL?
        if let sourceKeyPhoto = thumbImg {
            guard let data = sourceKeyPhoto.jpegData(compressionQuality: 1.0) else { return }
            photoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("photo.jpg")
            if let photoURL = photoURL {
                try? data.write(to: photoURL)
            }
        }
        HSLivePhotoManager.generate(from: photoURL, videoURL: URL.init(fileURLWithPath: videoPath), progress: { (percent) in
            DispatchQueue.main.async {
                self.processLayer.generatedProcess = percent
            }
        }) { (livePhoto, resources) in
            let previewVC: HSPreviewLivePhotoViewController = HSPreviewLivePhotoViewController.init()
            previewVC.generateLivePhoto = livePhoto
            previewVC.videoSavePath = videoPath
            previewVC.videoCoverImg = thumbImg
            previewVC.liveResource = resources
            DispatchQueue.main.async {
                self.view.makeToast("Congratulations! The live photo generate successfully.", duration:1 ,position:.center) { [weak self] didTap in
                    self?.navigationController?.pushViewController(previewVC, animated: true)
                }
            }
        }
    }
}

// MARK: 创建水印
extension HSVideoGeneratedViewController {
    // 创建水印
    private func buildWaterMarkLayer() {
        guard let markInfo = elementInfo else {
            return
        }
        for item in markInfo {
            let tempModel: HSBaseEditViewModel = item as HSBaseEditViewModel
            let imgLayer: HSImageLayer = HSImageLayer.init()
            let Y: CGFloat = HSTransitionMarkFrame.transitionFrameShared.videoSize.height * (tempModel.viewCenter!.y / canvasSize!.height)
            let X: CGFloat = HSTransitionMarkFrame.transitionFrameShared.videoSize.width * (tempModel.viewCenter!.x / canvasSize!.width)
            let H: CGFloat = HSTransitionMarkFrame.transitionFrameShared.videoSize.height * (tempModel.viewBounds!.height / canvasSize!.height)
            let W: CGFloat = HSTransitionMarkFrame.transitionFrameShared.videoSize.width * (tempModel.viewBounds!.width / canvasSize!.width)
            imgLayer.contents = tempModel.elemenetType == .IMAGE ? tempModel.originImage?.cgImage : tempModel.textSnap?.cgImage
            imgLayer.bounds = CGRect.init(x: 0, y: 0, width: W, height: H)
            imgLayer.position = CGPoint.init(x: X, y: Y)
            imgLayer.transform = tempModel.layerTransform ?? CATransform3D.init()
            marksLayer.append(imgLayer)
        }
    }
}

// MARK: 弹窗
extension HSVideoGeneratedViewController {
    // 展示编辑结束的弹窗
    private func showExitEditAlert() {
        let view = HSEditWallpaperEndAlert.init(frame: self.view.frame)
        view.show(contentView: self.view)
        view.alertTitle = "Stop making wallpapers?"
        view.alertContent = "The current operation will not be saved after returning."
        view.alertClosure = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
