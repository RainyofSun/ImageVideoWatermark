//
//  HSToolBar.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

class HSToolBar: UIView {
    
    weak var toolBarDeleagte: ToolBarProtocol?
    
    // 选中的下标
    public var currentIndex: Int? {
        get {
            return selectedIndex
        }
    }
    
    var contentView: UIView?
    
    private lazy var backgroundView: UIView = {
        let view = UIImageView.init(image: UIImage.init(named: "toolBar_bg1"))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var backBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "icon_back"), for: .normal)
        view.setImage(UIImage.init(named: "icon_back"), for: .highlighted)
        return view
    }()
    
    private lazy var doneBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "icon_Finish"), for: .normal)
        view.setImage(UIImage.init(named: "icon_Finish"), for: .highlighted)
        return view
    }()

    private lazy var textCell: HSToolBarCell = {
        let view = HSToolBarCell.init(type: UIButton.ButtonType.custom)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.isSelected = true
        return view
    }()
    
    private lazy var stickersCell: HSToolBarCell = {
        let view = HSToolBarCell.init(type: UIButton.ButtonType.custom)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return view
    }()
    
    private lazy var scrollContentView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    // 文本编辑二级菜单
    private lazy var secondEditToolBar: HSTextEditToolBar = {
        let view: HSTextEditToolBar = HSTextEditToolBar.init(frame: CGRect.zero)
        view.items = getToolBarEditItems()
        return view
    }()
    
    // sticker 菜单
    private lazy var stickerView: HSStickerView = {
        let view = HSStickerView.init(frame: CGRect.zero)
        view.didSelectedStickers = {[weak self] (sticker: UIImage) in
            self?.toolBarDeleagte?.toolBarAddNewStickerElement(sticker: sticker)
        }
        return view
    }()
    
    private var currentCell: HSToolBarCell?
    private var cells: [HSToolBarCell] = [HSToolBarCell]()
    
    private(set) var selectedIndex: Int? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadToolBarData()
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
        
        let textItem: HSToolBarItem = HSToolBarItem.init()
        textItem.lineImage = UIImage.init(named: "selectedlong")
        textItem.text = "TEXT"
        textItem.selectedText = "TEXT"
        textItem.textColor = HSUnSelectedTextColor
        textItem.selectedTextColor = HSSelectedTextColor
        textItem.itemWidth = 90
        textItem.itemHeight = 30
        textCell.barItem = textItem
        
        let stickerItem = HSToolBarItem.init()
        stickerItem.lineImage = UIImage.init(named: "selectedlong")
        stickerItem.text = "STICKERS"
        stickerItem.selectedText = "STICKERS"
        stickerItem.textColor = HSUnSelectedTextColor
        stickerItem.selectedTextColor = HSSelectedTextColor
        stickerItem.itemWidth = 90
        stickerItem.itemHeight = 30
        stickersCell.barItem = stickerItem
        cells.append(textCell)
        cells.append(stickersCell)
        
        scrollContentView.contentSize = CGSize.init(width: K_SCREEN_WIDTH * CGFloat(cells.count), height: 0)
        
        textCell.addTarget(self, action: #selector(clickToolBarCell(sender:)), for: .touchUpInside)
        stickersCell.addTarget(self, action: #selector(clickToolBarCell(sender:)), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backToForwardVC), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(endEditWallpaper), for: .touchUpInside)
        
        currentCell = textCell
        
        self.loadToolBarViews()
    }
    
    private func loadToolBarViews() {
        secondEditToolBar.fontBarDelegate = self
        
        self.addSubview(backgroundView)
        backgroundView.addSubview(backBtn)
        backgroundView.addSubview(textCell)
        backgroundView.addSubview(stickersCell)
        backgroundView.addSubview(doneBtn)
        backgroundView.addSubview(scrollContentView)
        scrollContentView.addSubview(secondEditToolBar)
    }
    
    private func layoutToolBarSubview() {
        
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(14)
            make.size.equalTo(backBtn.currentImage!.size)
        }
        
        doneBtn.snp.makeConstraints { make in
            make.centerY.size.equalTo(backBtn)
            make.right.equalTo(-20)
        }
        
        textCell.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn)
            make.centerX.equalToSuperview().offset(-textCell.barItem!.itemWidth * 0.55)
            make.size.equalTo(CGSize.init(width: textCell.barItem!.itemWidth, height: textCell.barItem!.itemHeight))
        }
        
        stickersCell.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(stickersCell.barItem!.itemWidth * 0.55)
            make.centerY.equalTo(backBtn)
            make.size.equalTo(CGSize.init(width: stickersCell.barItem!.itemWidth, height: stickersCell.barItem!.itemHeight))
        }
        
        let y = backBtn.currentImage!.size.height + 22
        scrollContentView.frame = CGRect.init(x: 0, y: y, width: K_SCREEN_WIDTH, height: self.bounds.height - y)
        secondEditToolBar.frame = CGRect.init(x: 0, y: 0, width: K_SCREEN_WIDTH, height: scrollContentView.frame.height)
    }
}

