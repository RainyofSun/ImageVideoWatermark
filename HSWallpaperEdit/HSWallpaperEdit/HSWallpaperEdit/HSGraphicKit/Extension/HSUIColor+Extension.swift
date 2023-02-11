//
//  HSUIColor+Extension.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/10.
//

import UIKit

// MARK: 颜色配置文件
let HSMainBGColor = UIColor(hexString: "#333333")
let HSDarkBGColor = UIColor(hexString: "#111111")
let HSSelectedTextColor = UIColor.white
let HSUnSelectedTextColor = UIColor(hexString:"#666666")
let HSAlertBGColor = UIColor.init(white: 0, alpha: 0.5)
let HSAlertSureBtnColor = UIColor(hexString:"#555555")
let HSAlertCancelBtnColor = UIColor(hexString:"#e04162")
let HSPlaceholderColor = UIColor(hexString:"#666666")
let HSInputColor = UIColor.init(HSHex: 0x313043)
let HSSecondaryTitleColor = UIColor(hexString:"#999999")
let HSFontStyleUnselectedColor = UIColor(hexString:"#292929")
let HSStickerCellBGColor = UIColor(hexString:"#2c2c2c")
let HSMouseColor = UIColor(hexString:"#9A0808")
let HSGradientColor1 = UIColor(hexString:"#92fe9d")
let HSGradientColor2 = UIColor(hexString:"#00c9ff")
let HSLineColor = UIColor.init(HS_R: 222, HS_G: 222, HS_B: 222)
let HSItemFillColor = UIColor.init(HS_R: 248, HS_G: 249, HS_B: 251)
let HSLinkColor = UIColor.init(HS_R: 1, HS_G: 144, HS_B: 254)

let HSThemeColor = UIColor.init(HS_R:48, HS_G: 117, HS_B:238)
let HSLayerColor = UIColor.init(HS_R:48, HS_G: 117, HS_B:238)
let HSBGColor = UIColor.init(HS_R:247, HS_G: 248, HS_B:250)
let HSShadowColor = UIColor.init(HS_R:0, HS_G: 0, HS_B:0)
let HSEditingTextBGColor = UIColor.init(HS_R:198, HS_G: 216, HS_B:234)
let HSBGAlphaColor = UIColor.init(HS_R:0, HS_G: 0, HS_B:0, alpha: 0.5)
let HSTOPLineColor = UIColor.init(HS_R:247, HS_G: 248, HS_B:250)
let HSTextPlaceholderColor = UIColor.init(HS_R: 220, HS_G: 222, HS_B: 224)

extension UIColor {
    
    convenience init(HS_R:CGFloat, HS_G:CGFloat, HS_B:CGFloat, alpha:CGFloat) {
        self.init(red: HS_R/255.0, green: HS_G/255.0, blue: HS_B/255.0, alpha: alpha)
    }
    
    convenience init(HS_R:CGFloat, HS_G:CGFloat, HS_B:CGFloat) {
        self.init(HS_R: HS_R, HS_G: HS_G, HS_B: HS_B, alpha: 1.0)
    }
    
    convenience init(HSHex:UInt, alpha:CGFloat) {
        let r = ((HSHex >> 16) & 0x000000FF)
        let g = ((HSHex >> 8) & 0x000000FF)
        let b = ((HSHex >> 0) & 0x000000FF)
        
        self.init(HS_R: CGFloat(r), HS_G: CGFloat(g), HS_B: CGFloat(b), alpha: alpha)
    }
    
    convenience init(HSHex:UInt) {
        self.init(HSHex: HSHex, alpha: 1.0)
    }
    
    class func HSRandomColor() -> UIColor {
        let seed:UInt32 = 256
        //获取一个范围是[0,256)的随机数
        let r = CGFloat(arc4random_uniform(seed))
        let g = CGFloat(arc4random_uniform(seed))
        let b = CGFloat(arc4random_uniform(seed))
        
        return UIColor(HS_R: r, HS_G: g, HS_B: b, alpha:1.0)
    }
    
    convenience init(hexString: String,alpha: CGFloat = 1.0) {
            let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
            let scanner = Scanner(string: hexString)
             
            if hexString.hasPrefix("#") {
                scanner.scanLocation = 1
            }
             
            var color: UInt32 = 0
            scanner.scanHexInt32(&color)
             
            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
             
            let red   = CGFloat(r) / 255.0
            let green = CGFloat(g) / 255.0
            let blue  = CGFloat(b) / 255.0
             
            self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    
    func geImageWithColor(size: CGSize = CGSize.init(width: 1, height: 1)) -> UIImage? {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor( self.cgColor )
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
