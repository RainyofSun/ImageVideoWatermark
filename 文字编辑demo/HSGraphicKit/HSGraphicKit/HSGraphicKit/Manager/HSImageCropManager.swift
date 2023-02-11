//
//  HSImageCropManager.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

// MARK: 单例类 -- 图片的裁剪管理类
class HSImageCropManager: NSObject {
    var image: UIImage?
    
    // 定义裁剪回调
    typealias CropImageHandler = (UIImage) -> Void
    var cropImageHander: CropImageHandler?
    
    static let imageCropShared = HSImageCropManager.init()
    override init() {}
    
    public func statrImageCrop(image: UIImage?, handler: @escaping CropImageHandler) {
        guard let img = image else {
            return
        }
        self.cropImageHander = handler
        self.image = image
        let cropController = HSImageCropViewController.init()
        cropController.image = img
        cropController.cropImageClosure = { [weak self] (image) in
            self?.cropImageHander?(image)
        }
        let cropNav = UINavigationController.init(rootViewController: cropController)
        cropController.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(cropNav, animated: true, completion: nil)
    }
}
