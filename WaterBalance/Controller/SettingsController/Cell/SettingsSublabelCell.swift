//
//  SettingsSublabelCell.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 09.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class SettingsSublabelCell: UITableViewCell {

    static let reuseId = "SettingsSublabelCell"
    
    let iconView = UIView()
    let iconImageView = UIImageView()
    let leftLabel = UILabel()
    let rightLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layer.cornerRadius = 5
        self.iconView.clipsToBounds = true
    }

    private func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        addSubview(iconImageView)
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 30),
            iconView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            iconImageView.widthAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            leftLabel.trailingAnchor.constraint(equalTo: rightLabel.leadingAnchor, constant: -16),
            leftLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(with value: SettingsModel) {
        iconView.backgroundColor = .mainLight2()
        iconImageView.image = UIImage(named: value.imageString)
        
        leftLabel.text = value.nameForUser
        leftLabel.textColor = .typographyPrimary()
        leftLabel.font = .bodyMedium()
        
        rightLabel.text = value.subtitle
        rightLabel.textColor = .typographySecondary()
        rightLabel.font = .bodyMedium()
        rightLabel.textAlignment = .right
    }
}
