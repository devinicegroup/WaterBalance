//
//  EditingDrinkCell.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 16.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class EditingDrinkCell: UITableViewCell {
    
    static let reuseId = "EditingDrinkCell"
    
    let iconView = UIView()
    let drinkImageView = UIImageView()
    let nameLabel = UILabel()
    let width: CGFloat = 52
    
    override func prepareForReuse() {
        super.prepareForReuse()

        if self.accessoryView != nil {
            self.accessoryView = nil
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupConstraints()
    }
    
    func configure(drink: Drink) {
        iconView.backgroundColor = .mainWhite()
        drinkImageView.image = UIImage(named: drink.imageString)

        nameLabel.textColor = .typographyPrimary()
        nameLabel.font = .bodyMedium()
        nameLabel.text = drink.nameForUser
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.iconView.layer.cornerRadius = width / 2
        self.iconView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        iconView.addSubview(drinkImageView)
        addSubview(nameLabel)
        
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
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
