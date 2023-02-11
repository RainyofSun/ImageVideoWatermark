//
//  UIViewController+Extension.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/20.
//

import Foundation
import UIKit

extension UIViewController {
    /// 禁用侧滑返回手势
    func popGestureClose() {
        let target = self.navigationController?.interactivePopGestureRecognizer?.delegate
        self.view.addGestureRecognizer(UIPanGestureRecognizer.init(target: target, action: nil))
    }
    
    /// 启用侧滑返回手势
    func popGestureOpen() {
        for item in 0..<(self.view.gestureRecognizers?.count ?? 0) {
            let panGes = self.view.gestureRecognizers?[item] as? UIPanGestureRecognizer
            if panGes != nil {
                self.view.removeGestureRecognizer(panGes!)
            }
        }
    }
}
