//
//  HSTextColorEditView.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/14.
//

import UIKit

// MARK: 文字颜色编辑View
class HSTextColorEditView: UIView {

    // 定义颜色回调
    typealias TextColorClousre = ((UIColor) -> Void)
    var textColorClousre: TextColorClousre?
    
    private lazy var colorTitle: UILabel = {
        let view = UILabel.init()
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        view.textColor = HSSelectedTextColor
        view.text = "Color"
        return view
    }()
    
    private lazy var colorContentView: HSColorEditScrollView = {
        let view = HSColorEditScrollView.init()
        view.colorSelectedClosure = {[weak self] (selectedCell: HSTextColorElementView) in
            self?.textColorClousre?(UIColor.init(hexString: selectedCell.backgroundColorStr ?? ""))
        }
        return view
    }()
    
    private lazy var opacityTitle: UILabel = {
        let view = UILabel.init()
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        view.textColor = HSSelectedTextColor
        view.text = "Opacity"
        return view
    }()
    
    private lazy var opacitySlider: HSTextColorOpacitySlider = {
        return HSTextColorOpacitySlider.init(frame: .zero)
    }()
    
    private var colorSources: [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializationColorData()
        self.setupTextColorEditViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorTitle.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.size.equalTo(CGSize.init(width: 60, height: 18))
        }
        
        colorContentView.snp.makeConstraints { make in
            make.left.equalTo(colorTitle)
            make.top.equalTo(colorTitle.snp.bottom).offset(8)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        
        opacityTitle.snp.makeConstraints { make in
            make.left.equalTo(colorTitle)
            make.top.equalTo(colorContentView.snp.bottom).offset(19)
            make.size.equalTo(CGSize.init(width: 70, height: 18))
        }
        
        opacitySlider.snp.makeConstraints { make in
            make.left.equalTo(colorTitle)
            make.right.equalTo(colorContentView)
            make.top.equalTo(opacityTitle.snp.bottom).offset(10)
            make.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    private func initializationColorData() {
        let path: String = Bundle.main.path(forResource: "HSColorConfig", ofType: "plist")!
        let colorDict: NSDictionary = NSDictionary(contentsOfFile: path)!
        colorSources = colorDict.object(forKey: "FontColor") as? [String]
    }

    private func setupTextColorEditViews() {
        opacitySlider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        colorContentView.setupColors(colors: colorSources!)
        self.addSubview(colorTitle)
        self.addSubview(colorContentView)
        self.addSubview(opacityTitle)
        self.addSubview(opacitySlider)
    }
}

// MARK: Target
extension HSTextColorEditView {
    // 选择文本颜色的透明度
    @objc private func sliderValueChanged(sender: HSTextColorOpacitySlider) {
        self.textColorClousre?(UIColor.init(hexString: self.colorContentView.currentSelectedCell.backgroundColorStr ?? "",alpha: CGFloat(sender.value)))
    }
}
