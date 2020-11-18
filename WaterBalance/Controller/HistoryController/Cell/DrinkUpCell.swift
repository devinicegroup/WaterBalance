//
//  DrinkUpCell.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 11.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class DrinkUpCell: UITableViewCell {
    
    static let reuseId = "DrinkUpCell"
    
    let iconView = UIView()
    let drinkImageView = UIImageView()
    let valueLabel = UILabel()
    let drinkNameLabel = UILabel()
    let timeLabel = UILabel()
    let width: CGFloat = 52
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupConstraints()
    }
    
    func configure(with value: DrinkUp) {
        
        iconView.backgroundColor = .mainWhite()
        drinkImageView.image = UIImage(named: value.drink!.imageString)
        
        valueLabel.textColor = .typographyPrimary()
        valueLabel.font = .bodyMedium()
        valueLabel.text = "\(Int(value.volume)) мл"
        
        drinkNameLabel.textColor = .typographyPrimary()
        drinkNameLabel.font = .bodyMedium()
        drinkNameLabel.text = value.drink?.nameForUser
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.textColor = .typographySecondary()
        timeLabel.font = .bodyMediumMin3()
        timeLabel.text = formatter.string(from: value.time)
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
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        iconView.addSubview(drinkImageView)
        addSubview(valueLabel)
        addSubview(drinkNameLabel)
        addSubview(timeLabel)
        
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
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            drinkNameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            drinkNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13)
        ])
    }
}
