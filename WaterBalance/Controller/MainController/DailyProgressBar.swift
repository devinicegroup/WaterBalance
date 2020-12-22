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
    
    let topLabel = UILabel()
    let bottomLabel = UILabel()
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
//    if screenHeight/screenWidth > 2 {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        var progressBarWidth: CGFloat = 40.0
        if UIDevice.modelName == "iPhone 5" || UIDevice.modelName == "iPhone 5c" || UIDevice.modelName == "iPhone 5s" || UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "Simulator iPhone SE"{
            progressBarWidth = 20
        }
        
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
                
        topLabel.textColor = .typographyPrimary()
        topLabel.font = .header1()
        topLabel.textAlignment = .center
        
        bottomLabel.textColor = .typographySecondary()
        bottomLabel.font = .header2()
        bottomLabel.textAlignment = .center
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(topLabel)
        addSubview(bottomLabel)
        
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -12),
            topLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 16),
            bottomLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ])
    }
    
    func setupCAShapeLayers(shapeLayer: CAShapeLayer, startAngle: CGFloat, endAngle: CGFloat) {
        shapeLayer.frame = self.bounds
        let center = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
//        let radius = self.bounds.height < self.bounds.width ? (self.bounds.height / 2) - 20 : (self.bounds.width / 2) - 20
        
        var radius = (self.bounds.height / 2) - 20
        if UIDevice.modelName == "iPhone 5" || UIDevice.modelName == "iPhone 5c" || UIDevice.modelName == "iPhone 5s" || UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "Simulator iPhone SE"{
            radius = (self.bounds.height / 2) - 8
        }

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
