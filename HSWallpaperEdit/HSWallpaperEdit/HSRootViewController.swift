//
//  HSRootViewController.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/13.
//

import UIKit

class HSRootViewController: UIViewController {

    lazy var shadow: NSShadow = NSShadow.init()
    var textLabel: UILabel?
    var previewLayer: HSLockPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
//        let dict: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
//        let fontArray: NSArray = dict.object(forKey: "UIAppFonts") as! NSArray
//        print(fontArray)
//        for fontName in fontArray {
//            var tempFontName: String = fontName as! String
//            tempFontName = tempFontName.substringToIndex(index: tempFontName.utf16.count - 4)
//            print(tempFontName)
//        }
        
//        let gradientLab: HSGradientLabel = HSGradientLabel.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
//        gradientLab.text = "吃了"
//        gradientLab.textAlignment = .center
//        gradientLab.setGradientColorAndType(gradientColor: [.purple,.blue], type: .leftTopToRightBottom)
//        self.view.addSubview(gradientLab)
//
//        let label: HSGradientLayerLabel = HSGradientLayerLabel.init(frame: CGRect.init(x: 100, y: 250, width: 100, height: 100))
//        label.text = "吃了"
//        label.textAlignment = .center
//        label.textColor = .white
//        label.createGradient(gradientColors: [.purple,.blue], gradientStyle: .leftTopToRightBottom)
//        self.view.addSubview(label)
        
//        let img: UIImage = HSBundleResourcePath.bundleResource(resourceName: "bgClearAll", resourceType: "png", resourceDirectory: "AlertBG")
//        print(img)
        
        let btn: UIButton = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = .orange
        btn.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)
        
//        let label: UILabel = UILabel.init(frame: CGRect.init(x: 100, y: 300, width: 100, height: 100))
//        shadow.shadowColor = UIColor.purple
//        shadow.shadowOffset = CGSize.init(width: 5, height: 5)
//        let att: NSAttributedString = NSAttributedString.init(string: "我很好", attributes: [.shadow:shadow])
//        label.attributedText = att
//        self.view.addSubview(label)
//        textLabel = label
        
        /*
         AngelinaFreeForPersonalUs
         Apane
         aAttackGraffiti
         BlurredLines
         MoveIt
         QabilFreeTrial
         */
        
//        let layer: HSTextLayer = HSTextLayer.init()
//        layer.frame = CGRect.init(x: 50, y: 100, width: 300, height: 100)
//        layer.backgroundColor = UIColor.init(white: 0, alpha: 0.7).cgColor
//        layer.isWrapped = true
//        layer.alignmentMode = .center
//        let font:UIFont = UIFont.init(name: "QabilFreeTrial", size: 50)!
//        font.fontDescriptor.addingAttributes([.matrix:CGAffineTransform.init(scaleX: 1.2, y: 1.2)])
//        let attStr: NSMutableAttributedString = NSMutableAttributedString.init(string: "how are you", attributes: [.font:font,.foregroundColor:UIColor.red.cgColor,.strokeColor:UIColor.green.cgColor,.strokeWidth:2])
//        layer.string = attStr
//        self.view.layer.addSublayer(layer)
        
//        let superView: UIView = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 200))
//        superView.backgroundColor = .red
//        self.view.addSubview(superView)
//        let subView: UIView = UIView.init(frame: CGRect.init(x: 20, y: 20, width: 80, height: 80))
//        subView.backgroundColor = .orange
//        superView.addSubview(subView)
//
//        let point: CGPoint = subView.convert(subView.center, to: superView.superview)
//        let size: CGRect = subView.convert(subView.bounds, to: subView.superview)
//        let view: UIView = UIView.init(frame: CGRect.init(x: 100, y: 350, width: 100, height: 200))
////        view.bounds = size
////        view.center = point
//        view.backgroundColor = .yellow
//        self.view.addSubview(view)
//        let rect: CGRect =  view.frame.offsetBy(dx: 0, dy: 50)
//        print("frame = \(rect)")
        
//        self.view.backgroundColor = .red
//        let layer = HSLockPreviewLayer.init()
//        layer.frame = self.view.frame
//        self.view.layer.addSublayer(layer)
//        previewLayer = layer
        
