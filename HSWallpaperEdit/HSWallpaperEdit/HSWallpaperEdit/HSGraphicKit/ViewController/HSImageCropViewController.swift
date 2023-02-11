//
//  HSImageCropViewController.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit
import JPImageresizerView

class HSImageCropViewController: UIViewController {

    var image: UIImage?
    var cropImageClosure: ((UIImage) -> Void)?
    
    var configure: JPImageresizerConfigure!
    var imageresizerView: JPImageresizerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadSubView()
    }
    
    private func loadSubView() {
        self.navigationItem.title = "裁剪图片"
        self.ge_createLeftButtonWithImageName("icon_nav_back", target: self)
        self.ge_createButtonWithTitle("确认", target: self)
        configure = JPImageresizerConfigure.defaultConfigure(with: self.image ?? UIImage.init(named: "Cyberpunk_1")!, make: nil)
        view.backgroundColor = configure.bgColor
        self.automaticallyAdjustsScrollViewInsets = false
        configure.frameType = .classicFrameType
        
        var contentInsets = UIEdgeInsets.init(top: 15, left: 15, bottom: 100, right: 15)
        contentInsets.bottom += safeWindowAreaInsetsBottom()
        configure.contentInsets = contentInsets
        configure.viewFrame = UIScreen.main.bounds
        imageresizerView = JPImageresizerView(configure: configure, imageresizerIsCanRecovery: { (isCanRecovery) in
            
        }, imageresizerIsPrepareToScale: { (isPrepareToScale) in
            
        })
        self.view.insertSubview(imageresizerView, at: 0)
        configure = nil
    }
    
    @objc func ge_onRightBarClick(_ sender: UIBarButtonItem) {
        imageresizerView.cropPicture(withCacheURL: URL.init(string: "")) { (url, error) in
            
        } complete: { (image, url, result) in
            guard let img = image else {
                return
            }
            self.cropImageClosure?(img)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    @objc func ge_onLeftBarClick(_ sender:UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true)
    }
}

extension HSImageCropViewController {
    func ge_createLeftButtonWithImageName(_ name: String?, target: Any?) {
        if let imageName = name {
            if let image = UIImage.init(named: imageName)?.withRenderingMode(.alwaysOriginal) {
                let leftItem = UIBarButtonItem.init(image: image, style: .plain, target: target, action: #selector(ge_onLeftBarClick(_:)))
                self.navigationItem.leftBarButtonItem = leftItem
                
            }else {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem()
            }
            
        }else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        }
    }
    
    func ge_createRightButtonWithImageName(_ name: String?, target: Any?) {
        
        if let imageName = name {
            if let image = UIImage.init(named: imageName)?.withRenderingMode(.alwaysOriginal) {
                let rightItem = UIBarButtonItem.init(image: image, style: .plain, target: target, action: #selector(ge_onRightBarClick(_:)))
                self.navigationItem.rightBarButtonItem = rightItem
                
            }else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem()
            }
            
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
    }
    
    func ge_createButtonWithTitle(_ title: String?, target: Any?) {
        
        let rightItem = UIBarButtonItem.init(title: title, style: .plain, target: target, action: #selector(ge_onRightBarClick(_:)))
        rightItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.red,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], for: .disabled)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.red,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], for: .highlighted)
        
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
}
