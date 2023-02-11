//
//  HSToolBarItem.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

class HSToolBarItem: NSObject {
    var image: UIImage?
    var text: String?
    
    var selectedImage: UIImage?
    var selectedText: String?
    
    var textColor: UIColor?
    var selectedTextColor: UIColor?
    
    var itemWidth: CGFloat = 0.0
    
    deinit {
        deallocPrint()
    }
}
