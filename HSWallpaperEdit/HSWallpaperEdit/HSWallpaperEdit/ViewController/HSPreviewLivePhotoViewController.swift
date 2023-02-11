//
//  HSPreviewLivePhotoViewController.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/25.
//

import UIKit
import Photos
import PhotosUI

class HSPreviewLivePhotoViewController: UIViewController {

    // livePhpto
    open var generateLivePhoto: PHLivePhoto? {
        didSet {
            self.photoView.livePhoto = generateLivePhoto
            self.photoView.startPlayback(with: PHLivePhotoViewPlaybackStyle.full)
        }
    }
    // 视频封面
    open var videoCoverImg: UIImage? 
    // 视频合成后保存的地址
    open var videoSavePath: String?
    // livephoto资源
    open var liveResource: (pairedImage: URL, pairedVideo: URL)?
    
    // livePhoto预览
    private lazy var photoView: PHLivePhotoView = {
        let view = PHLivePhotoView.init()
        return view
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
        view.setImage(UIImage.init(named: "icon_charging"), for: .normal)
        view.setImage(UIImage.init(named: "icon_charging"), for: .highlighted)
        view.contentMode = .center
        return view
    }()
    
    // 编辑按钮
    private lazy var editBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "icon_edit"), for: .normal)
        view.setImage(UIImage.init(named: "icon_edit"), for: .highlighted)
        view.contentMode = .center
        return view
    }()
    
    // 分享按钮
    private lazy var shareBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "icon_share"), for: .normal)
        view.setImage(UIImage.init(named: "icon_share"), for: .highlighted)
        view.contentMode = .center
        return view
    }()
    
    // 下载按钮
    private lazy var downloadBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "icon_download"), for: .normal)
        view.setImage(UIImage.init(named: "icon_download"), for: .highlighted)
        view.contentMode = .center
        return view
    }()
    
    // 锁屏预览
    private lazy var lockPreviewLayer: HSLockPreviewLayer = {
        return HSLockPreviewLayer.init()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPreviewLivePhotoViews()
        self.layoutPreviewLivePhotoSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backBtn.isHidden = false
        lockPreviewBtn.isHidden = false
        editBtn.isHidden = false
        shareBtn.isHidden = false
        downloadBtn.isHidden = false
        lockPreviewLayer.removeFromSuperlayer()
    }
    
    private func loadPreviewLivePhotoViews() {
        self.view.backgroundColor = HSDarkBGColor
        self.view.addSubview(photoView)
        self.view.addSubview(backBtn)
        self.view.addSubview(lockPreviewBtn)
        self.view.addSubview(editBtn)
        self.view.addSubview(shareBtn)
        self.view.addSubview(downloadBtn)
        
        backBtn.addTarget(self, action: #selector(backRootVC), for: .touchUpInside)
        lockPreviewBtn.addTarget(self, action: #selector(lockPreviewShowEffect(sender:)), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(editVideo(sender:)), for: .touchUpInside)
        shareBtn.addTarget(self, action: #selector(shareVideo(sender:)), for: .touchUpInside)
        downloadBtn.addTarget(self, action: #selector(downloadVideo(sender:)), for: .touchUpInside)
    }
    
    private func layoutPreviewLivePhotoSubviews() {
        self.photoView.frame = self.view.frame
        
        backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(self.safeAreaInsetsTop() + self.statusBarHeight() + 11)
            make.size.equalTo(CGSize.init(width: backBtn.currentImage!.size.width * 1.5, height: backBtn.currentImage!.size.height))
        }
        
        lockPreviewBtn.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.bottom).offset(300)
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(lockPreviewBtn.currentImage!.size)
        }
        
        editBtn.snp.makeConstraints { make in
            make.size.right.equalTo(lockPreviewBtn)
            make.top.equalTo(lockPreviewBtn.snp.bottom).offset(22)
        }
        
        shareBtn.snp.makeConstraints { make in
            make.size.right.equalTo(editBtn)
            make.top.equalTo(editBtn.snp.bottom).offset(22)
        }
        
        downloadBtn.snp.makeConstraints { make in
            make.size.right.equalTo(shareBtn)
            make.top.equalTo(shareBtn.snp.bottom).offset(22)
        }
    }
}

// MARK: Target
extension HSPreviewLivePhotoViewController {
    // 返回按钮
    @objc private func backRootVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // lock全屏预览
    @objc private func lockPreviewShowEffect(sender: UIButton) {
        backBtn.isHidden = true
        sender.isHidden = true
        editBtn.isHidden = true
        shareBtn.isHidden = true
        downloadBtn.isHidden = true
        lockPreviewLayer.reloadTime()
        self.view.layer.addSublayer(lockPreviewLayer)
    }
    
    // 二次编辑
    @objc private func editVideo(sender: UIButton) {
        let editVC: HSImageTextEditViewController = HSImageTextEditViewController.init()
        editVC.wallpapaerCoverImg = self.videoCoverImg
        editVC.wallpapaerVideoPath = self.videoSavePath
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    // 分享视频
    @objc private func shareVideo(sender: UIButton) {
        
    }
    
    // 下载视频
    @objc private func downloadVideo(sender: UIButton) {
        if let resources = self.liveResource {
            HSLivePhotoManager.saveToLibrary(resources, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.view.makeToast("The live photo was successfully saved to Photos.", duration:1 ,position:.center)
                    }
                } else {
                    print("The live photo was not saved to Photos.")
                }
            })
        }
    }
}
