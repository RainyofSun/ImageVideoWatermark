//
//  HSPopOverMenu.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

extension HSPopOverMenu {
    
    public class func showForSender(sender: UIView, with menuArray: [HSMenuObject], menuImageArray: [Imageable]? = nil, popOverPosition: HSPopOverPosition = .automatic, config: HSConfiguration? = nil, done: ((HSMenuItem)->())?, cancel: (()->())? = nil) {
        HSPopOverMenu.shared.showForSender(sender: sender, or: nil, with: menuArray, menuImageArray: menuImageArray, popOverPosition: popOverPosition, config: config, done: done, cancel: cancel)
    }

    public class func showForEvent(event: UIEvent, with menuArray: [HSMenuObject], menuImageArray: [Imageable]? = nil, popOverPosition: HSPopOverPosition = .automatic, config: HSConfiguration? = nil, done: ((HSMenuItem)->())?, cancel: (()->())? = nil) {
        HSPopOverMenu.shared.showForSender(sender: event.allTouches?.first?.view!, or: nil, with: menuArray, menuImageArray: menuImageArray, popOverPosition: popOverPosition, config: config, done: done, cancel: cancel)
    }

    public class func showFromSenderFrame(senderFrame: CGRect, with menuArray: [HSMenuObject], menuImageArray: [Imageable]? = nil,popOverPosition: HSPopOverPosition = .automatic, config: HSConfiguration? = nil, done: ((HSMenuItem)->())?, cancel: (()->())? = nil) {
        HSPopOverMenu.shared.showForSender(sender: nil, or: senderFrame, with: menuArray, menuImageArray: menuImageArray, popOverPosition: popOverPosition, config: config, done: done, cancel: cancel)
    }
}

fileprivate enum HSPopOverMenuArrowDirection {
    case up
    case down
}

public enum HSPopOverPosition {
    case automatic
    case alwaysAboveSender
    case alwaysUnderSender
}

public class HSPopOverMenu: NSObject, HSPopOverMenuViewDelegate {
    
    var sender: UIView?
    var senderFrame: CGRect?
    var menuNameArray: [HSMenuObject]!
    var menuImageArray: [Imageable]!
    var done: ((HSMenuItem)->())?
    var cancel: (()->())?
    var configuration = HSConfiguration()
    var popOverPosition: HSPopOverPosition = .automatic
    
