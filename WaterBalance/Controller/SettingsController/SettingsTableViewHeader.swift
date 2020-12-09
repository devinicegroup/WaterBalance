//
//  SettingsTableViewHeader.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 09.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class SettingsTableViewHeader: UITableViewHeaderFooterView {
    
    let bgView = UIView()
    let leftLabel = UILabel()
    
    static let reuseId = "SettingsTableViewHeader"
    
    func configure(name: String) {
        setupConstraints()
        bgView.backgroundColor = .mainWhite()
        
        leftLabel.font = .bodyRegularMin2()
        leftLabel.textColor = .typographySecondary()
        leftLabel.text = name.uppercased()
    }
    
    private func setupConstraints() {
        bgView.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bgView)
        addSubview(leftLabel)
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            leftLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 14),
        ])
    }
}
