//
//  HSJaggedLayerView.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/10.
//

import UIKit

// MARK: 图文绘制背景的锯齿view
class HSJaggedLayerView: HSBaseBackgoundView {

    private let JADDEDHEIGHT: CGFloat = 5.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let topLayer = CAShapeLayer()
        topLayer.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: JADDEDHEIGHT)
        topLayer.path = createJaggedPath(isTop: true).cgPath
        topLayer.backgroundColor = UIColor.clear.cgColor
        topLayer.fillColor = UIColor.white.cgColor
        topLayer.strokeColor = UIColor.clear.cgColor
        topLayer.lineWidth = 1
        topLayer.lineCap = .butt
        self.layer.addSublayer(topLayer)
        
        let bottomLayer = CAShapeLayer()
        bottomLayer.frame = CGRect.init(x: 0, y: self.bounds.height - JADDEDHEIGHT, width: self.bounds.width, height: JADDEDHEIGHT)
        bottomLayer.path = createJaggedPath(isTop: false).cgPath
        bottomLayer.backgroundColor = UIColor.clear.cgColor
        bottomLayer.fillColor = UIColor.white.cgColor
        bottomLayer.strokeColor = UIColor.clear.cgColor
        self.layer.addSublayer(bottomLayer)
        
        self.layer.masksToBounds = true
    }
    
    deinit {
        deallocPrint()
    }

    private func createJaggedPath(isTop: Bool) -> UIBezierPath {
        let width = self.bounds.width
        let height: CGFloat = JADDEDHEIGHT
        let path = UIBezierPath.init()
        path.lineJoinStyle = .bevel
        var pointX: CGFloat = 0.0
        var pointY: CGFloat = isTop ? JADDEDHEIGHT : 0.0
        path.move(to: CGPoint.init(x: pointX, y: pointY))
        while pointX < width {
            pointX += 6
            pointY = pointY >= height ? 0.0 : height
            path.addLine(to: CGPoint.init(x: pointX, y: pointY))
        }
        return path
    }
}
