//
//  HSLocationViewController.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/13.
//

import UIKit

class HSLocationViewController: UIViewController {

    public var textInfoModel: HSVideoTextWatermarkModel?
    
    private let watermarkTextLabel: HSTextLayer = HSTextLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = .cyan
        
        let imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "fullScrren"))
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let point: CGPoint = (textInfoModel?.getTransformOrigin())!
        let size: CGSize = (textInfoModel?.getTransformSize())!
    
        watermarkTextLabel.string = textInfoModel?.transformAttributeString()
        
        watermarkTextLabel.frame = CGRect.init(x: point.x, y: point.y, width: size.width, height: size.height)
        watermarkTextLabel.backgroundColor = UIColor.red.cgColor
        imageView.layer.addSublayer(watermarkTextLabel)
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
