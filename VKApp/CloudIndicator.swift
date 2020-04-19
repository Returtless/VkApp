//
//  DotsIndicator.swift
//  VKApp
//
//  Created by Владислав Лихачев on 14.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

@IBDesignable
class CloudIndicator: UIView {
    
    let cloudLayer = CAShapeLayer()
    
    var dots = [CALayer]()
    var count = 3
    var radius : CGFloat = 8
    var spacing : CGFloat = 8
    var size : CGSize {
        return CGSize(width: radius * 2, height: radius * 2)
    }
    
    func configure() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 18.14, y: 59.27))
        bezierPath.addCurve(to: CGPoint(x: 85.5, y: 59.27), controlPoint1: CGPoint(x: 18.14, y: 59.27), controlPoint2: CGPoint(x: 63.56, y: 59.78))
        bezierPath.addCurve(to: CGPoint(x: 108.46, y: 57.23), controlPoint1: CGPoint(x: 107.44, y: 58.76), controlPoint2: CGPoint(x: 106.55, y: 58.63))
        bezierPath.addCurve(to: CGPoint(x: 111.53, y: 54.67), controlPoint1: CGPoint(x: 110.38, y: 55.82), controlPoint2: CGPoint(x: 111.53, y: 54.67))
        bezierPath.addCurve(to: CGPoint(x: 114.59, y: 50.58), controlPoint1: CGPoint(x: 111.53, y: 54.67), controlPoint2: CGPoint(x: 113.31, y: 52.76))
        bezierPath.addCurve(to: CGPoint(x: 116.63, y: 45.99), controlPoint1: CGPoint(x: 115.86, y: 48.41), controlPoint2: CGPoint(x: 115.1, y: 49.56))
        bezierPath.addCurve(to: CGPoint(x: 118.16, y: 41.9), controlPoint1: CGPoint(x: 118.16, y: 42.41), controlPoint2: CGPoint(x: 117.39, y: 44.71))
        bezierPath.addCurve(to: CGPoint(x: 118.16, y: 34.74), controlPoint1: CGPoint(x: 118.93, y: 39.09), controlPoint2: CGPoint(x: 118.16, y: 37.04))
        bezierPath.addCurve(to: CGPoint(x: 116.63, y: 29.12), controlPoint1: CGPoint(x: 118.16, y: 32.44), controlPoint2: CGPoint(x: 117.9, y: 31.42))
        bezierPath.addCurve(to: CGPoint(x: 111.53, y: 23.5), controlPoint1: CGPoint(x: 115.35, y: 26.82), controlPoint2: CGPoint(x: 114.33, y: 25.03))
        bezierPath.addCurve(to: CGPoint(x: 105.91, y: 20.94), controlPoint1: CGPoint(x: 108.72, y: 21.96), controlPoint2: CGPoint(x: 108.72, y: 21.58))
        bezierPath.addCurve(to: CGPoint(x: 98.26, y: 20.94), controlPoint1: CGPoint(x: 103.11, y: 20.3), controlPoint2: CGPoint(x: 99.41, y: 20.3))
        bezierPath.addCurve(to: CGPoint(x: 95.2, y: 23.5), controlPoint1: CGPoint(x: 97.11, y: 21.58), controlPoint2: CGPoint(x: 95.2, y: 23.5))
        bezierPath.addCurve(to: CGPoint(x: 91.11, y: 23.5), controlPoint1: CGPoint(x: 95.2, y: 23.5), controlPoint2: CGPoint(x: 92.52, y: 25.93))
        bezierPath.addCurve(to: CGPoint(x: 88.05, y: 13.79), controlPoint1: CGPoint(x: 89.71, y: 21.07), controlPoint2: CGPoint(x: 90.86, y: 18.52))
        bezierPath.addCurve(to: CGPoint(x: 79.89, y: 4.59), controlPoint1: CGPoint(x: 85.25, y: 9.06), controlPoint2: CGPoint(x: 83.46, y: 7.53))
        bezierPath.addCurve(to: CGPoint(x: 73.76, y: 2.03), controlPoint1: CGPoint(x: 76.32, y: 1.65), controlPoint2: CGPoint(x: 73.76, y: 2.03))
        bezierPath.addCurve(to: CGPoint(x: 65.09, y: 0.5), controlPoint1: CGPoint(x: 73.76, y: 2.03), controlPoint2: CGPoint(x: 69.04, y: 0.5))
        bezierPath.addCurve(to: CGPoint(x: 57.95, y: 2.03), controlPoint1: CGPoint(x: 61.13, y: 0.5), controlPoint2: CGPoint(x: 57.95, y: 2.03))
        bezierPath.addCurve(to: CGPoint(x: 51.31, y: 4.59), controlPoint1: CGPoint(x: 57.95, y: 2.03), controlPoint2: CGPoint(x: 53.74, y: 3.18))
        bezierPath.addCurve(to: CGPoint(x: 48.25, y: 7.65), controlPoint1: CGPoint(x: 48.89, y: 5.99), controlPoint2: CGPoint(x: 48.25, y: 7.65))
        bezierPath.addLine(to: CGPoint(x: 45.19, y: 11.74))
        bezierPath.addLine(to: CGPoint(x: 43.15, y: 13.79))
        bezierPath.addCurve(to: CGPoint(x: 38.55, y: 15.83), controlPoint1: CGPoint(x: 43.15, y: 13.79), controlPoint2: CGPoint(x: 40.98, y: 15.83))
        bezierPath.addCurve(to: CGPoint(x: 33.45, y: 13.79), controlPoint1: CGPoint(x: 36.13, y: 15.83), controlPoint2: CGPoint(x: 33.45, y: 13.79))
        bezierPath.addCurve(to: CGPoint(x: 29.37, y: 13.79), controlPoint1: CGPoint(x: 33.45, y: 13.79), controlPoint2: CGPoint(x: 31.16, y: 13.28))
        bezierPath.addCurve(to: CGPoint(x: 26.31, y: 15.83), controlPoint1: CGPoint(x: 27.58, y: 14.3), controlPoint2: CGPoint(x: 26.31, y: 15.83))
        bezierPath.addLine(to: CGPoint(x: 23.76, y: 18.39))
        bezierPath.addLine(to: CGPoint(x: 22.22, y: 20.94))
        bezierPath.addCurve(to: CGPoint(x: 20.69, y: 23.5), controlPoint1: CGPoint(x: 22.22, y: 20.94), controlPoint2: CGPoint(x: 21.71, y: 23.5))
        bezierPath.addCurve(to: CGPoint(x: 16.61, y: 20.94), controlPoint1: CGPoint(x: 19.67, y: 23.5), controlPoint2: CGPoint(x: 18.27, y: 21.58))
        bezierPath.addCurve(to: CGPoint(x: 10.49, y: 20.94), controlPoint1: CGPoint(x: 14.95, y: 20.3), controlPoint2: CGPoint(x: 12.4, y: 20.3))
        bezierPath.addCurve(to: CGPoint(x: 6.41, y: 23.5), controlPoint1: CGPoint(x: 8.57, y: 21.58), controlPoint2: CGPoint(x: 8.32, y: 21.96))
        bezierPath.addCurve(to: CGPoint(x: 2.83, y: 27.08), controlPoint1: CGPoint(x: 4.49, y: 25.03), controlPoint2: CGPoint(x: 4.36, y: 25.03))
        bezierPath.addCurve(to: CGPoint(x: 0.28, y: 33.21), controlPoint1: CGPoint(x: 1.3, y: 29.12), controlPoint2: CGPoint(x: 0.28, y: 29.89))
        bezierPath.addCurve(to: CGPoint(x: 0.28, y: 40.36), controlPoint1: CGPoint(x: 0.28, y: 36.53), controlPoint2: CGPoint(x: -0.23, y: 37.3))
        bezierPath.addCurve(to: CGPoint(x: 2.83, y: 45.99), controlPoint1: CGPoint(x: 0.79, y: 43.43), controlPoint2: CGPoint(x: 2.83, y: 45.99))
        bezierPath.addLine(to: CGPoint(x: 4.87, y: 50.58))
        bezierPath.addCurve(to: CGPoint(x: 10.49, y: 57.23), controlPoint1: CGPoint(x: 4.87, y: 50.58), controlPoint2: CGPoint(x: 7.17, y: 55.06))
        bezierPath.addCurve(to: CGPoint(x: 18.14, y: 59.27), controlPoint1: CGPoint(x: 13.81, y: 59.4), controlPoint2: CGPoint(x: 18.14, y: 59.27))
        bezierPath.close()
        cloudLayer.fillColor = UIColor.white.cgColor
        cloudLayer.lineWidth = 5
        cloudLayer.path = bezierPath.cgPath
        cloudLayer.strokeColor = UIColor.blue.cgColor
        cloudLayer.lineJoin = .round
        cloudLayer.lineCap = .round
        cloudLayer.add(scaleAnimation(), forKey: nil)
        
        layer.addSublayer(cloudLayer)
        
    }
    
    func scaleAnimation() -> CAAnimationGroup{
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.fromValue = 0.07
        end.toValue = 1
        end.fillMode = .both
        
        let begin = CABasicAnimation(keyPath: "strokeStart")
        begin.beginTime = 0.5
        begin.fromValue = 0
        begin.toValue = 1
        begin.fillMode = .both
        
        
        let group = CAAnimationGroup()
        group.animations = [end, begin]
        group.repeatCount = 3
        group.duration = 5
        group.isRemovedOnCompletion = false
        
        return group
    }
}
