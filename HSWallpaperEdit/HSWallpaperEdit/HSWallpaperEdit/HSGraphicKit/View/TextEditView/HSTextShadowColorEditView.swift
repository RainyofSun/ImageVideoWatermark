//
//  HSTextShadowColorEditView.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//  富文本https://www.jianshu.com/p/a143ab7e7d5b

import UIKit

protocol ShadowColorWidgetProtocol: NSObjectProtocol {
    // 点击 +
    func sizeAdd(widget: HSSizeEditWidget)
    // 点击 -
    func sizeSub(widget: HSSizeEditWidget)
}

class HSSizeEditWidget: UIView {
    
    public weak var widgetDelegate: ShadowColorWidgetProtocol?
    public var titleStr: String? {
        didSet {
            titleLab.text = titleStr
        }
    }
    public var size: CGFloat = 0.0 {
        didSet {
            if abs(size) == 0.0 {
                self.subBtn.isEnabled = false
                self.addBtn.isEnabled = true
            } else if abs(size) == 10 {
                self.subBtn.isEnabled = true
                self.addBtn.isEnabled = false
            } else {
                self.subBtn.isEnabled = true
                self.addBtn.isEnabled = true
            }
        }
    }
    
    private lazy var titleLab: UILabel = {
        let view = UILabel.init()
        view.textColor = HSSelectedTextColor
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private lazy var addBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "size_add"), for: .normal)
        view.setImage(UIImage.init(named: "size_add"), for: .highlighted)
        view.setImage(UIImage.init(named: "size_add_disable"), for: .disabled)
        return view
    }()
    
    private lazy var subBtn: UIButton = {
        let view = UIButton.init(type: UIButton.ButtonType.custom)
        view.setImage(UIImage.init(named: "size_sub"), for: .normal)
        view.setImage(UIImage.init(named: "size_sub"), for: .highlighted)
        view.setImage(UIImage.init(named: "size_sub_disable"), for: .disabled)
        view.isEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadShaodWidgets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLab.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 72, height: 17))
        }
        
        addBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(7)
            make.size.equalTo(addBtn.currentImage!.size)
        }
        
        subBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.size.equalTo(addBtn)
        }
    }
    
    deinit {
        deallocPrint()
    }
    
    private func loadShaodWidgets() {
        
        addBtn.addTarget(self, action: #selector(clickAddBtn(sender:)), for: .touchUpInside)
        subBtn.addTarget(self, action: #selector(clickSubBtn(sender:)), for: .touchUpInside)
        
        self.addSubview(titleLab)
        self.addSubview(addBtn)
        self.addSubview(subBtn)
    }
}

extension HSSizeEditWidget {
    // 点击方法
    @objc func clickAddBtn(sender: UIButton) {
        self.widgetDelegate?.sizeAdd(widget: self)
    }
    
    @objc func clickSubBtn(sender: UIButton) {
        self.widgetDelegate?.sizeSub(widget: self)
    }
}

// MARK: 文字阴影颜色、描边颜色、size 编辑View
class HSTextShadowColorEditView: UIView {

    // 定义颜色回调
    typealias TextShadowClousre = ((NSShadow) -> Void)
    var textShadowClousre: TextShadowClousre?
    typealias TextStrokeColorClousre = ((String) -> Void)
    var textStrokeColorClousre: TextStrokeColorClousre?
    // 定义size回调
    typealias StrokeSizeClousre = ((CGFloat) -> Void)
    var strokeSizeClousre: StrokeSizeClousre?
    
    private var shadowColors: [String]?
    private var strokeColors: [String]?
    
    private lazy var shadowSizeWidget: HSSizeEditWidget = {
        let view = HSSizeEditWidget.init(frame: CGRect.zero)
        view.titleStr = "Shadow Size"
        return view
    }()
    
    private lazy var strokeSizeWidget: HSSizeEditWidget = {
        let view = HSSizeEditWidget.init(frame: CGRect.zero)
        view.titleStr = "Stroke Size"
        return view
    }()
    
    private lazy var shadowColorLab: UILabel = {
        let view = UILabel.init()
        view.textColor = HSSelectedTextColor
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.text = "Shadow Color"
        return view
    }()
    
    private lazy var shadowColorView: HSColorEditScrollView = {
        let view = HSColorEditScrollView.init(frame: CGRect.zero)
        view.colorSelectedClosure = {[weak self] (selectedCell: HSTextColorElementView) in
            self?.textShadow.shadowColor = UIColor.init(hexString: selectedCell.backgroundColorStr ?? "")
            self?.textShadowClousre?(self!.textShadow)
        }
        return view
    }()
    
    private lazy var strokeColorView: HSColorEditScrollView = {
        let view = HSColorEditScrollView.init(frame: CGRect.zero)
        view.colorSelectedClosure = {[weak self] (selectedCell: HSTextColorElementView) in
            self?.textStrokeColorClousre?(selectedCell.backgroundColorStr ?? "")
        }
        return view
    }()
    
    private lazy var strokeColorLab: UILabel = {
        let view = UILabel.init()
        view.textColor = HSSelectedTextColor
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.text = "Stroke Color"
        return view
    }()
    
    private var shadowSize: CGFloat = 0.0
    private var strokeSize: CGFloat = 0.0
    private lazy var textShadow: NSShadow = NSShadow.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializationColorData()
        self.setupShadowColorViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutShadowColorSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        strokeSizeWidget.widgetDelegate = nil
        shadowSizeWidget.widgetDelegate = nil
        deallocPrint()
    }

    private func initializationColorData() {
        let path: String = Bundle.main.path(forResource: "HSColorConfig", ofType: "plist")!
        let colorDict: NSDictionary = NSDictionary(contentsOfFile: path)!
        shadowColors = colorDict.object(forKey: "ShadowColor") as? [String]
        strokeColors = colorDict.object(forKey: "SrokeColor") as? [String]
    }
    
    private func setupShadowColorViews() {
        shadowSizeWidget.widgetDelegate = self
        strokeSizeWidget.widgetDelegate = self
        
        shadowColorView.setupColors(colors: shadowColors!)
        strokeColorView.setupColors(colors: strokeColors!)
        
        self.addSubview(shadowSizeWidget)
        self.addSubview(strokeSizeWidget)
        self.addSubview(shadowColorLab)
        self.addSubview(shadowColorView)
        self.addSubview(strokeColorLab)
        self.addSubview(strokeColorView)
    }
    
    private func layoutShadowColorSubviews() {
        shadowSizeWidget.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.size.equalTo(CGSize.init(width: 76, height: 52))
        }
        
        strokeSizeWidget.snp.makeConstraints { make in
            make.left.size.equalTo(shadowSizeWidget)
            make.top.equalTo(shadowSizeWidget.snp.bottom).offset(20)
        }
        
        shadowColorLab.snp.makeConstraints { make in
            make.top.equalTo(shadowSizeWidget)
            make.left.equalTo(shadowSizeWidget.snp.right).offset(34)
            make.size.equalTo(CGSize.init(width: 80, height: 17))
        }
        
        shadowColorView.snp.makeConstraints { make in
            make.left.equalTo(shadowColorLab)
            make.top.equalTo(shadowColorLab.snp.bottom).offset(7)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        
        strokeColorLab.snp.makeConstraints { make in
            make.left.size.equalTo(shadowColorLab)
            make.top.equalTo(shadowColorView.snp.bottom).offset(20)
        }
        
        strokeColorView.snp.makeConstraints { make in
            make.left.size.height.equalTo(shadowColorView)
            make.top.equalTo(strokeColorLab.snp.bottom).offset(7)
        }
    }
}

