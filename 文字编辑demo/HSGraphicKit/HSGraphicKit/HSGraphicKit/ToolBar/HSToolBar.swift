//
//  HSToolBar.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

class HSToolBar: UIView {

    private(set) var selectedIndex: Int? {
        didSet {
            
        }
    }
    
    var didSelectedCell: ((_ index: Int?) -> Void)?
    var shouldSelectedCell: ((_ index: Int?) -> Bool)?
    
    var items: [HSToolBarItem]? {
        didSet {
            self.loadToolBarData()
        }
    }
    var contentView: UIView?
    private lazy var backgroundView: UIView = {
        let image = UIImage.init(named: "bg_tools")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 30, left: 20, bottom: 30, right: 20), resizingMode: UIImage.ResizingMode.stretch)
        let view = UIImageView.init(image: image)
        view.isUserInteractionEnabled = true
        return view
    }()

    private var currentCell: HSToolBarCell?
    
    private var cells: [HSToolBarCell]? {
        didSet {
            self.layoutToolBarSubview()
        }
    }
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    public var currentIndex: Int? {
        get {
            return selectedIndex
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadToolBarViews()
        self.loadToolBarData()
        self.layoutToolBarSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutToolBarSubview()
    }
    
    deinit {
        deallocPrint()
    }

    private func loadToolBarData() {
        guard let barItems = items,barItems.count > 0 else { return }
        var newCells = [HSToolBarCell]()
        for item in barItems {
            let cell = HSToolBarCell.init(type: .custom)
            cell.barItem = item
            cell.addTarget(self, action: #selector(clickToolBarCell(sender:)), for: .touchUpInside)
            newCells.append(cell)
        }
        cells = newCells
        self.loadToolBarViews()
    }
    
    private func loadToolBarViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        guard let cells = cells, cells.count > 0 else { return }
        self.addSubview(backgroundView)
        for cell in cells {
            backgroundView.addSubview(cell)
        }
        backgroundView.addSubview(bottomLineView)
    }
    
    private func layoutToolBarSubview() {
        guard let items = items else { return }
        guard let cells = cells,cells.count > 0 else { return }
        
        backgroundView.frame = self.bounds
        var autoWidthCount: Int = 0
        var customWidth: CGFloat = 0
        
        for item in items {
            if item.itemWidth <= 0 {
                autoWidthCount += 1
            } else {
                customWidth += item.itemWidth
            }
        }
        
        var width: CGFloat = (self.frame.width - customWidth) / CGFloat(autoWidthCount)
        let height: CGFloat = 48.0
        let y: CGFloat = 16.0
        for i in 0..<cells.count {
            let cell: HSToolBarCell = cells[i]
            let item: HSToolBarItem = items[i]
            let x: CGFloat = CGFloat(i) * width
            if item.itemWidth > 0 {
                width = item.itemWidth
            }
            cell.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
        
        if let cell = currentCell {
            let blHight: CGFloat = 2.0
            let blWidth: CGFloat = 20.0
            let y = y + height - blHight
            bottomLineView.frame = CGRect.init(x: 0, y: y, width: blWidth, height: blHight)
            bottomLineView.center = CGPoint.init(x: cell.center.x, y: bottomLineView.center.y)
            bottomLineView.isHidden = false
        } else {
            bottomLineView.isHidden = true
        }
    }
}

extension HSToolBar {
    // 点击方法
    @objc func clickToolBarCell(sender: HSToolBarCell) {
        guard let index = cells?.firstIndex(of: sender) else { return }
        let isAllow: Bool = shouldSelectedCell?(index) ?? true
        guard isAllow else {
            return
        }
        currentCell?.isSelected = false
        if currentCell != sender {
            currentCell = sender
            currentCell?.isSelected = true
            selectedIndex = index
        } else {
            currentCell = nil
            selectedIndex = nil
        }
        didSelectedCell?(selectedIndex)
        self.layoutToolBarSubview()
    }
    
    func show(contentView: UIView, frame: CGRect) {
        self.contentView?.removeFromSuperview()
        self.contentView = contentView
        self.addSubview(contentView)
        contentView.frame = CGRect.init(x: 0, y: 64.0, width: frame.width, height: frame.height - 64.0)
        UIView.animate(withDuration: 0.3) {
            self.frame = frame
        }
    }
    
    func hide(frame: CGRect) {
        UIView.animate(withDuration: 0.3) {
            self.frame = frame
        } completion: { isFinished in
            self.contentView?.removeFromSuperview()
            self.contentView = nil
        }
        self.cancelSelected()
    }
    
    func cancelSelected() {
        currentCell?.isSelected = false
        currentCell = nil
        selectedIndex = nil
        self.layoutToolBarSubview()
    }
    
    func hide() {
        cancelSelected()
        guard let content = self.contentView else { return }
        let contentHeight = content.frame.height
        var frame = self.frame
        frame.size.height -= contentHeight
        frame.origin.y += contentHeight
        UIView.animate(withDuration: 0.3) {
            self.frame = frame
        } completion: { isFinished in
            self.contentView?.removeFromSuperview()
            self.contentView = nil
        }
    }
    
    func setSelected(index: Int) {
        guard let cell = cells?[index] else { return }
        currentCell?.isSelected = false
        if currentCell != cell {
            currentCell = cell
            currentCell?.isSelected = true
            selectedIndex = index
        } else {
            currentCell = nil
            selectedIndex = nil
        }
        didSelectedCell?(selectedIndex)
        self.layoutSubviews()
    }
}
