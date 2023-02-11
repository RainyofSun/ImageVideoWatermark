//
//  HSSafeArea.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/10.
//

import Foundation
import UIKit

func getWindow() -> UIWindow {
    let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
    return window!
}

extension UIViewController {
    func safeAreaInsetsBottom() -> CGFloat {
        var value: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            value = self.view.safeAreaInsets.bottom
        }
        return value
    }

    func safeAreaInsetsTop() -> CGFloat {
        var value: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            value = self.view.safeAreaInsets.top
        }
        return value
    }

    func safeWindowAreaInsetsBottom() -> CGFloat {
        var value: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            value = getWindow().safeAreaInsets.bottom
        }
        return value
    }
    func safewindowAreaInsetsTop() -> CGFloat {
        var value: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            value = getWindow().safeAreaInsets.top
        }
        return value
    }

    func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    func navHeight() -> CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 44
    }
}
