//
//  HSStickerView.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

// MARK: 贴纸View
class HSStickerView: UIView {

    // 定义回调
    typealias DidSelectedStickers = ((UIImage) -> Void)
    public var didSelectedStickers: DidSelectedStickers?
    
    private var stickerSources: [String]?
    private let STICKERCELLIDENTIFIER: String = "HSStickerCollectionViewCell"
    private let STICKER_COUNT: Int = 52
    
    private lazy var stickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let cellSize: CGFloat = (K_SCREEN_WIDTH - 30 - 5 * 3)/4
        layout.itemSize = CGSize(width: cellSize , height: cellSize)
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15)
        
        let collectView = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: layout)
        collectView.showsVerticalScrollIndicator = false
        collectView.backgroundColor = .clear
        return collectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializationStickerData()
        self.loadStickerViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutStickerSubviews()
    }
    
    deinit {
        deallocPrint()
    }
    
    private func initializationStickerData() {
        stickerSources = [String].init()
        for index in 0..<STICKER_COUNT {
            stickerSources?.append("sticker_\(index)")
        }
    }
    
    private func loadStickerViews() {
        stickerCollectionView.delegate = self
        stickerCollectionView.dataSource = self
        stickerCollectionView.register(HSStickerCollectionViewCell.self, forCellWithReuseIdentifier: STICKERCELLIDENTIFIER)
        self.addSubview(stickerCollectionView)
    }

    private func layoutStickerSubviews() {
        stickerCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: CollectionView Delegate
extension HSStickerView : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickerSources!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HSStickerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: STICKERCELLIDENTIFIER, for: indexPath) as! HSStickerCollectionViewCell
        cell.stickerThumbImg = HSBundleResourcePath.bundleResource(resourceName: stickerSources![indexPath.item], resourceType: "png", resourceDirectory: "Stickers")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let img: UIImage = HSBundleResourcePath.bundleResource(resourceName: stickerSources![indexPath.item], resourceType: "png", resourceDirectory: "Stickers")
        self.didSelectedStickers?(img)
    }
}
