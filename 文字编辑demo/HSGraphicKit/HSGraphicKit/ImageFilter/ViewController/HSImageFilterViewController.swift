//
//  HSImageFilterViewController.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/12.
//

import UIKit

class HSImageFilterViewController: UIViewController {

    var pictureImgView: UIImageView = {
        let view = UIImageView.init(image: UIImage.init(named: "fengjing"))
        return view
    }()
    
    private lazy var brightnessSlider: UISlider =  {
        let view = UISlider()
        view.minimumTrackTintColor = .red
        view.setThumbImage(UIImage.init(named: "0"), for: .normal)
        view.minimumValue = -50
        view.maximumValue = 50
        view.value = 0
        return view
    }()
    
    var brightness: Float = 0.0 {
        didSet {
            brightnessSlider.value = brightness
            brightnessSlider.setThumbImage(UIImage.ge_creataImage(string: String(format: "%d", Int(brightness))), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        // Do any additional setup after loading the view.
        brightnessSlider.addTarget(self, action: #selector(brightnessSliderChanged(_:)), for: .valueChanged)
        self.view.addSubview(brightnessSlider)
        self.view.addSubview(pictureImgView)
        pictureImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 300, height: 200))
        }
        brightnessSlider.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-self.safeWindowAreaInsetsBottom() - 20)
            make.height.equalTo(25)
        }
    }
    
    @objc func brightnessSliderChanged(_ sender: UISlider) {
        let value = sender.value
        brightnessSlider.setThumbImage(UIImage.ge_creataImage(string: String(format: "%d", Int(value))), for: .normal)
        pictureImgView.image = HSImageService.setImage(pictureImgView.image, brightness: CGFloat(brightnessRealValue(value: value)))
    }

    // -50~50 * 0.02 => -1~1
    private func brightnessRealValue(value: Float) -> Float{
        let result = 0.02 * value
        return result
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
