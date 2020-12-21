//
//  StartController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 18.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class StartController: UIViewController {
    
    var trainingView: ViewForStartController!
    var dailyTargetView: ViewForStartController!
    var weightView: ViewForStartController!
    var healthView: ViewForStartController!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupBottomView()
        setupConstraints()
    }
    
    private func setupBottomView() {
        let trainingImageString = "training"
        let leftTrainingText = "Тренировка"
        trainingView = ViewForStartController(imageString: trainingImageString, leftText: leftTrainingText, rightText: "300 мл")
        trainingView.button.addTarget(self, action: #selector(trainingTapped), for: .touchUpInside)
        
        let dailyTargetImageString = "target"
        let dailyTargetText = "Дневная норма"
        dailyTargetView = ViewForStartController(imageString: dailyTargetImageString, leftText: dailyTargetText, rightText: "0 мл")
        dailyTargetView.button.addTarget(self, action: #selector(dailyTargetTapped), for: .touchUpInside)
        
        let weightImageString = "weight"
        let weightText = "Вес"
        weightView = ViewForStartController(imageString: weightImageString, leftText: weightText, rightText: "0 кг")
        weightView.button.addTarget(self, action: #selector(weightTapped), for: .touchUpInside)
        
        let healthImageString = "health"
        let healthText = "Apple Health"
        healthView = ViewForStartController(imageString: healthImageString, leftText: healthText, rightText: nil)
        healthView.toggle.isHidden = false
        healthView.toggle.addTarget(self, action: #selector(healthChanged), for: .valueChanged)
    }
    
    @objc private func trainingTapped() {
        print(123123123)
    }
    
    @objc private func dailyTargetTapped() {
        print(123123123)
    }
    
    @objc private func weightTapped() {
        print(123123123)
    }
    
    @objc private func healthChanged(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    private func setupConstraints() {
        trainingView.translatesAutoresizingMaskIntoConstraints = false
        dailyTargetView.translatesAutoresizingMaskIntoConstraints = false
        weightView.translatesAutoresizingMaskIntoConstraints = false
        healthView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trainingView)
        view.addSubview(dailyTargetView)
        view.addSubview(weightView)
        view.addSubview(healthView)

        NSLayoutConstraint.activate([
            trainingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            trainingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            trainingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150)
        ])
        
        NSLayoutConstraint.activate([
            dailyTargetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            dailyTargetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            dailyTargetView.bottomAnchor.constraint(equalTo: trainingView.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            weightView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            weightView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            weightView.bottomAnchor.constraint(equalTo: dailyTargetView.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            healthView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            healthView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            healthView.bottomAnchor.constraint(equalTo: weightView.topAnchor, constant: -10)
        ])
    }
}