//        let familyNames = UIFont.familyNames
//
//        var index:Int = 0
//
//        for familyName in familyNames {
//
//            let fontNames = UIFont.fontNames(forFamilyName: familyName as String)
//            for fontName in fontNames
//            {
//                index += 1
//
//                print("第 \(index) 个字体，字体font名称：\(fontName)")
//            }
//        }
        
        let label: HSLabel = HSLabel.init(frame: CGRect.init(x: 50, y: 100, width: 200, height: 100))
        let att: NSAttributedString = NSAttributedString.init(string: "how are you", attributes: [.font:UIFont.systemFont(ofSize: 30),.foregroundColor:UIColor.orange.cgColor,.strokeWidth:1.5,.strokeColor:UIColor.blue.cgColor])
        label.attributedText = att
        self.view.addSubview(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let editVC: HSImageTextEditViewController = HSImageTextEditViewController.init()
//        editVC.wallpapaerVideoPath = Bundle.main.path(forResource: "IMG_5763", ofType: "mp4")
//        editVC.wallpapaerCoverUrl = Bundle.main.path(forResource: "IMG_0007", ofType: "PNG")
        editVC.wallpapaerVideoPath = Bundle.main.path(forResource: "123", ofType: "MOV")
        editVC.wallpapaerCoverUrl = Bundle.main.path(forResource: "2592", ofType: "JPEG")
        self.navigationController?.pushViewController(editVC, animated: true)
//        previewLayer?.removeFromSuperlayer()
//        previewLayer = nil
    }
    
    @objc func click(sender: UIButton) {
        
        let editVC: HSImageTextEditViewController = HSImageTextEditViewController.init()
        editVC.wallpapaerVideoPath = Bundle.main.path(forResource: "IMG_5762", ofType: "mp4")
        editVC.wallpapaerCoverUrl = Bundle.main.path(forResource: "IMG_0007", ofType: "PNG")
//        editVC.wallpapaerVideoPath = Bundle.main.path(forResource: "123", ofType: "MOV")
//        editVC.wallpapaerCoverUrl = Bundle.main.path(forResource: "2592", ofType: "JPEG")
        self.navigationController?.pushViewController(editVC, animated: true)
        
//        let att: NSMutableAttributedString = NSMutableAttributedString.init(attributedString: (textLabel?.attributedText!)!)
////        let shadow: NSShadow = NSShadow.init()
//        shadow.shadowColor = UIColor.red
//        shadow.shadowOffset = CGSize.init(width: 3.0, height: 3.0)
//        att.addAttribute(.shadow, value: shadow, range: NSRange.init(location: 0, length: att.length))
//        textLabel?.attributedText = att
//        textLabel?.layer.displayIfNeeded()
//        return
//        let topModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
//        topModel.title = "top"
//        topModel.image = "menu_top"
//        topModel.disImage = "menu_top_disable"
//
//        let bottomModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
//        bottomModel.title = "bottom"
//        bottomModel.image = "menu_bottom"
//        bottomModel.disImage = "menu_bottom_disable"
//
//        let copyModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
//        copyModel.title = "copy"
//        copyModel.image = "menu_copy"
//
//        let editModel: HSPopOverMenuModel = HSPopOverMenuModel.init()
//        editModel.title = "edit"
//        editModel.image = "menu_edit"
//
//        let models: [HSPopOverMenuModel] = [topModel,bottomModel,copyModel,editModel]
//        let config: HSConfiguration = HSConfiguration.init()
//        config.backgoundTintColor = UIColor.init(hexString: "#111111")
//        config.menuRowHeight = 50
//        config.menuWidth = config.menuItemWidth * CGFloat(models.count)
//        config.textFont = UIFont.systemFont(ofSize: 11, weight: .regular)
//
//        HSPopOverMenu.showForSender(sender: sender, with: models, popOverPosition: .automatic, config: config) { (selectedCell: HSMenuItem) in
//
//        } cancel: {
//
//        }
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

class HSLabel: UILabel {
    override func draw(_ rect: CGRect) {
        let shaowOffset = self.shadowOffset
        
        let c = UIGraphicsGetCurrentContext()
        c!.setLineWidth(1)
        c!.setLineJoin(.round)
        c!.setTextDrawingMode(.stroke)
        self.textColor = .red
        super.drawText(in: rect)
        
        c!.setTextDrawingMode(.fill)
        self.shadowOffset = CGSize.init(width: 0, height: 0)
        super.drawText(in: rect)
        self.shadowOffset = shaowOffset
    }
}
