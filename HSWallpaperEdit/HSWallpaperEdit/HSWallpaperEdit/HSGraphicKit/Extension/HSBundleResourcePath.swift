//
//  HSBundleResourcePath.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

class HSBundleResourcePath: NSObject {
    public class func bundleResource(resourceName: String, resourceType: String = "png", resourceDirectory:String = "") -> UIImage {
        let imgBundlePath: String = Bundle.main.path(forResource:"BigResourceBundle", ofType:"bundle") ?? ""
        if imgBundlePath.isEmpty {
            return UIImage.init()
        }
        let imgBundle: Bundle = Bundle.init(path: imgBundlePath)!
        var imgPath: String = ""
        if resourceDirectory.isEmpty {
            imgPath = imgBundle.path(forResource: resourceName, ofType: resourceType) ?? ""
        } else {
            imgPath = imgBundle.path(forResource:resourceName, ofType:resourceType, inDirectory:resourceDirectory) ?? ""
        }
        if imgPath.isEmpty {
            return UIImage.init()
        }
        return UIImage.init(contentsOfFile: imgPath)!
    }
}
