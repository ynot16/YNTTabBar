//
//  YNTTabbarViewController.swift
//  YNTTabbar
//
//  Created by bori－applepc on 16/9/27.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

class YNTTabbarViewController: UITabBarController {

    var captureImageView: UIImageView!
    fileprivate var itemWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tabBar.addGestureRecognizer(longPress)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        itemWidth = UIScreen.main.bounds.width / CGFloat(viewControllers!.count)
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let currentPoint = gesture.location(in: view)
            let currentIndex = currentPoint.x / itemWidth
            selectedIndex = Int(currentIndex)
            UIGraphicsBeginImageContextWithOptions(viewControllers![selectedIndex].view.frame.size, true, 0.0)
            viewControllers![selectedIndex].view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            captureImageView = UIImageView()
            captureImageView.image = image
            let rect = viewControllers![selectedIndex].view.frame
            captureImageView.frame = CGRect(x: currentPoint.x - 100, y: 0, width: 200, height: rect.height - 49)
            captureImageView.alpha = 0.8
            UIApplication.shared.keyWindow!.addSubview(captureImageView)
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.duration = 0.2
            animation.delegate = self
            animation.setValue("beganAppear", forKey: "animation")
            captureImageView.layer.add(animation, forKey: "scale")
        case .changed:
            let currentPoint = gesture.location(in: view)
            captureImageView.center = CGPoint(x: currentPoint.x, y: captureImageView.center.y)
            setViewControllers(shouldExchange(point: currentPoint), animated: true)
        case .ended, .failed, .cancelled:
            let currentPoint = gesture.location(in: view)
            captureImageView.layer.mask = mask()
            captureImageView.layer.fillMode = kCAFillModeForwards
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 1.0
            scaleAnim.toValue = 0.0
            scaleAnim.fillMode = kCAFillModeForwards
            scaleAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            let tranAnim = CABasicAnimation(keyPath: "position")
            tranAnim.toValue = NSValue(cgPoint: currentPoint)
            tranAnim.fillMode = kCAFillModeForwards
            tranAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            let group = CAAnimationGroup()
            group.duration = 0.3
            group.isRemovedOnCompletion = false
            group.fillMode = kCAFillModeForwards
            group.animations = [scaleAnim, tranAnim]
            group.delegate = self
            group.setValue("group", forKey: "animation")
            captureImageView.layer.add(group, forKey: "group")
            setViewControllers(shouldExchange(point: currentPoint), animated: true)
        default:
            print("this should not happen")
        }
    }
    
    func mask() -> CALayer {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 0, y: 200))
        path.addCurve(to: CGPoint(x: 150, y: captureImageView.frame.size.height), controlPoint1: CGPoint(x: 50, y: 230), controlPoint2: CGPoint(x: 90, y: 300))
        path.addCurve(to: CGPoint(x: captureImageView.frame.size.width, y: 280), controlPoint1: CGPoint(x: 170, y: 350), controlPoint2: CGPoint(x: 190, y: 400))
        path.addLine(to: CGPoint(x: captureImageView.frame.size.width, y: 0))
        path.close()
        shapeLayer.path = path.cgPath
        return shapeLayer
    }
    
    func shouldExchange(point: CGPoint) -> [UIViewController] {
        let currentX = point.x / itemWidth
        var array = viewControllers
        let vc = array?.remove(at: selectedIndex)
        array?.insert(vc!, at: Int(currentX))
        return array!
    }
}

extension YNTTabbarViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim.value(forKey: "animation") as? String == "group" {
            captureImageView.removeFromSuperview()
        }else if anim.value(forKey: "animation") as? String == "beganAppear" {
            let rect = self.viewControllers![self.selectedIndex].view.frame
            self.captureImageView.bounds = CGRect(x: 0, y: 0, width: 250, height: rect.height - 49)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.captureImageView.bounds = CGRect(x: 0, y: 0, width: 200, height: rect.height - 49)
                }, completion: nil)
        }
    }
}

