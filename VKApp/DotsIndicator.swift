//
//  DotsIndicator.swift
//  VKApp
//
//  Created by Владислав Лихачев on 14.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

@IBDesignable
class DotsIndicator: UIView {
    
    var dots = [CALayer]()
    var count = 3
    var radius : CGFloat = 8
    var spacing : CGFloat = 8
    var size : CGSize {
        return CGSize(width: radius * 2, height: radius * 2)
    }
    
    func configure(){
        for _ in 0..<count {
            let dot = CALayer()
            dots.append(dot)
            dot.bounds = CGRect(origin: .zero, size: size)
            dot.cornerRadius = radius
            dot.backgroundColor = UIColor.white.cgColor
            layer.addSublayer(dot)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let middle = count / 2
        
        for i in 0..<dots.count {
            let x = center.x + CGFloat(i - middle) * (size.width + spacing)
            dots[i].position = CGPoint(x: x, y: center.y)
        }
    }
    
    func scaleAnimation(_ after: TimeInterval) -> CAAnimationGroup{
        let scaleUp = CABasicAnimation(keyPath: "opacity")
        scaleUp.beginTime = after
        scaleUp.fromValue = 0
        scaleUp.toValue = 1
        scaleUp.duration = 1
        scaleUp.fillMode = .removed
        scaleUp.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let scaleDown = CABasicAnimation(keyPath: "opacity")
        scaleDown.beginTime = after + scaleUp.duration
        scaleDown.fromValue = 1
        scaleDown.toValue = 0
        scaleDown.duration = 1
        scaleDown.fillMode = .removed
        scaleDown.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.animations = [scaleUp, scaleDown]
        group.repeatCount = 3
        group.duration = CFTimeInterval(1)
        return group
    }
    
    
    func startAnimation(){
        var offset : TimeInterval = 0
        let key = "key"
        dots.forEach{
            $0.removeAnimation(forKey: key)
            $0.add(scaleAnimation(offset), forKey: key)
            offset+=0.2
        }
        
    }
    
    func stopAnimation(){
        dots.forEach{
            $0.removeAnimation(forKey: "key")
            $0.removeFromSuperlayer()
        }
        dots.removeAll()
    }
}
