//
//  HSUIColor+Extension.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/10.
//

import UIKit

// MARK: 颜色配置文件
let HSMainTitleColor = UIColor.black
let HSMainButtonColor = UIColor.init(HS_R: 48, HS_G: 118, HS_B: 238)//UIColor.init(HS_R: 255, HS_G: 235, HS_B: 51)
let HSTableViewBGColor = UIColor.init(HS_R: 244, HS_G: 244, HS_B: 244)
let HSMainBGColor = UIColor.white
let HSPlaceholderColor = UIColor.init(HS_R: 152, HS_G: 152, HS_B: 152)
let HSInputColor = UIColor.init(HSHex: 0x313043)
let HSSecondaryTitleColor = UIColor.init(HS_R: 102, HS_G: 102, HS_B: 102)
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
    
    //        return UIColor(hue: weight, saturation: 1, brightness: 1, alpha: 1)
    //        /**
    //         * hue : 色调 0~1
    //         * saturation : 饱和度 0~1
    //         * brightness : 亮度 0~1
    //         */
    //    }
    
    
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
