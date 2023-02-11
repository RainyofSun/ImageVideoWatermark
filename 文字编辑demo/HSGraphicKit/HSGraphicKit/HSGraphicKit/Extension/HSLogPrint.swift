//
//  HSLogPrint.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/9.
//

import UIKit

extension NSObject {
    public func deallocPrint() {
        print("deinit: \(NSStringFromClass(type(of: self)))")
    }
}
