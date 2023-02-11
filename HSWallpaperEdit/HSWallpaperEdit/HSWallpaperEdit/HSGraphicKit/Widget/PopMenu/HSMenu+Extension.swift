//
//  HSMenu+Extension.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import Foundation
import UIKit

public protocol Imageable {
    func getImage() -> UIImage?
}

extension String: Imageable {
    public func getImage() -> UIImage? {
        return UIImage(named: self)
    }
}

extension UIImage: Imageable {
    public func getImage() -> UIImage? {
        return self
    }
}

public protocol HSMenuObject {
    
}

extension String: HSMenuObject {
    
}

extension HSPopOverMenuModel: HSMenuObject {
    
}
