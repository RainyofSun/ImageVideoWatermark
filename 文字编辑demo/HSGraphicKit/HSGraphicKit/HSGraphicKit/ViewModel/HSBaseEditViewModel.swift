//
//  HSBaseEditViewModel.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

// MARK: 处理文本图片编辑框的数据交互
class HSBaseEditViewModel: NSObject {
    var viewLayerData: HSImageTextLayerModel!
    
    // 第一次渲染的data，宽高不变，x,y随拖动变化
    var data: HSImageTextLayerModel? {
        didSet {
            viewLayerData = data
        }
    }
    
    var origin: CGPoint? {
        didSet {
            viewLayerData.x = origin?.x
            viewLayerData.y = origin?.y
        }
    }
    
    // 文本框的Frame是动态变化的,（图片的记录数据是初始图片的宽高）
    var frame: CGRect? {
        didSet {
            viewLayerData.x = frame?.origin.x
            viewLayerData.y = frame?.origin.y
            viewLayerData.width = frame?.width
            viewLayerData.height = frame?.height
        }
    }
    
    var scale: CGFloat? {
        didSet {
            viewLayerData.scale = scale
        }
    }
    
    var rotate: CGFloat? {
        didSet {
            viewLayerData.rotate = rotate
        }
    }
    
    // 亮度对比编辑的原始图片 裁剪后的图片
    var originImage: UIImage? {
        didSet {
            if let info = viewLayerData.imageInfo {
                info.image = originImage
            } else {
                let imgInfo = HSImageInfoModel.init()
                imgInfo.image = originImage
                viewLayerData.imageInfo = imgInfo
            }
        }
    }
    
    // 显示用的图片 裁剪后的图片、亮度对比编辑后的图片
    var currentImage: UIImage? {
        didSet {
            if let info = viewLayerData.imageInfo {
                info.showImage = currentImage
            } else {
                let imageInfo = HSImageInfoModel.init()
                imageInfo.showImage = currentImage
                imageInfo.image = currentImage
                viewLayerData.imageInfo = imageInfo
            }
        }
    }
    
    var brightness: CGFloat? {
        didSet {
            if let info = viewLayerData.imageInfo, let bright = brightness {
                info.brightness = bright
            }
        }
    }
    
    var contrast: CGFloat? {
        didSet {
            if let info = viewLayerData.imageInfo, let contrast = contrast {
                info.contrast = contrast
            }
        }
    }
    
    var text: String? {
        didSet {
            let textInfo = HSTextInfoModel.init()
            textInfo.text = text
            viewLayerData.textInfo = textInfo
        }
    }
    
    override init() {
        viewLayerData = HSImageTextLayerModel.init()
    }
}
