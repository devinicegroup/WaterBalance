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
    
    let labelView = UIView()
    let topLabel = UILabel()
    let bottomLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                
        topLabel.textColor = .typographyPrimary()
        topLabel.font = .header1()
        topLabel.textAlignment = .center
        
        bottomLabel.textColor = .typographySecondary()
        bottomLabel.font = .header2()
        bottomLabel.textAlignment = .center
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        labelView.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(labelView)
        labelView.addSubview(topLabel)
        labelView.addSubview(bottomLabel)
        
        NSLayoutConstraint.activate([
            labelView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            labelView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
        ])
        
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: labelView.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: labelView.topAnchor),
            topLabel.widthAnchor.constraint(equalTo: labelView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.centerXAnchor.constraint(equalTo: labelView.centerXAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor),
            bottomLabel.widthAnchor.constraint(equalTo: labelView.widthAnchor)
        ])
    }
    
    func setupCAShapeLayers(shapeLayer: CAShapeLayer, startAngle: CGFloat, endAngle: CGFloat) {
        shapeLayer.frame = self.bounds
        let center = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
        let radius = self.bounds.height < self.bounds.width ? (self.bounds.height / 2) - 20 : (self.bounds.width / 2) - 20
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
