//
//  MyProgressView.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 19.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class MyProgressView: UIView {
    
    var bgView: UIView!
    var fgView: UIView!
    
    init(width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        fgView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: height))
    }
    
    func configure(width: CGFloat) {
        bgView.backgroundColor = .mainWhite()
        fgView.backgroundColor = .blue()
        setupConstraints(width: width)
        
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func setupConstraints(width: CGFloat) {
        addSubview(bgView)
        bgView.addSubview(fgView)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        fgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fgView.topAnchor.constraint(equalTo: self.topAnchor),
            fgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fgView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            fgView.widthAnchor.constraint(equalToConstant: width)
        ])
        
        UIView.animate(withDuration: 2) {
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
