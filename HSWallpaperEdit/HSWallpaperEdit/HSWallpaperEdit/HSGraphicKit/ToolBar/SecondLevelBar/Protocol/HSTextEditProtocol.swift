//
//  HSTextEditProtocol.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/18.
//

import Foundation
import UIKit

protocol TextEditProtocol: AnyObject {
    /// 字体滚动的时候,重置更新Bar的高度
    func updateToolBarHeight(scrollOffset: CGFloat, isScrollDown: Bool)
    /// 将要选中文本编辑的Item
    func textEditBarShouldSelectedCell(index: Int?) -> Bool
    /// 已经选中文本编辑的Item
    func textEditBarDidSelectedCell(index: Int?)
    /// 添加新的文本元素
    func addNewTextElement()
    /// 点击呼出键盘
    func showSystemKeyboard()
    /// 改变文本字体
    func changeTextFont(fontName: String)
    /// 改变文本字体颜色、透明度
    func changeTextColor(textColor: UIColor)
    /// 改变文本shadow颜色
    func changeTextShadow(textShadow: NSShadow)
    /// 改变文本Stroke颜色
    func changeTextStrokeColor(textColor: String)
    /// 改变文本修饰Size
    func changeTextStrokeSize(size: CGFloat)
}

extension TextEditProtocol {
    func textEditBarDidSelectedCell(index: Int?) {
        
    }
    
    func textEditBarShouldSelectedCell(index: Int?) -> Bool {
        return true
    }
}
