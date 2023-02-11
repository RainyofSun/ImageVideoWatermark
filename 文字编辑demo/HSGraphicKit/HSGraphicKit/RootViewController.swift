//
//  RootViewController.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//
// TODO: 讨论是否将元素的选中和开始编辑状态 分开触发，单击选中元素，双击开始元素的编辑状态。同时触发选中、编辑两种状态会有键盘、界面元素的第一响应者冲突
// TODO: BUG1: 图片旋转之后，再进行裁剪的时候，图片返回时控件约束有问题，解决：更新图片的时候，取消之前的旋转角度
import UIKit

class RootViewController: UIViewController {
    
    private let contentLab: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = .red
        label.text = "click input text"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    var textInfoModel: HSVideoTextWatermarkModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .cyan
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("点击添加文本框", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(addTextBox), for: .touchUpInside)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.frame = CGRect.init(x: 20, y: 100, width: 0, height: 0)
        btn.sizeToFit()
        self.view.addSubview(btn)
        
        let imageBtn = UIButton.init(type: .custom)
        imageBtn.setTitle("点击添加图片", for: .normal)
        imageBtn.setTitleColor(.white, for: .normal)
        imageBtn.addTarget(self, action: #selector(addImageBox), for: .touchUpInside)
        imageBtn.backgroundColor = .orange
        imageBtn.layer.cornerRadius = 8
        imageBtn.clipsToBounds = true
        imageBtn.frame = CGRect.init(x: 40 + btn.frame.width, y: 100, width: 0, height: 0)
        imageBtn.sizeToFit()
        self.view.addSubview(imageBtn)
        
        let editBtn = UIButton.init(type: .custom)
        editBtn.setTitle("开始编辑", for: .normal)
        editBtn.setTitleColor(.white, for: .normal)
        editBtn.addTarget(self, action: #selector(startEdit), for: .touchUpInside)
        editBtn.backgroundColor = .orange
        editBtn.layer.cornerRadius = 8
        editBtn.clipsToBounds = true
        editBtn.frame = CGRect.init(x: 60 + imageBtn.frame.width + btn.frame.width, y: 100, width: 0, height: 0)
        editBtn.sizeToFit()
        self.view.addSubview(editBtn)
        
        let videoEditBtn = UIButton.init(type: .custom)
        videoEditBtn.setTitle("开始视频水印编辑", for: .normal)
        videoEditBtn.setTitleColor(.white, for: .normal)
        videoEditBtn.addTarget(self, action: #selector(startEditVideo), for: .touchUpInside)
        videoEditBtn.backgroundColor = .orange
        videoEditBtn.layer.cornerRadius = 8
        videoEditBtn.clipsToBounds = true
        videoEditBtn.frame = CGRect.init(x: 20, y: btn.frame.height + btn.frame.origin.y + 20, width: 0, height: 0)
        videoEditBtn.sizeToFit()
        self.view.addSubview(videoEditBtn)
        
        let videoLocalBtn = UIButton.init(type: .custom)
        videoLocalBtn.setTitle("开始视频水印编辑", for: .normal)
        videoLocalBtn.setTitleColor(.white, for: .normal)
        videoLocalBtn.addTarget(self, action: #selector(startEditLocalVideo), for: .touchUpInside)
        videoLocalBtn.backgroundColor = .orange
        videoLocalBtn.layer.cornerRadius = 8
        videoLocalBtn.clipsToBounds = true
        videoLocalBtn.frame = CGRect.init(x: 40 + videoEditBtn.frame.width, y: videoEditBtn.frame.origin.y, width: 0, height: 0)
        videoLocalBtn.sizeToFit()
        self.view.addSubview(videoLocalBtn)
        
        let imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "fullScrren"))
        self.view.addSubview(imageView)
        let scale: CGFloat = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        let h = UIScreen.main.bounds.height * 0.6
        let w = h * scale
        print("canvas w = \(w) h = \(h)")
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-self.safeWindowAreaInsetsBottom() - 20)
            make.size.equalTo(CGSize.init(width: w, height: h))
        }
        
        contentLab.frame = CGRect.init(x: w * 0.5 - 75, y: 20, width: 150, height: 100)
        contentLab.attributedText = HSTextService.setAttributedString(contentLab.attributedText!, strokeWidth: 2, range: NSRange.init(location: 0, length: (contentLab.text?.utf16.count)!))
        textInfoModel = HSVideoTextWatermarkModel.init()
        textInfoModel?.attributedString = contentLab.attributedText
        textInfoModel?.originalPoint = contentLab.frame.origin
        textInfoModel?.originalSize = contentLab.frame.size
        textInfoModel?.attributeFontSize = contentLab.font.pointSize
        imageView.addSubview(contentLab)
    }
    
    @objc func addTextBox() {
        self.navigationController?.pushViewController(HSTextEditViewController.init(), animated: true)
    }
    
    @objc func addImageBox() {
        self.navigationController?.pushViewController(HSImageFilterViewController.init(), animated: true)
    }
    
    @objc func startEdit() {
        self.navigationController?.pushViewController(HSImageTextEditViewController.init(), animated: true)
    }
    
    @objc func startEditVideo() {
        self.navigationController?.pushViewController(HSVideoEditViewController.init(), animated: true)
    }
    
    @objc func startEditLocalVideo() {
        let localVC: HSLocationViewController = HSLocationViewController.init()
        localVC.textInfoModel = textInfoModel
        self.navigationController?.pushViewController(localVC, animated: true)
    }
}
