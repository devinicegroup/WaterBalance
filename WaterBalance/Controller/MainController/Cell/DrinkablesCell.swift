//
//  DrinkablesCell.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 27.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class DrinkablesCell: UICollectionViewCell {
    
    static var reuseId = "DrinkablesCell"
    
    let drinkName = UILabel()
    let iconView = UIView()
    let drinkImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        self.frame.width <= self.frame.height - 16 ? setupConstraints(value: self.frame.width) : setupConstraints(value: self.frame.height - 16)
    }
    
    func configure(with drink: DrinkStart) {
        drinkName.font = .bodyMediumMin3()
        drinkName.textColor = .typographySecondary()
        drinkName.textAlignment = .center
        drinkName.text = drink.nameForUser
        
        iconView.backgroundColor = .mainWhite()
        drinkImageView.image = UIImage(named: drink.imageString)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layer.cornerRadius = self.frame.width <= self.frame.height - 16 ? self.frame.width / 2 : (self.frame.height - 16) / 2
        self.iconView.clipsToBounds = true
    }
    
    private func setupConstraints(value: CGFloat) {
        drinkName.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(drinkName)
        addSubview(iconView)
        iconView.addSubview(drinkImageView)
        
        NSLayoutConstraint.activate([
            drinkName.topAnchor.constraint(equalTo: self.topAnchor),
            drinkName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            drinkName.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: drinkName.bottomAnchor, constant: 4),
            iconView.heightAnchor.constraint(equalToConstant: value),
            iconView.widthAnchor.constraint(equalToConstant: value),
            iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            drinkImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            drinkImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