extension HSToolBar {
    // 点击方法
    @objc func clickToolBarCell(sender: HSToolBarCell) {
        guard !sender.isSelected else {
            return
        }
        guard let index = cells.firstIndex(of: sender) else { return }
        let isAllow: Bool = toolBarDeleagte?.toolBarShouldSelectedCell(index: index) ?? true
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
        if stickerView.superview == nil && index == 1 {
            stickerView.frame = CGRect.init(x: K_SCREEN_WIDTH, y: 0, width: K_SCREEN_WIDTH, height: scrollContentView.frame.height)
            scrollContentView.addSubview(stickerView)
        }
        scrollContentView.setContentOffset(CGPoint.init(x: K_SCREEN_WIDTH * CGFloat(index), y: 0), animated: true)
        toolBarDeleagte?.toolBarDidSelectedCell(index: selectedIndex)
    }
    
    @objc private func backToForwardVC() {
        toolBarDeleagte?.toolBarBackClousre()
    }
    
    @objc private func endEditWallpaper() {
        toolBarDeleagte?.toolBarEditWallpaperEnd()
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
        toolBarDeleagte?.toolBarDidSelectedCell(index: selectedIndex)
    }
}

// MARK: TextEditProtocol
extension HSToolBar: TextEditProtocol {
    func addNewTextElement() {
        toolBarDeleagte?.toolBarAddNewTextElement()
    }
    
    func showSystemKeyboard() {
        toolBarDeleagte?.toolBarShowSystemKeyboard()
    }
    
    func changeTextFont(fontName: String) {
        toolBarDeleagte?.toolBarChangeTextFont(fontName: fontName)
    }
    
    func changeTextColor(textColor: UIColor) {
        toolBarDeleagte?.toolBarChangeTextColor(textColor: textColor)
    }
    
    func changeTextShadow(textShadow: NSShadow) {
        toolBarDeleagte?.toolBarChangeTextShadow(textShadow: textShadow)
    }
    
    func changeTextStrokeColor(textColor: String) {
        toolBarDeleagte?.toolBarChangeTextStrokeColor(textColor: textColor)
    }
    
    func changeTextStrokeSize(size: CGFloat) {
        toolBarDeleagte?.toolBarChangeTextStrokeSize(size: size)
    }
    
    func updateToolBarHeight(scrollOffset: CGFloat, isScrollDown: Bool) {
        toolBarDeleagte?.toolBarUpdateHeight(scrollOffset: scrollOffset, isScrollDown: isScrollDown)
    }
}

extension HSToolBar {
    // 二级菜单的编辑选项
    private func getToolBarEditItems() -> [HSToolBarItem] {
        
        let fontItem: HSToolBarItem = HSToolBarItem.init()
        fontItem.itemWidth = 60
        fontItem.itemHeight = 50
        fontItem.image = UIImage.init(named: "button_font")
        fontItem.selectedImage = UIImage.init(named: "button_font_selected")
        fontItem.lineImage = UIImage.init(named: "selected")
        fontItem.lineBottomDistance = 7
        
        let colorItem: HSToolBarItem = HSToolBarItem.init()
        colorItem.itemWidth = 60
        colorItem.itemHeight = 50
        colorItem.image = UIImage.init(named: "button_color")
        colorItem.selectedImage = UIImage.init(named: "button_color_selected")
        colorItem.lineImage = UIImage.init(named: "selected")
        colorItem.lineBottomDistance = 7
        
        let shadowItem: HSToolBarItem = HSToolBarItem.init()
        shadowItem.itemWidth = 60
        shadowItem.itemHeight = 50
        shadowItem.image = UIImage.init(named: "button_style")
        shadowItem.selectedImage = UIImage.init(named: "button_style_selected")
        shadowItem.lineImage = UIImage.init(named: "selected")
        shadowItem.lineBottomDistance = 7
        
        return [fontItem,colorItem,shadowItem]
    }
}
