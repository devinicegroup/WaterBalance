//
//  HistoryTableViewHeader.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 18.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class HistoryTableViewHeader: UITableViewHeaderFooterView {
    
    let bgView = UIView()
    let topView = UIView()
    let leftLabel = UILabel()
    let rightLabel = UILabel()

    static let reuseId = "HistoryTableViewHeader"

    func configure(date: String, volume: String) {
        setupConstraints()
        bgView.backgroundColor = .white
        topView.backgroundColor = .mainWhite()
        
        leftLabel.font = .bodyRegularMin1()
        leftLabel.textColor = .typographySecondary()
        leftLabel.text = date.uppercased()
        
        rightLabel.font = .bodyRegularMin1()
        rightLabel.textColor = .typographySecondary()
        rightLabel.text = volume
    }
    
    private func setupConstraints() {
        bgView.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bgView)
        bgView.addSubview(topView)
        topView.addSubview(leftLabel)
        topView.addSubview(rightLabel)
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 33)
        ])
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            leftLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rightLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
    }
}
