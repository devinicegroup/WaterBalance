//
//  StatisticsCell.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 19.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class StatisticsCell: UITableViewCell {
    
    static let reuseId = "StatisticsCell"
    
    let iconView = UIView()
    let drinkImageView = UIImageView()
    let valueLabel = UILabel()
    let drinkNameLabel = UILabel()
    var progressBar: MyProgressView!
    let width: CGFloat = 52
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with value: StatisticVolume, percent: Double) {
        iconView.backgroundColor = .mainWhite()
        drinkImageView.image = UIImage(named: value.imageString)
        
        valueLabel.textColor = .typographyPrimary()
        valueLabel.font = .bodyMedium()
        valueLabel.text = "\(Int(value.volume)) мл"
        
        drinkNameLabel.textColor = .typographyPrimary()
        drinkNameLabel.font = .bodyMedium()
        drinkNameLabel.text = value.nameForUser
        
        let widthProgressBar = UIScreen.main.bounds.width - self.width - 32 - 12
        let widthUsefulProgressBar = CGFloat(percent) * widthProgressBar
        progressBar = MyProgressView(width: widthProgressBar, height: 6)
        progressBar.configure(width: widthUsefulProgressBar)
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layer.cornerRadius = width / 2
        self.iconView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        iconView.addSubview(drinkImageView)
        addSubview(valueLabel)
        addSubview(drinkNameLabel)
        addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: width),
            iconView.widthAnchor.constraint(equalToConstant: width)
        ])
        
        NSLayoutConstraint.activate([
            drinkImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            drinkImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            drinkImageView.heightAnchor.constraint(equalToConstant: width - 22),
            drinkImageView.widthAnchor.constraint(equalToConstant: width - 22)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            valueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            drinkNameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            drinkNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            progressBar.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
}