    fileprivate lazy var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        if let adapter = self.configuration.globalShadowAdapter {
            adapter(view)
        } else {
            if self.configuration.globalShadow {
                view.backgroundColor = UIColor.black.withAlphaComponent(self.configuration.shadowAlpha)
            }
        }
        view.addGestureRecognizer(self.tapGesture)
        return view
    }()
    
    fileprivate lazy var popOverMenuView: HSPopOverMenuView = {
        let menu = HSWallpaperEdit.HSPopOverMenuView(frame: CGRect.zero)
        menu.alpha = 0
        self.backgroundView.addSubview(menu)
        return menu
    }()
    
    fileprivate var isOnScreen: Bool = false {
        didSet {
            if isOnScreen {
                self.addOrientationChangeNotification()
            } else {
                self.removeOrientationChangeNotification()
            }
        }
    }
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroudViewTapped(gesture:)))
        return gesture
    }()
    
    class var shared: HSPopOverMenu {
        struct Manager {
            static let instance = HSPopOverMenu()
        }
        return Manager.instance
    }
    
    public func changeMenuItemState(itemIndex: Int, isEnabled: Bool) {
        if itemIndex >= popOverMenuView.menuNameArray.count {
            return
        }
        let menuItemView: UIView = popOverMenuView.menuView.subviews[itemIndex]
        if let menuItem: HSMenuItem = menuItemView as? HSMenuItem {
            menuItem.isEnabled = isEnabled
        }
    }
    
    public func showForSender(sender: UIView?, or senderFrame: CGRect?, with menuNameArray: [HSMenuObject]!, menuImageArray: [Imageable]? = nil, popOverPosition: HSPopOverPosition = .automatic, config: HSConfiguration? = nil, done: ((HSMenuItem)->())?, cancel: (()->())? = nil) {
        if sender == nil && senderFrame == nil {
            return
        }
        
        if menuNameArray.count == 0 {
            return
        }
        
        self.sender = sender
        self.senderFrame = senderFrame
        self.menuNameArray = menuNameArray
        self.menuImageArray = menuImageArray
        self.popOverPosition = popOverPosition
        self.configuration = config ?? HSConfiguration()
        self.done = done
        self.cancel = cancel
        
        UIApplication.shared.keyWindow?.addSubview(self.backgroundView)
        self.adjustPostionForPopOverMenu()
    }
    
    public func dismiss() {
        let tempItem: HSMenuItem = HSMenuItem.init()
        tempItem.tag = -1
        self.doneActionWithSelectedCell(selectedCell: tempItem)
    }
    
    fileprivate func adjustPostionForPopOverMenu() {
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT)
        
        self.setupPopOverMenu()
        
        self.showIfNeeded()
    }
    
    fileprivate func setupPopOverMenu() {
        popOverMenuView.delegate = self
        popOverMenuView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        self.configurePopMenuFrame()
        
        popOverMenuView.showWithAnglePoint(point: menuArrowPoint,
                                           frame: popMenuFrame,
                                           menuNameArray: menuNameArray,
                                           menuImageArray: menuImageArray,
                                           config: configuration,
                                           arrowDirection: arrowDirection,
                                           delegate: self)
        
        popOverMenuView.setAnchorPoint(anchorPoint: self.getAnchorPointForPopMenu())
    }
    
    fileprivate func getAnchorPointForPopMenu() -> CGPoint {
        var anchorPoint = CGPoint(x: menuArrowPoint.x/popMenuFrame.size.width, y: 0)
        if arrowDirection == .down {
            anchorPoint = CGPoint(x: menuArrowPoint.x/popMenuFrame.size.width, y: 1)
        }
        return anchorPoint
    }
    
    fileprivate var senderRect: CGRect = CGRect.zero
    fileprivate var popMenuOriginX: CGFloat = 0
    fileprivate var popMenuFrame: CGRect = CGRect.zero
    fileprivate var menuArrowPoint: CGPoint = CGPoint.zero
    fileprivate var arrowDirection: HSPopOverMenuArrowDirection = .up
    fileprivate var popMenuHeight: CGFloat {
        return configuration.menuRowHeight + HS.DefaultMenuArrowHeight
    }
    
    fileprivate func configureSenderRect() {
        if let sender = self.sender {
            if let superView = sender.superview {
                senderRect = superView.convert(sender.frame, to: backgroundView)
            }
        } else if let frame = senderFrame {
            senderRect = frame
        }
        senderRect.origin.y = min(K_SCREEN_HEIGHT, senderRect.origin.y)
        
        if popOverPosition == .alwaysAboveSender {
            arrowDirection = .down
        } else if popOverPosition == .alwaysUnderSender {
            arrowDirection = .up
        } else {
            if senderRect.origin.y + senderRect.size.height/2 < K_SCREEN_HEIGHT/2 {
                arrowDirection = .up
            } else {
                arrowDirection = .down
            }
        }
    }
    
    fileprivate func configurePopMenuOriginX() {
        var senderXCenter: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width)/2, y: 0)
        let menuCenterX: CGFloat = configuration.menuWidth/2 + HS.DefaultMargin
        var menuX: CGFloat = 0
        if senderXCenter.x + menuCenterX > K_SCREEN_WIDTH {
            senderXCenter.x = min(senderXCenter.x - (K_SCREEN_WIDTH - configuration.menuWidth - HS.DefaultMargin), configuration.menuWidth - HS.DefaultMenuArrowWidth - HS.DefaultMargin)
            menuX = K_SCREEN_WIDTH - configuration.menuWidth - HS.DefaultMargin
        } else if senderXCenter.x - menuCenterX < 0 {
            senderXCenter.x = max(HS.DefaultMenuCornerRadius + HS.DefaultMenuArrowWidth, senderXCenter.x - HS.DefaultMargin)
            menuX = HS.DefaultMargin
        } else {
            senderXCenter.x = configuration.menuWidth/2
            menuX = senderRect.origin.x + (senderRect.size.width)/2 - configuration.menuWidth/2
        }
        popMenuOriginX = menuX
    }
    
    fileprivate func configurePopMenuFrame() {
        self.configureSenderRect()
        self.configureMenuArrowPoint()
        self.configurePopMenuOriginX()

        var safeAreaInset = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            safeAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
        }
        
        if arrowDirection == .up {
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height), width: configuration.menuWidth, height: popMenuHeight)
            if (popMenuFrame.origin.y + popMenuFrame.size.height > K_SCREEN_HEIGHT - safeAreaInset.bottom) {
                popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height), width: configuration.menuWidth, height: K_SCREEN_HEIGHT - popMenuFrame.origin.y - HS.DefaultMargin - safeAreaInset.bottom)
            }
        } else {
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y - popMenuHeight), width: configuration.menuWidth, height: popMenuHeight)
            if popMenuFrame.origin.y  < safeAreaInset.top {
                popMenuFrame = CGRect(x: popMenuOriginX, y: HS.DefaultMargin + safeAreaInset.top, width: configuration.menuWidth, height: senderRect.origin.y - HS.DefaultMargin - safeAreaInset.top)
            }
        }
    }
    
    fileprivate func configureMenuArrowPoint() {
        var point: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width)/2, y: 0)
        let menuCenterX: CGFloat = configuration.menuWidth/2 + HS.DefaultMargin
        if senderRect.origin.y + senderRect.size.height/2 < K_SCREEN_HEIGHT/2 {
            point.y = 0
        } else {
            point.y = popMenuHeight
        }
        if point.x + menuCenterX > K_SCREEN_WIDTH {
            point.x = min(point.x - (K_SCREEN_WIDTH - configuration.menuWidth - HS.DefaultMargin), configuration.menuWidth - HS.DefaultMenuArrowWidth - HS.DefaultMargin)
        } else if point.x - menuCenterX < 0 {
            point.x = max(HS.DefaultMenuCornerRadius + HS.DefaultMenuArrowWidth, point.x - HS.DefaultMargin)
        } else {
            point.x = configuration.menuWidth/2
        }
        menuArrowPoint = point
    }
    
    @objc fileprivate func onBackgroudViewTapped(gesture: UIGestureRecognizer) {
        self.dismiss()
    }
    
    fileprivate func showIfNeeded() {
        if self.isOnScreen == false {
            self.isOnScreen = true
            popOverMenuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: HS.DefaultAnimationDuration, animations: {
                self.popOverMenuView.alpha = 1
                self.popOverMenuView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    fileprivate func doneActionWithSelectedCell(selectedCell: HSMenuItem) {
        let selectedIndex: Int = selectedCell.tag
        if configuration.noDismissalIndexes?.firstIndex(of: selectedIndex) != nil {
            self.done?(selectedCell)
            return
        }
        
        self.isOnScreen = false
        
        UIView.animate(withDuration: HS.DefaultAnimationDuration,
                       animations: {
                        self.popOverMenuView.alpha = 0
                        self.popOverMenuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { [unowned self] (_) in
            // 释放菜单中的创建的控件
            popOverMenuView.deinitAllMenuItems()
            self.backgroundView.removeFromSuperview()
            if selectedIndex < 0 {
                self.cancel?()
                self.cancel = nil
            } else {
                self.done?(selectedCell)
                self.done = nil
            }
        }
    }
    
    // MARK: - HSPopOverMenuViewDelegate -
    func HSPopOverMenuView(didSelect menuItem: HSMenuItem) {
        self.doneActionWithSelectedCell(selectedCell: menuItem)
    }
}

extension HSPopOverMenu {
    
    fileprivate func addOrientationChangeNotification() {
        NotificationCenter.default.addObserver(self,selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                                               name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)
    }
    
    fileprivate func removeOrientationChangeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func onChangeStatusBarOrientationNotification(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.adjustPostionForPopOverMenu()
        })
    }
    
}

fileprivate protocol HSPopOverMenuViewDelegate: NSObjectProtocol {
    
    func HSPopOverMenuView(didSelect menuItem: HSMenuItem)
    
}

fileprivate class HSPopOverMenuView: UIControl {
    
    fileprivate var menuNameArray: [HSMenuObject]!
    fileprivate var menuImageArray: [Imageable]?
    fileprivate var arrowDirection: HSPopOverMenuArrowDirection = .up
    fileprivate weak var delegate: HSPopOverMenuViewDelegate?
    fileprivate var configuration = HSConfiguration()
    
    fileprivate lazy var menuView: UIView = {
        let view = UIView.init()
        view.layer.cornerRadius = self.configuration.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    deinit {
        deallocPrint()
    }
    
    fileprivate func deinitAllMenuItems() {
        for item in menuView.subviews {
            item .removeFromSuperview()
        }
    }
    
    fileprivate func showWithAnglePoint(point: CGPoint, frame: CGRect, menuNameArray: [HSMenuObject]!, menuImageArray: [Imageable]?, config: HSConfiguration? = nil, arrowDirection: HSPopOverMenuArrowDirection, delegate: HSPopOverMenuViewDelegate?) {
        
        self.frame = frame
        
        self.menuNameArray = menuNameArray
        self.menuImageArray = menuImageArray
        self.configuration = config ?? HSConfiguration()
        self.arrowDirection = arrowDirection
        self.delegate = delegate
        
        repositionMenuTableView()
        
        drawBackgroundLayerWithArrowPoint(arrowPoint: point)
    }
    
    fileprivate func repositionMenuTableView() {
        var menuRect: CGRect = CGRect(x: 0, y: HS.DefaultMenuArrowHeight, width: frame.size.width, height: frame.size.height - HS.DefaultMenuArrowHeight)
        if (arrowDirection == .down) {
            menuRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - HS.DefaultMenuArrowHeight)
        }
        menuView.frame = menuRect
        addSubview(self.menuView)
        self.buildCells()
    }
    
    // 以name数组为准,如果name数组和Image数组同时存在,二者相同的时候才可以创建
    fileprivate func buildCells() {
        let imgIsEmpty: Bool = menuImageArray?.isEmpty ?? true
        if !imgIsEmpty && menuImageArray!.count != menuNameArray!.count {
            print("数据不吻合")
            return
        }
        for index in 0..<menuNameArray.count {
            autoreleasepool {
                let imageable: Imageable? = imgIsEmpty ? nil : menuImageArray?[index]
                let item: HSMenuItem = HSMenuItem.init(frame: CGRect.init(x: configuration.menuItemWidth * CGFloat(index), y: 0, width: configuration.menuItemWidth, height: configuration.menuRowHeight))
                item.setupCellWith(menuName: menuNameArray[index], menuImage: imageable, configuration: configuration)
                item.tag = index
                item.addTarget(self, action: #selector(clickMenuCell(sender:)), for: .touchUpInside)
                menuView.addSubview(item)
            }
        }
    }
    
    @objc fileprivate func clickMenuCell(sender: HSMenuItem) {
        self.delegate?.HSPopOverMenuView(didSelect: sender)
    }
    
    fileprivate lazy var backgroundLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        return layer
    }()
    
    
    fileprivate func drawBackgroundLayerWithArrowPoint(arrowPoint: CGPoint) {
        if self.backgroundLayer.superlayer != nil {
            self.backgroundLayer.removeFromSuperlayer()
        }
        
        backgroundLayer.path = getBackgroundPath(arrowPoint: arrowPoint).cgPath
        backgroundLayer.fillColor = configuration.backgoundTintColor.cgColor
        backgroundLayer.strokeColor = configuration.borderColor.cgColor
        backgroundLayer.lineWidth = configuration.borderWidth
        
        if let adpater = self.configuration.localShadowAdapter {
            adpater(backgroundLayer)
        } else {
            if configuration.localShadow {
                backgroundLayer.shadowColor = UIColor.black.cgColor
                backgroundLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                backgroundLayer.shadowRadius = 24.0
                backgroundLayer.shadowOpacity = 0.9
                backgroundLayer.masksToBounds = false
                backgroundLayer.shouldRasterize = true
                backgroundLayer.rasterizationScale = UIScreen.main.scale
            }
        }
        self.layer.insertSublayer(backgroundLayer, at: 0)
        //        backgroundLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(M_PI))) //CATransform3DMakeRotation(CGFloat(M_PI), 1, 1, 0)
    }
    
    func getBackgroundPath(arrowPoint: CGPoint) -> UIBezierPath {
        
        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height
        
        let radius: CGFloat = configuration.cornerRadius
        
        let path: UIBezierPath = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        if (arrowDirection == .up){
            path.move(to: CGPoint(x: arrowPoint.x - HS.DefaultMenuArrowWidth, y: HS.DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
            path.addLine(to: CGPoint(x: arrowPoint.x + HS.DefaultMenuArrowWidth, y: HS.DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x:viewWidth - radius, y: HS.DefaultMenuArrowHeight))
            path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: HS.DefaultMenuArrowHeight + radius),
                        radius: radius,
                        startAngle: .pi / 2 * 3,
                        endAngle: 0,
                        clockwise: true)
            path.addLine(to: CGPoint(x: viewWidth, y: viewHeight - radius))
            path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: viewHeight - radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi / 2,
                        clockwise: true)
            path.addLine(to: CGPoint(x: radius, y: viewHeight))
            path.addArc(withCenter: CGPoint(x: radius, y: viewHeight - radius),
                        radius: radius,
                        startAngle: .pi / 2,
                        endAngle: .pi,
                        clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: HS.DefaultMenuArrowHeight + radius))
            path.addArc(withCenter: CGPoint(x: radius, y: HS.DefaultMenuArrowHeight + radius),
                        radius: radius,
                        startAngle: .pi,
                        endAngle: .pi / 2 * 3,
                        clockwise: true)
            path.close()
            //            path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: HSDefaultMenuArrowHeight, width: self.bounds.size.width, height: self.bounds.height - HSDefaultMenuArrowHeight), cornerRadius: configuration.cornerRadius)
            //            path.move(to: CGPoint(x: arrowPoint.x - HSDefaultMenuArrowWidth, y: HSDefaultMenuArrowHeight))
            //            path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
            //            path.addLine(to: CGPoint(x: arrowPoint.x + HSDefaultMenuArrowWidth, y: HSDefaultMenuArrowHeight))
            //            path.close()
        }else{
            path.move(to: CGPoint(x: arrowPoint.x - HS.DefaultMenuArrowWidth, y: viewHeight - HS.DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: viewHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x + HS.DefaultMenuArrowWidth, y: viewHeight - HS.DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: viewWidth - radius, y: viewHeight - HS.DefaultMenuArrowHeight))
            path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: viewHeight - HS.DefaultMenuArrowHeight - radius),
                        radius: radius,
                        startAngle: .pi / 2,
                        endAngle: 0,
                        clockwise: false)
            path.addLine(to: CGPoint(x: viewWidth, y: radius))
            path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi / 2 * 3,
                        clockwise: false)
            path.addLine(to: CGPoint(x: radius, y: 0))
            path.addArc(withCenter: CGPoint(x: radius, y: radius),
                        radius: radius,
                        startAngle: .pi / 2 * 3,
                        endAngle: .pi,
                        clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: viewHeight - HS.DefaultMenuArrowHeight - radius))
            path.addArc(withCenter: CGPoint(x: radius, y: viewHeight - HS.DefaultMenuArrowHeight - radius),
                        radius: radius,
                        startAngle: .pi,
                        endAngle: .pi / 2,
                        clockwise: false)
            path.close()
            //            path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.height - HSDefaultMenuArrowHeight), cornerRadius: configuration.cornerRadius)
            //            path.move(to: CGPoint(x: arrowPoint.x - HSDefaultMenuArrowWidth, y: self.bounds.size.height - HSDefaultMenuArrowHeight))
            //            path.addLine(to: CGPoint(x: arrowPoint.x, y: self.bounds.size.height))
            //            path.addLine(to: CGPoint(x: arrowPoint.x + HSDefaultMenuArrowWidth, y: self.bounds.size.height - HSDefaultMenuArrowHeight))
            //            path.close()
        }
        return path
    }
}
