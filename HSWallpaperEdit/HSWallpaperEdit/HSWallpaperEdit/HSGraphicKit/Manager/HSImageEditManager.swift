//
//  HSImageEditManager.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

// MARK: 单例 -- 图片编辑管理类
class HSImageEditManager: NSObject {
    
    // 当前图片数据
    var editViewModel: HSBaseEditViewModel?
    // 当前图层是否处于获取焦点的状态
    var active: Bool = false
    // 操作栏
    var toolBar: HSToolBar?
    // 定义图片编辑回调
    typealias ImageEditHandler = (UIView) -> Void
    var imageEditHandler: ImageEditHandler?
    
    // 定义编辑回调处理 (结果图片、亮度值、对比度值)
    typealias EditImageDoneHandler = (UIImage,CGFloat?,CGFloat?) -> Void
    var editImageDoneHandler: EditImageDoneHandler?
    
    // 定义注销响应者回调处理
    typealias ImageResignFirstHandler = () -> Void
    var imageResignFirstHandler: ImageResignFirstHandler?
    
    static let imageEditShared = HSImageEditManager.init()
    override init() {}
    
    public func startEditImage(viewModel: HSBaseEditViewModel, done: @escaping EditImageDoneHandler,resignFirst: @escaping ImageResignFirstHandler) {
        self.editViewModel = viewModel
        self.editImageDoneHandler = done
        if let resignHandler = self.imageResignFirstHandler {
            resignHandler()
        }
        self.imageResignFirstHandler = resignFirst
        self.active = true
        self.toolBar?.setSelected(index: 2)
    }
    
    public func editImageEnd(brightness: Float?, contrast: Float?) {
        guard let viewModel = self.editViewModel else {
            return
        }
        if let bright = brightness {
            var newValue = bright
            // 设置阈值
            if bright <= -0.6 {
                newValue = -0.6
            }
            if bright >= 0.6 {
                newValue = 0.6
            }
            let image = HSImageService.setImage(viewModel.originImage, brightness: CGFloat(newValue))
            guard let newImage = image else {
                return
            }
            self.editImageDoneHandler?(newImage,brightness50Value(value: CGFloat(bright)),nil)
        }
        if let contrastValue = contrast {
            var newValue = contrastValue
            // 设置阈值
            if contrastValue <= 0.2 {
                newValue = 0.2
            }
            let image = HSImageService.setImage(viewModel.originImage, contrast: CGFloat(newValue))
            guard let newImage = image else {
                return
            }
            self.editImageDoneHandler?(newImage,nil,contrast50Value(value: CGFloat(newValue)))
        }
    }
    
    // 当界面存在两个图片以上的元素时,调用此方法可快速切换不通图片元素间之间的编辑状态
    public func continueEditImage(viewModel: HSBaseEditViewModel, done: @escaping EditImageDoneHandler, resignFirst: @escaping ImageResignFirstHandler) {
        // 只有当前正在处理图片时,需要切换到其他图片元素进行编辑时才生效
        if self.toolBar?.currentIndex == 2 {
            self.editViewModel = viewModel
            self.editImageDoneHandler = done
            self.imageResignFirstHandler = resignFirst
            self.active = true
        } else {
            if active {
                endImageEditAndClearCacheData()
            }
        }
    }
    
    // 结束编辑状态,清空管理类数据缓存
    public func endImageEditAndClearCacheData() {
        guard let _ = self.editViewModel else {
            return
        }
        self.editViewModel = nil
        self.editImageDoneHandler = nil
        if let resignHandler = self.imageResignFirstHandler {
            resignHandler()
        }
        self.imageResignFirstHandler = nil
        self.active = false
        self.toolBar?.hide()
    }
    
    // -1~1 / 0.02 => -50~50
    private func brightness50Value(value: CGFloat) -> CGFloat{
        let result =  value / 0.02
        return result
    }
    
    // 0~4 / 0.04 => -50~50
    // 对比度0.0 ～ 4.0，默认为1.0
    // (0~2 * 50 -50) =>-50~50
    private func contrast50Value(value: CGFloat) -> CGFloat {
        let result = value * 50 - 50
        return result
    }
}
