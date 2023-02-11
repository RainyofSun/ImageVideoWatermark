//
//  HSTextEditToolBar.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/14.
//

import UIKit

// MARK: 文字模式修改的二级菜单
class HSTextEditToolBar: UIView {

    private(set) var selectedIndex: Int? {
        didSet {
            
        }
    }
    
    // 文本编辑代理
    weak var fontBarDelegate: TextEditProtocol?
    
    var items: [HSToolBarItem]? {
        didSet {
            self.loadTextToolBarData()
        }
    }
    
    private lazy var barContentView: UIScrollView = {
        let view = UIScrollView.init()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
    
    private lazy var editContentView: UIScrollView = {
        let view = UIScrollView.init()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        return view
    }()
    
    private lazy var addCell: HSToolBarCell = {
        let item: HSToolBarItem = HSToolBarItem.init()
        item.image = UIImage.init(named: "button_new")
        item.selectedImage = UIImage.init(named: "button_new")
        item.itemWidth = 60
        item.itemHeight = 50
        let cell: HSToolBarCell = HSToolBarCell.init(type: UIButton.ButtonType.custom)
        cell.barItem = item
        return cell
    }()
    
    private lazy var keyboardCell: HSToolBarCell = {
        let item: HSToolBarItem = HSToolBarItem.init()
        item.image = UIImage.init(named: "button_keyboard")
        item.selectedImage = UIImage.init(named: "button_keyboard")
        item.itemWidth = 60
        item.itemHeight = 50
        let cell: HSToolBarCell = HSToolBarCell.init(type: UIButton.ButtonType.custom)
        cell.barItem = item
        return cell
    }()
    
    // 字体编辑的view
    private lazy var fontStyleView: HSTextFontEditView = {
        let view = HSTextFontEditView.init(frame: CGRect.zero)
        view.fontDidScrollClousre = {[weak self] (scrollOffset: CGFloat, scrollDown: Bool) in
            self?.fontBarDelegate?.updateToolBarHeight(scrollOffset: scrollOffset, isScrollDown: scrollDown)
        }
        view.fontSelectedClousre = {[weak self] (fontName: String) in
            self?.fontBarDelegate?.changeTextFont(fontName: fontName)
        }
        return view
    }()
    
    // 字体颜色编辑的View
    private lazy var colorStyleView: HSTextColorEditView = {
        let view = HSTextColorEditView.init(frame: CGRect.zero)
        view.textColorClousre = {[weak self] (textColor: UIColor) in
            self?.fontBarDelegate?.changeTextColor(textColor: textColor)
        }
        return view
    }()
    
    // 字体阴影编辑的View
    private lazy var shadowStyleView: HSTextShadowColorEditView = {
        let view = HSTextShadowColorEditView.init(frame: CGRect.zero)
        view.textShadowClousre = {[weak self] (textShadow: NSShadow) in
            self?.fontBarDelegate?.changeTextShadow(textShadow: textShadow)
        }
        view.textStrokeColorClousre = {[weak self] (textColor: String) in
            self?.fontBarDelegate?.changeTextStrokeColor(textColor: textColor)
        }
        view.strokeSizeClousre = {[weak self] (size: CGFloat) in
            self?.fontBarDelegate?.changeTextStrokeSize(size: size)
        }
        return view
    }()
    
    private var currentCell: HSToolBarCell?
    private var cells: [HSToolBarCell] = [HSToolBarCell]()
    
    public var currentIndex: Int? {
        get {
            return selectedIndex
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutTextToolBarViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }

    private func loadTextToolBarData() {
        guard let barItems = items,barItems.count > 0 else { return }
        for index in 0..<barItems.count {
            let item: HSToolBarItem = barItems[index]
            let cell = HSToolBarCell.init(type: .custom)
            cell.barItem = item
            cell.addTarget(self, action: #selector(clickToolBarCell(sender:)), for: .touchUpInside)
            cells.append(cell)
            cell.frame = CGRect.init(x: item.itemWidth * CGFloat(index), y: 0, width: item.itemWidth, height: item.itemHeight)
            if index == 0 {
                cell.isSelected = true
                currentCell = cell
            }
            barContentView.addSubview(cell)
        }
        
        barContentView.contentSize = CGSize.init(width: CGFloat(barItems.count) * cells.first!.barItem!.itemWidth, height: 0)
        barContentView.isScrollEnabled = barContentView.contentSize.width > barContentView.frame.width
        
        editContentView.contentSize = CGSize.init(width: CGFloat(barItems.count) * K_SCREEN_WIDTH, height: 0)
        editContentView.isScrollEnabled = false

        self.loadTextToolBarViews()
    }
    
    private func loadTextToolBarViews() {
        addCell.addTarget(self, action: #selector(addNewTextElement(sender:)), for: .touchUpInside)
        keyboardCell.addTarget(self, action: #selector(clickKeyboardCell(sender:)), for: .touchUpInside)
        
        self.addSubview(addCell)
        self.addSubview(keyboardCell)
        self.addSubview(barContentView)
        self.addSubview(editContentView)
        self.editContentView.addSubview(fontStyleView)
    }
    
    private func layoutTextToolBarViews() {
        self.addCell.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(CGSize.init(width: addCell.barItem!.itemWidth, height: addCell.barItem!.itemHeight))
        }
        self.keyboardCell.snp.makeConstraints { make in
            make.top.size.equalTo(self.addCell)
            make.left.equalTo(self.addCell.snp.right)
        }
        
        barContentView.frame = CGRect.init(x: 120, y: 0, width: K_SCREEN_WIDTH - 120, height: 50)
        editContentView.frame = CGRect.init(x: 0, y: barContentView.frame.height, width: K_SCREEN_WIDTH, height: self.frame.height - barContentView.frame.height)
        fontStyleView.frame = CGRect.init(x: 0, y: 0, width: editContentView.frame.width, height: editContentView.frame.height)
    }
}

extension HSTextEditToolBar {
    // 点击添加新的文本元素
    @objc private func addNewTextElement(sender: HSToolBarCell) {
        self.fontBarDelegate?.addNewTextElement()
    }
    
    // 点击呼出键盘进行文本编辑
    @objc private func clickKeyboardCell(sender: HSToolBarCell) {
        self.fontBarDelegate?.showSystemKeyboard()
    }
    
    /// Cell的点击方法
    @objc private func clickToolBarCell(sender: HSToolBarCell) {
        guard !sender.isSelected else {
            return
        }
        guard let index = cells.firstIndex(of: sender) else { return }
        let isAllow: Bool = fontBarDelegate?.textEditBarShouldSelectedCell(index: index) ?? true
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
        if colorStyleView.superview == nil && index == 1 {
            colorStyleView.frame = CGRect.init(x: K_SCREEN_WIDTH, y: 0, width: K_SCREEN_WIDTH, height: editContentView.frame.height)
            editContentView.addSubview(colorStyleView)
        }
        if shadowStyleView.superview == nil && index == 2 {
            shadowStyleView.frame = CGRect.init(x: K_SCREEN_WIDTH * CGFloat(index), y: 0, width: K_SCREEN_WIDTH, height: editContentView.frame.height)
            editContentView.addSubview(shadowStyleView)
        }
        editContentView.setContentOffset(CGPoint.init(x: CGFloat(index) * K_SCREEN_WIDTH, y: 0), animated: true)
        fontBarDelegate?.textEditBarDidSelectedCell(index: selectedIndex)
    }
    
    func cancelSelected() {
        currentCell?.isSelected = false
        currentCell = nil
        selectedIndex = nil
    }
    
    func setSelected(index: Int) {
        let cell: HSToolBarCell = cells[index]
        currentCell?.isSelected = false
        if currentCell != cell {
            currentCell = cell
            currentCell?.isSelected = true
            selectedIndex = index
        } else {
            currentCell = nil
            selectedIndex = nil
        }
        fontBarDelegate?.textEditBarDidSelectedCell(index: selectedIndex)
    }
}
