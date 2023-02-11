//
//  HSImageEditElementView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

// MARK: 图片编辑View 个别手势事件需要重写
class HSImageEditElementView: HSBaseEditView {

    deinit {
        deallocPrint()
    }
}

// MARK: 覆写父类点击手势
extension HSImageEditElementView {
    // 覆写父类双击手势,开始图片的编辑
    override func doubleTapHandle(sender: UITapGestureRecognizer) {
        super.doubleTapHandle(sender: sender)
        // 开始编辑图片
        self.editContentImage()
    }
    
    // 覆写父类单击手势,元素获取焦点
    override func singleTapHandle(sender: UITapGestureRecognizer) {
        super.singleTapHandle(sender: sender)
        // 开始编辑图片
        self.continueEditImage()
    }
    
    // 覆写父类tagView的点击手势,开始图片的裁剪
    override func tagViewTapHandle(sender: UITapGestureRecognizer) {
        super.tagViewTapHandle(sender: sender)
        HSImageCropManager.imageCropShared.statrImageCrop(image: contentView.image) { [weak self] (image) in
            guard let closureSelf = self else {
                return
            }
            let originFrame = closureSelf.frame
            let imageSize = image.size
            let aspectRatio = imageSize.width / imageSize.height
            let size = CGSize.init(width: 300, height: 300/aspectRatio)
            closureSelf.frame = CGRect.init(x: originFrame.origin.x, y: originFrame.origin.y, width: size.width, height: size.height)
            closureSelf.image = image
            closureSelf.viewModel.originImage = image
            closureSelf.viewModel.currentImage = image
            let _ = closureSelf.becomeFirstResponder()
        }
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension HSImageEditElementView {
    // 开始编辑图片
    private func editContentImage() {
        guard let model = self.viewModel else {
            return
        }
        HSImageEditManager.imageEditShared.startEditImage(viewModel: model) { image, brightness, contrast in
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.viewModel.currentImage = image
                if let brightness = brightness {
                    self?.viewModel.brightness = brightness
                }
                if let contrast = contrast {
                    self?.viewModel.contrast = contrast
                }
            }
        } resignFirst: { [weak self] in
            self?.resginActive()
        }
        // 当编辑框为第一响应者时，editView也需要边框)
        let _ = self.becomeFirstResponder()
    }
    
    // 图片在编辑状态时快速切换到其他的图片视图
    private func continueEditImage() {
        guard let model = self.viewModel else { return }
        HSImageEditManager.imageEditShared.continueEditImage(viewModel: model) { image, brightness, contrast in
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.viewModel.currentImage = image
                if let brightness = brightness {
                    self?.viewModel.brightness = brightness
                }
                if let contrast = contrast {
                    self?.viewModel.contrast = contrast
                }
            }
        } resignFirst: { [weak self] in
            self?.resginActive()
        }
    }
}
