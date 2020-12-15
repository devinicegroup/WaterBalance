//
//  DailyProgressBar.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 15.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class DailyProgressBar: UIView {
    
    var bgLayer = CAShapeLayer()
    var fgLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        configureView()
    }
    
    func configureView() {
        let progressBarWidth: CGFloat = 40.0
        bgLayer.lineWidth = progressBarWidth
        bgLayer.fillColor = nil
        bgLayer.strokeEnd = CGFloat(1)
        layer.addSublayer(bgLayer)
        fgLayer.lineWidth = progressBarWidth
        fgLayer.fillColor = nil
        fgLayer.strokeEnd = 0
        //fgLayer.lineCap = .round
        layer.addSublayer(fgLayer)
        bgLayer.strokeColor = UIColor.mainWhite().cgColor
        fgLayer.strokeColor = UIColor.mainSecondary().cgColor
    }
    
    func setupCAShapeLayers(shapeLayer: CAShapeLayer, startAngle: CGFloat, endAngle: CGFloat) {
        shapeLayer.frame = self.bounds
        let center = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
        let radius = self.bounds.height < self.bounds.width ? (self.bounds.height / 2.2) - 20 : (self.bounds.width / 2.2) - 20
        let path = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
        setupCAShapeLayers(shapeLayer: bgLayer, startAngle: 0, endAngle: CGFloat(Double.pi*2))
        setupCAShapeLayers(shapeLayer: fgLayer, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi)
    }
}
