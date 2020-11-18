//
//  EditingCell.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 16.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class EditingCell: UITableViewCell {
    
    static let reuseId = "EditingCell"
    
    let iconView = UIView()
    let drinkImageView = UIImageView()
    let topLabel = UILabel()
    let bottomLabel = UILabel()
    let width: CGFloat = 52
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupConstraints()
    }
    
    func configure(imageString: String, topText: String, bottomText: String) {
        iconView.backgroundColor = .mainWhite()
        drinkImageView.image = UIImage(named: imageString)

        topLabel.textColor = .typographySecondary()
        topLabel.font = .bodyMediumMin3()
        topLabel.text = topText

        bottomLabel.textColor = .typographyPrimary()
        bottomLabel.font = .bodyMedium()
        bottomLabel.text = bottomText
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.iconView.layer.cornerRadius = width / 2
        self.iconView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        iconView.addSubview(drinkImageView)
        addSubview(topLabel)
        addSubview(bottomLabel)
        
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
            topLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13)
        ])
    }
}
