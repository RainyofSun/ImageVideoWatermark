//
//  HSImageInfoModel.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

import UIKit

class HSImageInfoModel: NSObject {
    var brightness: CGFloat?    // 亮度 -1.0到1.0 => 公共对应 -50～50
    var contrast: CGFloat?      // 对比度 0.0到4.0 => 公共对应 -50～50
    var image: UIImage?         // 数据中Origin Image，对比度、亮度作用的Image
    var showImage: UIImage?     // 用来显示的Image
}
