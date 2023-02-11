//
//  HSColorEditScrollView.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

// MARK: 颜色编辑选择控件
class HSColorEditScrollView: UIScrollView {
    
    // 定义颜色选择回调
    typealias ColorSelectedClosure = ((_ selectedCell: HSTextColorElementView) -> Void)
    var colorSelectedClosure: ColorSelectedClosure?
    // 当前选中的cell
    public var currentSelectedCell: HSTextColorElementView {
        get {
            return selectedCell!
        }
    }
    
    private var selectedCell: HSTextColorElementView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    public func setupColors(colors:[String]) {
        let cellWidth: CGFloat = 28
        let cellPadding: CGFloat = 15
        let contentSizeWidth: CGFloat = (cellWidth + cellPadding) * CGFloat(colors.count)
        
        for index in 0..<colors.count {
            autoreleasepool {
                let colocrCell: HSTextColorElementView = HSTextColorElementView.init(type: UIButton.ButtonType.custom)
                colocrCell.backgroundColorStr = colors[index]
                colocrCell.frame = CGRect.init(x: (cellWidth + cellPadding) * CGFloat(index), y: 1, width: cellWidth, height: cellWidth)
                if index == 0 {
                    colocrCell.isSelected = true
                    selectedCell = colocrCell
                }
                colocrCell.addTarget(self, action: #selector(selectedTextColor(sender:)), for: .touchUpInside)
                self.addSubview(colocrCell)
            }
        }
        self.contentSize = CGSize.init(width: contentSizeWidth, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

extension HSColorEditScrollView {
    // 选择文本颜色
    @objc private func selectedTextColor(sender: HSTextColorElementView) {
        guard !sender.isSelected else {
            return
        }
        selectedCell?.isSelected = false
        if selectedCell != sender {
            selectedCell = sender
            selectedCell?.isSelected = true
            self.colorSelectedClosure?(selectedCell!)
        } else {
            selectedCell = nil
        }
    }
}
