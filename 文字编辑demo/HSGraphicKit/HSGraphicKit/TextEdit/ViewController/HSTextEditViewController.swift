//
//  HSTextEditViewController.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/12.
//

import UIKit

class HSTextEditViewController: UIViewController {

    private lazy var kernSlider: UISlider =  {
        let view = UISlider()
        view.minimumTrackTintColor = .red
        view.setThumbImage(UIImage.ge_creataImage(string: "0"), for: .normal)
        view.minimumValue = -50
        view.maximumValue = 50
        view.value = 0
        return view
    }()
    
    private lazy var textView: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 200, width: self.view.bounds.width, height: 300))
        label.textAlignment = .center
        label.text = "开始添加文字"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.backgroundColor = .orange
        
        self.view.addSubview(textView)
        
        kernSlider.addTarget(self, action: #selector(brightnessSliderChanged(_:)), for: .valueChanged)
        self.view.addSubview(kernSlider)
        kernSlider.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-self.safeWindowAreaInsetsBottom() - 20)
            make.height.equalTo(25)
        }
    }
    
    @objc func brightnessSliderChanged(_ sender: UISlider) {
        let value = sender.value
        print(value)
        sender.setThumbImage(UIImage.ge_creataImage(string: String(format: "%d", Int(value))), for: .normal)
//        self.testTextKern(kernNum: CGFloat(sender.value))
//        self.testTextStrokeWidth(strokeWidth: CGFloat(sender.value))
        
    }
    
    private func testTextKern(kernNum: CGFloat) {
        textView.attributedText = HSTextService.setAttributeString(textView.attributedText!, kernNum: kernNum, range: NSRange.init(location: 0, length: (textView.text?.utf16.count)!))
    }
    
    private func testTextStrokeWidth(strokeWidth: CGFloat) {
        textView.attributedText = HSTextService.setAttributedString(textView.attributedText!, strokeWidth: strokeWidth, range: NSRange.init(location: 0, length: (textView.text?.utf16.count)!))
    }
    
    private func testTextStrokeColor(strokeColor: UIColor) {
        textView.attributedText = HSTextService.setAttributedString(textView.attributedText!, strokeColor: strokeColor, range: NSRange.init(location: 0, length: (textView.text?.utf16.count)!))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