// MARK: 协议
extension HSTextShadowColorEditView: ShadowColorWidgetProtocol {
    
    func sizeAdd(widget: HSSizeEditWidget) {
        if widget == self.shadowSizeWidget {
            shadowSize += 1.0
            widget.size = shadowSize
            textShadow.shadowOffset = CGSize.init(width: shadowSize, height: shadowSize)
            self.textShadowClousre?(textShadow)
        }
        /*
         NSStrokeWidthAttributeName这个属性所对应的值是一个 NSNumber 对象(小数)。该值改变描边宽度（相对于字体size 的百分比）。默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。
         同时设置了空心的两个属性，并且NSStrokeWidthAttributeName属性设置为整数，文字前景色(NSForegroundColorAttributeName)就无效果了,
         如果数值设置为负数,就没有空心字的效果
         */
        if widget == self.strokeSizeWidget {
            strokeSize -= 1.0
            widget.size = strokeSize
            self.strokeSizeClousre?(strokeSize)
        }
    }
    
    func sizeSub(widget: HSSizeEditWidget) {
        if widget == self.shadowSizeWidget {
            shadowSize -= 1.0
            widget.size = shadowSize
            textShadow.shadowOffset = CGSize.init(width: shadowSize, height: shadowSize)
            self.textShadowClousre?(textShadow)
        }
        if widget == self.strokeSizeWidget {
            strokeSize += 1.0
            widget.size = strokeSize
            self.strokeSizeClousre?(strokeSize)
        }
    }
}
