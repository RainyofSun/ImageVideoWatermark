//
//  HSBaseEditViewModel.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

// MARK: 处理文本图片编辑框的数据交互
class HSBaseEditViewModel: NSObject {
    
    open var viewLayerData: HSImageTextLayerModel!
    
    // 元素旋转的角度
    open var rotation: CGFloat? {
        didSet {
            viewLayerData.rotate = rotation
        }
    }
    
    // 获取元素旋转角度
    open var getRotation: CGFloat {
        get {
            return viewLayerData.rotate ?? 0
        }
    }
    // 元素的Center
    open var viewCenter: CGPoint?
    // 元素的bounds
    open var viewBounds: CGSize?
    // 元素Layer层的Transform
    open var layerTransform: CATransform3D?
    // 元素子Layer层的Transform
    open var sublayerTransform: CATransform3D?
    // 元素view层的Transform
    open var viewTransform: CGAffineTransform?
    // 文字元素编辑快照
    open var textSnap: UIImage?
    
    // 元素类型
    open var elemenetType: HSEditType {
        get {
            return HSEditType(rawValue: viewLayerData.type!) ?? .TEXT
        }
    }
    
    var text: String? {
        didSet {
            let textInfo = HSTextInfoModel.init()
            textInfo.text = text
            viewLayerData.textInfo = textInfo
        }
    }
    
    // 亮度对比编辑的原始图片 裁剪后的图片
    var originImage: UIImage? {
        didSet {
            viewLayerData.imageInfo!.image = originImage
        }
    }

    // 显示用的图片 裁剪后的图片、亮度对比编辑后的图片
    var currentImage: UIImage? {
        didSet {
            viewLayerData.imageInfo!.showImage = currentImage
        }
    }
    
    override init() {
        super.init()
        viewLayerData = HSImageTextLayerModel.init()
    }
}
