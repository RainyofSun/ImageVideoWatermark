//
//  HSImageEditElementView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

// MARK: 图片编辑View 个别手势事件需要重写
class HSImageEditElementView: HSBaseEditView {
    
    // 是否开启图片裁剪功能 默认不开启
    public var openImgCropAbility: Bool = false
    // 点击展示编辑菜单回调
    typealias ShowEditMenuClousre = ((HSImageEditElementView,HSEditTagView) -> Void)
    var showEditMenuClousre: ShowEditMenuClousre?
    
    deinit {
        deallocPrint()
    }
}

// MARK: 覆写父类点击手势
extension HSImageEditElementView {
    // 覆写父类双击手势,开始图片的编辑
    override func doubleTapHandle(sender: UITapGestureRecognizer) {
        super.doubleTapHandle(sender: sender)
        // 弹出编辑菜单
        self.showEditMenuClousre?(self,self.topRightTagView)
    }
    
    // 覆写父类单击手势,元素获取焦点
    override func singleTapHandle(sender: UITapGestureRecognizer) {
        super.singleTapHandle(sender: sender)
    }
    
    // 覆写父类tagView的点击手势,开始图片的裁剪
    override func tagViewTapHandle(sender: UITapGestureRecognizer) {
        super.tagViewTapHandle(sender: sender)
        self.doubleTapHandle(sender: sender)
        if !self.openImgCropAbility {
            return
        }
        // 暂不开放图片裁剪编辑模式
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
