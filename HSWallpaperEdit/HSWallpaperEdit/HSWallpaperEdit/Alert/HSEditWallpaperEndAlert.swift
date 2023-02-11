//
//  HSEditWallpaperEndAlert.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/14.
//

import UIKit

class HSEditWallpaperEndAlert: UIView {

    // 定义弹窗回调
    typealias AlertClosure = (() -> Void)
    public var alertClosure: AlertClosure?
    
    open var alertTitle: String? {
        didSet {
            titleLab.text = alertTitle
        }
    }
    
    open var alertContent: String? {
        didSet {
            subTitleLab.text = alertContent
        }
    }
    
    private lazy var bgView: UIView = {
        let bgView = UIView.init()
        let bgImg: UIImage = HSBundleResourcePath.bundleResource(resourceName: "bgClearAll", resourceType: "png", resourceDirectory: "AlertBG")
        bgView.layer.contents = bgImg.cgImage
        return bgView
    }()
    
    private lazy var titleLab: UILabel = {
        let view = UILabel.init()
        view.textColor = HSSelectedTextColor
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var subTitleLab: UILabel = {
        let view = UILabel.init()
        view.numberOfLines = 0
        view.textColor = HSSecondaryTitleColor
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var sureBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.backgroundColor = HSAlertSureBtnColor
        view.setTitle("YES", for: .normal)
        view.setTitle("YES", for: .highlighted)
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.tag = 100
        return view
    }()
    
    private lazy var cancelBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.backgroundColor = HSAlertCancelBtnColor
        view.setTitle("Cancel", for: .normal)
        view.setTitle("Cancel", for: .highlighted)
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.tag = 200
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadAlertView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutAlertSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func show(contentView: UIView) {
        contentView.addSubview(self)
        UIView.animate(withDuration: 0.2) {
            self.bgView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            self.bgView.transform = CGAffineTransform.identity
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    private func loadAlertView() {
        self.backgroundColor = HSAlertBGColor
        
        self.sureBtn.addTarget(self, action: #selector(clickAlertBtn(sender:)), for: .touchUpInside)
        self.cancelBtn.addTarget(self, action: #selector(clickAlertBtn(sender:)), for: .touchUpInside)
        
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.subTitleLab)
        self.bgView.addSubview(self.sureBtn)
        self.bgView.addSubview(self.cancelBtn)
    }
    
    private func layoutAlertSubviews() {
        let width: CGFloat = K_SCREEN_WIDTH * 0.8
        let height: CGFloat = K_SCREEN_WIDTH * 0.8 * 0.836
        self.bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: width, height: height))
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(width * 0.33)
            make.height.equalTo(20)
        }
        
        self.subTitleLab.snp.makeConstraints { make in
            make.width.centerX.equalTo(self.titleLab)
            make.height.equalTo(40)
            make.top.equalTo(self.titleLab.snp_bottomMargin).offset(width * 0.03)
        }
        
        self.sureBtn.snp.makeConstraints { make in
            make.top.equalTo(self.subTitleLab.snp_bottomMargin).offset(width * 0.07)
            make.size.equalTo(CGSize.init(width: width * 0.43, height: width * 0.144))
            make.centerX.equalToSuperview().offset(-width * 0.23)
        }
        
        self.cancelBtn.snp.makeConstraints { make in
            make.centerY.size.equalTo(self.sureBtn)
            make.centerX.equalToSuperview().offset(width * 0.23)
        }
    }
}

// MARK: Target
extension HSEditWallpaperEndAlert {
    @objc private func clickAlertBtn(sender: UIButton) {
        if sender.tag == 200 {
            self.hide()
            return
        }
        self.alertClosure?()
    }
}
