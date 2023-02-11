//
//  HSPopOverMenuModel.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

class HSPopOverMenuModel: NSObject {

    public var title: String = ""
    public var image: Imageable?
    public var disImage: Imageable?
    public var selectedImg: Imageable?
    public var selected: Bool = false
    public var isEnabled: Bool = true
}
