//
//  HSConfiguration.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

public class HSConfiguration: NSObject {
    public var menuRowHeight = HS.DefaultMenuRowHeight
    public var menuItemWidth = HS.DefaultMenuItemWidth
    public var menuWidth = HS.DefaultMenuWidth
    public var borderColor = HS.DefaultTintColor
    public var borderWidth = HS.DefaultBorderWidth
    public var backgoundTintColor = HS.DefaultTintColor
    public var cornerRadius = HS.DefaultCornerRadius

    public var globalShadow = false
    public var shadowAlpha: CGFloat = 0.6
    public var localShadow = false
    public var globalShadowAdapter: ((_ backgroundView: UIView) -> Void)?
    public var localShadowAdapter: ((_ backgroundLayer: CAShapeLayer) -> Void)?
    
    // cell configs
    public var textColor: UIColor = UIColor.white
    public var textDisableColor: UIColor = UIColor.init(hexString: "#555555")
    public var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var textAlignment: NSTextAlignment = NSTextAlignment.left
    public var ignoreImageOriginalColor = false
    public var menuIconSize: CGFloat = HS.DefaultMenuIconSize
    
    /// indexes that will not dismiss on selection
    public var noDismissalIndexes: [Int]?
}
