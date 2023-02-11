//
//  HSToolBarProtocol.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/18.
//

import Foundation
import UIKit

protocol ToolBarProtocol: AnyObject {
    /// 修改ToolBar高度
    func toolBarUpdateHeight(scrollOffset: CGFloat, isScrollDown: Bool)
    /// 将要选中文本编辑的Item
    func toolBarShouldSelectedCell(index: Int?) -> Bool
    /// 已经选中文本编辑的Item
    func toolBarDidSelectedCell(index: Int?)
    /// 舍弃编辑结果返回上一页
    func toolBarBackClousre()
    /// 编辑完成进行下一步
    func toolBarEditWallpaperEnd()
    /// 添加新的文本元素
    func toolBarAddNewTextElement()
    /// 添加新的贴纸元素
    func toolBarAddNewStickerElement(sticker: UIImage)
    /// 点击呼出键盘
    func toolBarShowSystemKeyboard()
    /// 改变文本字体
    func toolBarChangeTextFont(fontName: String)
    /// 改变文本字体颜色、透明度
    func toolBarChangeTextColor(textColor: UIColor)
    /// 改变文本shadow颜色
    func toolBarChangeTextShadow(textShadow: NSShadow)
    /// 改变文本Stroke颜色
    func toolBarChangeTextStrokeColor(textColor: String)
    /// 改变文本修饰的Size
    func toolBarChangeTextStrokeSize(size: CGFloat)
}

extension ToolBarProtocol {
    func toolBarDidSelectedCell(index: Int?) {
        
    }
    
    func toolBarShouldSelectedCell(index: Int?) -> Bool {
        return true
    }
}
