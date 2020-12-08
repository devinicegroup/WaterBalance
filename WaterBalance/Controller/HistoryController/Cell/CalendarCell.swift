//
//  CalendarCell.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 11.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarCell: FSCalendarCell {
    
    static let reuseId = "CalendarCell"
    
    var roundedProgress: RoundProgressBar!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if self.roundedProgress != nil {
            self.roundedProgress.removeFromSuperview()
        }
    }
    
    override init!(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with volume: Double, date: Date) {
        let dailyTarget = StorageService.shared.getDailyTarget(date: date).first?.target ?? 1
        let firstDate = UserDefaults.standard.string(forKey: UserDefaultsServiceEnum.firstDate.rawValue)!
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        
        if date >= Date().startOfDay {
            roundedProgress = RoundProgressBar(color: UIColor.mainWhite().cgColor)
        } else {
            if date >= formatter.date(from: firstDate)! && dailyTarget > volume {
                roundedProgress = RoundProgressBar(color: UIColor.pink().cgColor)
            } else {
                roundedProgress = RoundProgressBar(color: UIColor.mainWhite().cgColor)
            }
        }
        setupConstraints()
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let from = 0.0
        var to = volume / dailyTarget + from
        if to > 1 { to = 1}
        basicAnimation.fromValue = from
        basicAnimation.toValue = to
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        roundedProgress.fgLayer.add(basicAnimation, forKey: "drink")
    }
    
    private func setupConstraints() {
        roundedProgress.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(roundedProgress)
        
        NSLayoutConstraint.activate([
            roundedProgress.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            roundedProgress.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -4),
            roundedProgress.heightAnchor.constraint(equalToConstant: 30),
            roundedProgress.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}

class RoundProgressBar: UIView {
    var bgLayer = CAShapeLayer()
    var fgLayer = CAShapeLayer()
    var bgStrokeColor: CGColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    init(color: CGColor) {
        super.init(frame: CGRect())
        self.bgStrokeColor = color
        configureView()
    }
    
    func configureView() {
        let progressBarWidth: CGFloat = 2
        bgLayer.lineWidth = progressBarWidth
        bgLayer.fillColor = nil
        bgLayer.strokeEnd = CGFloat(1)
        layer.addSublayer(bgLayer)
        fgLayer.lineWidth = progressBarWidth
        fgLayer.fillColor = nil
        fgLayer.strokeEnd = 0
        fgLayer.lineCap = .round
        layer.addSublayer(fgLayer)
        bgLayer.strokeColor = bgStrokeColor
        fgLayer.strokeColor = UIColor.blue().cgColor
    }
    
    func setupCAShapeLayers(shapeLayer: CAShapeLayer, startAngle: CGFloat, endAngle: CGFloat) {
        shapeLayer.frame = self.bounds
        let center = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
        let radius = (self.bounds.width/2)
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
