//
//  ZohoLogoActivityIndicatorView.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 21/06/18.
//

import UIKit

class ZOSActivityIndicatorView: UIView {

    public static var DEFAULT_COLOR = UIColor.blue
    public static var DEFAULT_PADDING: CGFloat = 4
    
    public static var DEFAULT_SIZE = CGSize(width: 60, height: 60)

    @IBInspectable public var color: [UIColor] = [UIColor(rgb : 0xDE5347),//red
                                                  UIColor(rgb : 0x4E9D53),//green
                                                  UIColor(rgb : 0x2F75B0),//blue
                                                  UIColor(rgb : 0xFBE44D)]//yellow

    @IBInspectable public var padding: CGFloat = ZOSActivityIndicatorView.DEFAULT_PADDING
    
    public var animating: Bool { return isAnimating }

    private(set) public var isAnimating: Bool = false
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
        self.layer.zPosition = ZpositionLevel.maximum.rawValue
    }

    public  init(frame:CGRect = CGRect(),containerView : UIView) {
       super.init(frame: frame)
        isHidden = true
        self.center = containerView.center
        self.frame.origin = CGPoint(x: CGFloat(containerView.center.x - ZOSActivityIndicatorView.DEFAULT_SIZE.width/2) ,  y: CGFloat(containerView.center.y - ZOSActivityIndicatorView.DEFAULT_SIZE.height/2))
        self.frame.size =  ZOSActivityIndicatorView.DEFAULT_SIZE
        backgroundColor = UIColor.clear
        self.layer.zPosition = ZpositionLevel.maximum.rawValue
        containerView.addSubview(self)
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    public override var bounds: CGRect {
        didSet {
            // setup the animation again for the new bounds
            if oldValue != bounds && isAnimating {
                setUpAnimation()
            }
        }
    }
//    var bgView = UIView()
    public final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setUpAnimation()
        //MARK:- Bluring background View
        //        bgView.frame = (containerView.frame)
        //        bgView.center = containerView.center
        //        bgView.layer.zPosition =  CGFloat.Magnitude.greatestFiniteMagnitude
        //        bgView.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        //        containerView.addSubview(bgView)
    }
    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
//        self.removeFromSuperview()
//        bgView.removeFromSuperview()
        
    }

    private final func setUpAnimation() {
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        setUpAnimation(in: layer, size: animationRect.size, color: color)
    }
    func setUpAnimation(in layer: CALayer, size: CGSize, color: [UIColor]) {
        let circleSpacing: CGFloat = 2
        let circleSize: CGFloat = (size.width - 2 * circleSpacing) / 3
        let x: CGFloat = (layer.bounds.size.width - size.width) / 2
        let y: CGFloat = (layer.bounds.size.height - circleSize) / 2
        let duration: CFTimeInterval = 0.75
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.1, 0.2, 0.3 ,0.4]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        // Animation
        animation.keyTimes = [0, 0.3, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw circles
        for i in 0 ..< 4 {
            let circle = CirclelayerWith(size: CGSize(width: circleSize, height: circleSize), color: color[i])
            let frame = CGRect(x: x + circleSize * CGFloat(i) + circleSpacing * CGFloat(i),
                               y: y,
                               width: circleSize,
                               height: circleSize)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.frame = frame
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
    func CirclelayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
}
