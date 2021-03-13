//
//  CurvedTabBar.swift
//  MemoryCard
//
//  Created by Zhanibek on 12.03.2021.
//

import UIKit

class CurvedTabBar: UITabBar {
    
    private var shapeLayer: CAShapeLayer?

    override func draw(_ rect: CGRect) {
        layer.backgroundColor = UIColor.clear.cgColor
        createShape(in: rect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tintColor = .black
    }
    
    private func createShape(in rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath(in: rect)
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.15
        shapeLayer.shadowPath = shapeLayer.path
        
        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    private func createPath(in rect: CGRect) -> CGPath {
        let height: CGFloat = rect.height
        let widthCenter = rect.width / 2
        
        let path = UIBezierPath()
        
        let curveDepth = 0.6*height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: widthCenter - 1.5*height, y: 0))
        
        path.addCurve(to: CGPoint(x: widthCenter, y: curveDepth), controlPoint1: CGPoint(x: widthCenter - height, y: 0), controlPoint2: CGPoint(x: widthCenter - height, y: curveDepth))
        path.addCurve(to: CGPoint(x: widthCenter + 1.5*height, y: 0), controlPoint1: CGPoint(x: widthCenter + height, y: curveDepth), controlPoint2: CGPoint(x: widthCenter + height, y: 0))
        
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()

        return path.cgPath
    }
}
