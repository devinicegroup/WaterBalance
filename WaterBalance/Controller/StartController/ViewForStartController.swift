//
//  ViewForStartController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 18.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class ViewForStartController: UIView {
    
    let iconView = UIView()
    let iconImageView = UIImageView()
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    let button = UIButton()
    let toggle = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(imageString: String, leftText: String, rightText: String?) {
        super.init(frame: CGRect.zero)
        configure(imageString: imageString, leftText: leftText, rightText: rightText)
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layer.cornerRadius = 5
        self.iconView.clipsToBounds = true
    }
    
    func configure(imageString: String, leftText: String, rightText: String?) {
        iconView.backgroundColor = .mainLight()
        iconImageView.image = UIImage(named: imageString)

        leftLabel.text = leftText
        leftLabel.textColor = .typographyPrimary()
        leftLabel.font = .bodyMedium()
        
        rightLabel.text = rightText
        rightLabel.textColor = .typographySecondary()
        rightLabel.font = .bodyMedium()
        
        toggle.isOn = false
        toggle.onTintColor = .pink()
        toggle.subviews[0].subviews[0].backgroundColor = .mainLight()
        toggle.isHidden = true
    }
    
    private func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        toggle.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconView)
        addSubview(iconImageView)
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(button)
        addSubview(toggle)
        
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true

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
            leftLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            leftLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            toggle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
