//
//  ContainerPopUp.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 03.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol ContainerPopUpProtocol : NSObjectProtocol{
    func buttonTapped(volume: Double)
}

class ContainerPopUp: UIView {
    
    weak var delegate: ContainerPopUpProtocol? = nil
    
    let spacing = CGFloat(16)
    var widthContainer = CGFloat()
    var heightContainer = CGFloat()
    
    let topView = UIView()
    
    var volume0 = ContainerView()
    var volume1 = ContainerView()
    var volume2 = ContainerView()
    var volume3 = ContainerView()
    var volume4 = ContainerView()
    var volume5 = ContainerView()
    var volume6 = ContainerView()
    var volume7 = ContainerView()
    var volume8 = ContainerView()
    var volume9 = ContainerView()
     
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        topView.backgroundColor = .mainWhite()
        topView.layer.cornerRadius = 2.5
        
        setupVolume()
        setupConstraints()
        setupAction()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func setupAction() {
        volume0.button.tag = 0
        volume0.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume1.button.tag = 1
        volume1.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume2.button.tag = 2
        volume2.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume3.button.tag = 3
        volume3.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume4.button.tag = 4
        volume4.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume5.button.tag = 5
        volume5.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume6.button.tag = 6
        volume6.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume7.button.tag = 7
        volume7.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume8.button.tag = 8
        volume8.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
        volume9.button.tag = 9
        volume9.button.addTarget(self, action: #selector(containerTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func containerTapped(sender: UIButton) {
        delegate?.buttonTapped(volume: Container.containers[sender.tag].value)
        SwiftEntryKit.dismiss()
    }
    
    private func setupVolume() {
        widthContainer = (self.frame.width - ((spacing * 2) + (11 * 4))) / 5
        heightContainer = widthContainer * 1.3
        
        volume0 = ContainerView(container: Container.containers[0], width: widthContainer, height: heightContainer)
        volume1 = ContainerView(container: Container.containers[1], width: widthContainer, height: heightContainer)
        volume2 = ContainerView(container: Container.containers[2], width: widthContainer, height: heightContainer)
        volume3 = ContainerView(container: Container.containers[3], width: widthContainer, height: heightContainer)
        volume4 = ContainerView(container: Container.containers[4], width: widthContainer, height: heightContainer)
        volume5 = ContainerView(container: Container.containers[5], width: widthContainer, height: heightContainer)
        volume6 = ContainerView(container: Container.containers[6], width: widthContainer, height: heightContainer)
        volume7 = ContainerView(container: Container.containers[7], width: widthContainer, height: heightContainer)
        volume8 = ContainerView(container: Container.containers[8], width: widthContainer, height: heightContainer)
        volume9 = ContainerView(container: Container.containers[9], width: widthContainer, height: heightContainer)
    }
    
    private func setupConstraints() {
        let innerSpasing = CGFloat(11)
        
        self.addSubview(topView)
        self.addSubview(volume0)
        self.addSubview(volume1)
        self.addSubview(volume2)
        self.addSubview(volume3)
        self.addSubview(volume4)
        self.addSubview(volume5)
        self.addSubview(volume6)
        self.addSubview(volume7)
        self.addSubview(volume8)
        self.addSubview(volume9)

        topView.translatesAutoresizingMaskIntoConstraints = false
        volume0.translatesAutoresizingMaskIntoConstraints = false
        volume1.translatesAutoresizingMaskIntoConstraints = false
        volume2.translatesAutoresizingMaskIntoConstraints = false
        volume3.translatesAutoresizingMaskIntoConstraints = false
        volume4.translatesAutoresizingMaskIntoConstraints = false
        volume5.translatesAutoresizingMaskIntoConstraints = false
        volume6.translatesAutoresizingMaskIntoConstraints = false
        volume7.translatesAutoresizingMaskIntoConstraints = false
        volume8.translatesAutoresizingMaskIntoConstraints = false
        volume9.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            topView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topView.heightAnchor.constraint(equalToConstant: 5),
            topView.widthAnchor.constraint(equalToConstant: 82)
        ])
        
        NSLayoutConstraint.activate([
            volume0.topAnchor.constraint(equalTo: topView.topAnchor, constant: spacing),
            volume0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            volume0.heightAnchor.constraint(equalToConstant: heightContainer),
            volume0.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume1.topAnchor.constraint(equalTo: topView.topAnchor, constant: spacing),
            volume1.leadingAnchor.constraint(equalTo: volume0.trailingAnchor, constant: innerSpasing),
            volume1.heightAnchor.constraint(equalToConstant: heightContainer),
            volume1.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume2.topAnchor.constraint(equalTo: topView.topAnchor, constant: spacing),
            volume2.leadingAnchor.constraint(equalTo: volume1.trailingAnchor, constant: innerSpasing),
            volume2.heightAnchor.constraint(equalToConstant: heightContainer),
            volume2.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume3.topAnchor.constraint(equalTo: topView.topAnchor, constant: spacing),
            volume3.leadingAnchor.constraint(equalTo: volume2.trailingAnchor, constant: innerSpasing),
            volume3.heightAnchor.constraint(equalToConstant: heightContainer),
            volume3.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume4.topAnchor.constraint(equalTo: topView.topAnchor, constant: spacing),
            volume4.leadingAnchor.constraint(equalTo: volume3.trailingAnchor, constant: innerSpasing),
            volume4.heightAnchor.constraint(equalToConstant: heightContainer),
            volume4.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume5.topAnchor.constraint(equalTo: volume0.bottomAnchor, constant: innerSpasing),
            volume5.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            volume5.heightAnchor.constraint(equalToConstant: heightContainer),
            volume5.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume6.topAnchor.constraint(equalTo: volume0.bottomAnchor, constant: innerSpasing),
            volume6.leadingAnchor.constraint(equalTo: volume5.trailingAnchor, constant: innerSpasing),
            volume6.heightAnchor.constraint(equalToConstant: heightContainer),
            volume6.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume7.topAnchor.constraint(equalTo: volume0.bottomAnchor, constant: innerSpasing),
            volume7.leadingAnchor.constraint(equalTo: volume6.trailingAnchor, constant: innerSpasing),
            volume7.heightAnchor.constraint(equalToConstant: heightContainer),
            volume7.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume8.topAnchor.constraint(equalTo: volume0.bottomAnchor, constant: innerSpasing),
            volume8.leadingAnchor.constraint(equalTo: volume7.trailingAnchor, constant: innerSpasing),
            volume8.heightAnchor.constraint(equalToConstant: heightContainer),
            volume8.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
        
        NSLayoutConstraint.activate([
            volume9.topAnchor.constraint(equalTo: volume0.bottomAnchor, constant: innerSpasing),
            volume9.leadingAnchor.constraint(equalTo: volume8.trailingAnchor, constant: innerSpasing),
            volume9.heightAnchor.constraint(equalToConstant: heightContainer),
            volume9.widthAnchor.constraint(equalToConstant: widthContainer)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
