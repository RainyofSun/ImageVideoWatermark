//
//  HSEditTagView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

import UIKit
import SnapKit

// MARK: 四角的操作Tag
class HSEditTagView: UIView {

    private lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    public var imgName: String? {
        didSet {
            iconImgView.image = UIImage.init(named: imgName ?? "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autoresizesSubviews = false
        self.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}
