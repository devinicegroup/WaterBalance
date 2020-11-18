//
//  ContainerView.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 03.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class ContainerView: UIView {
    
    let containerName: UILabel = {
        let label = UILabel()
        label.font = .bodyMediumMin3()
        label.textColor = .typographySecondary()
        label.textAlignment = .center
        return label
    }()
    
    let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainWhite()
        return view
    }()
    
    let containerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(container: Container, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        addSubview(containerName)
        addSubview(iconView)
        addSubview(containerImageView)
        addSubview(button)
        self.frame.width <= self.frame.height - 16 ? setupConstraints(value: self.frame.width) : setupConstraints(value: self.frame.height - 16)
        
        containerName.text = "\(container.value)"
        containerImageView.image = UIImage(named: container.imageString)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layer.cornerRadius = self.frame.width <= self.frame.height - 16 ? self.frame.width / 2 : (self.frame.height - 16) / 2
        self.iconView.clipsToBounds = true
    }
    
    private func setupConstraints(value: CGFloat) {
        containerName.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        containerImageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerName.topAnchor.constraint(equalTo: self.topAnchor),
            containerName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerName.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: containerName.bottomAnchor, constant: 3),
            iconView.heightAnchor.constraint(equalToConstant: value),
            iconView.widthAnchor.constraint(equalToConstant: value),
            iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            containerImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            containerImageView.heightAnchor.constraint(equalToConstant: value / 1.75),
            containerImageView.widthAnchor.constraint(equalToConstant: value / 1.75)
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
