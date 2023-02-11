//
//  HSTextFontEditView.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/14.
//

import UIKit

// MARK: 文字字体编辑View
class HSFontEditCellView: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            fontLab.backgroundColor = isSelected ? .clear : HSFontStyleUnselectedColor
        }
    }
    
    private lazy var fontLab: HSGradientLayerLabel = {
        let view = HSGradientLayerLabel.init()
        view.text = "ABC"
        view.textColor = HSSelectedTextColor
        view.textAlignment = .center
        view.backgroundColor = HSFontStyleUnselectedColor
        view.createGradient(gradientColors: [HSGradientColor1,HSGradientColor2], gradientStyle: .leftToRight)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFontCellViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fontLab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    deinit {
        deallocPrint()
    }
    
    public func fontName(fontDict: Dictionary<String,CGFloat>) {
        fontLab.font = UIFont.init(name: fontDict.keys.first!, size: fontDict.values.first!)
    }
    
    private func loadFontCellViews() {
        self.contentView.addSubview(fontLab)
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.clipsToBounds = true
    }
}

// MARK: 字体修改View
class HSTextFontEditView: UIView {

    // 滚动回调
    typealias FontDidScrollClousre = ((CGFloat,Bool) -> Void)
    var fontDidScrollClousre: FontDidScrollClousre?
    // 字体选中回调
    typealias FontSelectedClousre = ((String) -> Void)
    var fontSelectedClousre: FontSelectedClousre?
    
    private let FONTCELLIDENTIFIER: String = "HSFontEditCellView"
    
    private var fontCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let cellSize: CGFloat = (K_SCREEN_WIDTH - 30 - 10 * 2)/3
        layout.itemSize = CGSize(width: cellSize , height: cellSize)
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15)
        
        let collectView = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: layout)
        collectView.showsVerticalScrollIndicator = false
        collectView.backgroundColor = .clear
        return collectView
    }()
    
    private var dataSource: [Dictionary] = [Dictionary<String, CGFloat>]()
    // 初始偏移量
    private var scrollOriginalOffset: CGFloat = 0.0
    private var oldScrollOffset: CGFloat = 0.0
    private var newScrollOffset: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializationFontData()
        self.setupFontStyleView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fontCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    private func initializationFontData() {
        let dict: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        let fontArray: NSArray = dict.object(forKey: "UIAppFonts") as! NSArray
        let fontSize: [CGFloat] = [38,24,32,
                                   32,32,44,
                                   39,36,34,
                                   21,39,43,
                                   32,39,32,
                                   42,30]
        for index in 0..<fontArray.count {
            var tempFontName: String = fontArray[index] as! String
            tempFontName = tempFontName.substringToIndex(index: tempFontName.utf16.count - 4)
            let fontSizeNum: CGFloat = fontSize[index]
            dataSource.append([tempFontName:fontSizeNum])
        }
        
        dataSource.insert(["PingFangSC-Regular":40], at: 1)
    }
    
    private func setupFontStyleView() {
        fontCollectionView.delegate = self
        fontCollectionView.dataSource = self
        fontCollectionView.register(HSFontEditCellView.self, forCellWithReuseIdentifier: FONTCELLIDENTIFIER)
        self.addSubview(fontCollectionView)
        fontCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) { [weak self] in
            self?.fontCollectionView.selectItem(at: NSIndexPath.init(item: 0, section: 0) as IndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        }
    }
}

// MARK: Collection Delegate
extension HSTextFontEditView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HSFontEditCellView = collectionView.dequeueReusableCell(withReuseIdentifier: FONTCELLIDENTIFIER, for: indexPath) as! HSFontEditCellView
        cell.fontName(fontDict: dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.fontSelectedClousre?(dataSource[indexPath.item].keys.first!)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollOriginalOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.fontDidScrollClousre?(scrollView.contentOffset.y,false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oldScrollOffset = scrollView.contentOffset.y
    }
}
