//
//  StartController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 18.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit

enum StartChangeType {
    case changeDailyTarget
    case changeTrainingTarget
    case changeWeight
}

enum BiologicalSex: String {
  case male = "Мужской"
  case female = "Женский"
}

class StartController: UIViewController {
    
    var trainingView: ViewForStartController!
    var dailyTargetView: ViewForStartController!
    var weightView: ViewForStartController!
    var healthView: ViewForStartController!
    
    let forwardButton = UIButton()
    let maleButton = UIButton()
    let femaleButton = UIButton()
    let nameLabel = UILabel()
    let mainIconImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupBottomView()
        setupSexButtons()
        setupLabel()
        setupImageView()
        setupForwardButton()
        setupConstraints()
        
        if let biologicalSex = UserDefaults.standard.string(forKey: "biologicalSex") {
            if biologicalSex == BiologicalSex.male.rawValue {
                maleButton.layer.borderWidth = 2
            } else {
                femaleButton.layer.borderWidth = 2
            }
        }
    }
    
    private func setupBottomView() {
        let trainingImageString = "training"
        let leftTrainingText = "Тренировка"
        var trainingTarget = UserDefaults.standard.double(forKey: "training")
        if trainingTarget == 0.0 { trainingTarget = 300 }
        trainingView = ViewForStartController(imageString: trainingImageString, leftText: leftTrainingText, rightText: "\(Int(trainingTarget)) мл")
        trainingView.button.addTarget(self, action: #selector(trainingTapped), for: .touchUpInside)
        
        let dailyTargetImageString = "target"
        let dailyTargetText = "Дневная норма"
        let dailyTarget = UserDefaults.standard.double(forKey: "target")
        dailyTargetView = ViewForStartController(imageString: dailyTargetImageString, leftText: dailyTargetText, rightText: "\(Int(dailyTarget)) мл")
        dailyTargetView.button.addTarget(self, action: #selector(dailyTargetTapped), for: .touchUpInside)
        
        let weightImageString = "weight"
        let weightText = "Вес"
        var weight = UserDefaults.standard.integer(forKey: "weight")
        if weight == 0 { weight = 50 }
        weightView = ViewForStartController(imageString: weightImageString, leftText: weightText, rightText: "\(weight) кг")
        weightView.button.addTarget(self, action: #selector(weightTapped), for: .touchUpInside)
        
        let healthImageString = "health"
        let healthText = "Apple Health"
        healthView = ViewForStartController(imageString: healthImageString, leftText: healthText, rightText: nil)
        healthView.toggle.isHidden = false
        healthView.toggle.addTarget(self, action: #selector(healthChanged), for: .valueChanged)
    }
    
    private func setupForwardButton() {
        forwardButton.backgroundColor = .blue()
        forwardButton.layer.cornerRadius = 35
        forwardButton.clipsToBounds = true
        forwardButton.setImage(UIImage(named: "forward"), for: .normal)
        forwardButton.addTarget(self, action: #selector(forwardTapped), for: .touchUpInside)
        checkForwardButton()
    }
    
    private func setupSexButtons() {
        maleButton.backgroundColor = .mainLight()
        maleButton.layer.cornerRadius = 35
        maleButton.clipsToBounds = true
        maleButton.tag = 0
        maleButton.layer.borderColor = UIColor.blue().cgColor
        maleButton.setImage(UIImage(named: "male"), for: .normal)
        maleButton.addTarget(self, action: #selector(sexTapped), for: .touchUpInside)
        
        femaleButton.backgroundColor = .mainLight()
        femaleButton.layer.cornerRadius = 35
        femaleButton.clipsToBounds = true
        femaleButton.tag = 1
        femaleButton.layer.borderColor = UIColor.pink().cgColor
        femaleButton.setImage(UIImage(named: "female"), for: .normal)
        femaleButton.addTarget(self, action: #selector(sexTapped), for: .touchUpInside)
    }
    
    private func setupLabel() {
        nameLabel.textAlignment = .center
        nameLabel.font = .header1()
        nameLabel.textColor = .typographyPrimary()
        nameLabel.text = "Водный баланс"
    }
    
    private func setupImageView() {
        mainIconImageView.image = UIImage(named: "mainIcon")
        mainIconImageView.contentMode = .scaleAspectFit
    }
    
    private func calculateDailyTarget() {
        guard let biologicalSex = UserDefaults.standard.string(forKey: "biologicalSex") else { return }
        guard let currentWeight = weightView.rightLabel.text?.filter("0123456789.".contains).toDouble() else { return }
        var sexCoefficient = 1.0
        if biologicalSex == BiologicalSex.male.rawValue { sexCoefficient = 1.1}
        
        let dailyTarget = 30 * currentWeight * sexCoefficient + 50
        let dailyTargetRound = Int(dailyTarget) / 5 * 5
        dailyTargetView.rightLabel.text = "\(dailyTargetRound) мл"
        UserDefaults.standard.set(Double(dailyTargetRound), forKey: "target")
        checkForwardButton()
    }
    
    private func checkForwardButton() {
        guard let currentDailyTarget = dailyTargetView.rightLabel.text?.filter("0123456789.".contains) else { return }
        if currentDailyTarget != "0" {
            forwardButton.isEnabled = true
            forwardButton.alpha = 1
        } else {
            forwardButton.isEnabled = false
            forwardButton.alpha = 0.3
        }
    }
    
    @objc private func forwardTapped() {
        print(123123123)
    }
    
    @objc private func trainingTapped() {
        guard let name = dailyTargetView.leftLabel.text else { return }
        guard let currentTrainingTarget = trainingView.rightLabel.text?.filter("0123456789.".contains) else { return }
        showSettingsPopUpWithPickerView(type: .changeTrainingTarget, name: name, currentValue: currentTrainingTarget)
    }
    
    @objc private func dailyTargetTapped() {
        guard let name = dailyTargetView.leftLabel.text else { return }
        guard let currentDailyTarget = dailyTargetView.rightLabel.text?.filter("0123456789.".contains) else { return }
        showSettingsPopUpWithPickerView(type: .changeDailyTarget, name: name, currentValue: currentDailyTarget)
    }
    
    @objc private func weightTapped() {
        guard let name = weightView.leftLabel.text else { return }
        guard let currentWeight = weightView.rightLabel.text?.filter("0123456789.".contains) else { return }
        showSettingsPopUpWithPickerView(type: .changeWeight, name: name, currentValue: currentWeight)
    }
    
    @objc private func healthChanged(_ sender: UISwitch) {
        print(sender.isOn)
        if sender.isOn {
            HealthService.shared.authorizeHealthKit { (authorized, error) in
                guard authorized else {
                    let baseMessage = "HealthKit Authorization Failed"
                    if let error = error {
                        print("\(baseMessage). Reason: \(error.localizedDescription)")
                    } else {
                        print(baseMessage)
                    }
                    return
                }
                
                print("HealthKit Successfully Authorized.")
            }
        }
    }
    
    @objc private func sexTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            maleButton.backgroundColor = .mainWhite()
            femaleButton.backgroundColor = .mainLight()
            maleButton.layer.borderWidth = 2
            femaleButton.layer.borderWidth = 0
            UserDefaults.standard.set(BiologicalSex.male.rawValue, forKey: "biologicalSex")
        case 1:
            maleButton.backgroundColor = .mainLight()
            femaleButton.backgroundColor = .mainWhite()
            maleButton.layer.borderWidth = 0
            femaleButton.layer.borderWidth = 2
            UserDefaults.standard.set(BiologicalSex.female.rawValue, forKey: "biologicalSex")
        default:
            break
        }
        calculateDailyTarget()
    }
    
    private func showSettingsPopUpWithPickerView(type: StartChangeType, name: String, currentValue: String) {
        let height = (view.frame.width / 2.4) + 22 + 11 + 50
        let startPopUp = StartPopUp(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height), type: type, name: name, currentValue: currentValue)
        startPopUp.delegate = self
        SwiftEntryKit.display(entry: startPopUp, using: EKAttributesPopUp.createAttributes())
    }
    
    private func setupConstraints() {
        trainingView.translatesAutoresizingMaskIntoConstraints = false
        dailyTargetView.translatesAutoresizingMaskIntoConstraints = false
        weightView.translatesAutoresizingMaskIntoConstraints = false
        healthView.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        mainIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trainingView)
        view.addSubview(dailyTargetView)
        view.addSubview(weightView)
        view.addSubview(healthView)
        view.addSubview(forwardButton)
        view.addSubview(maleButton)
        view.addSubview(femaleButton)
        view.addSubview(nameLabel)
        view.addSubview(mainIconImageView)
        
        NSLayoutConstraint.activate([
            forwardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.view.frame.height/15),
            forwardButton.heightAnchor.constraint(equalToConstant: 70),
            forwardButton.widthAnchor.constraint(equalToConstant: 70),
            forwardButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            trainingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            trainingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            trainingView.bottomAnchor.constraint(equalTo: forwardButton.topAnchor, constant: -20)
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
        
        NSLayoutConstraint.activate([
            maleButton.bottomAnchor.constraint(equalTo: healthView.topAnchor, constant: -30),
            maleButton.heightAnchor.constraint(equalToConstant: 70),
            maleButton.widthAnchor.constraint(equalToConstant: 70),
            maleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -70)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.bottomAnchor.constraint(equalTo: healthView.topAnchor, constant: -30),
            femaleButton.heightAnchor.constraint(equalToConstant: 70),
            femaleButton.widthAnchor.constraint(equalToConstant: 70),
            femaleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 70)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height/10),
            nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        if screenHeight/screenWidth > 2 {
            NSLayoutConstraint.activate([
                mainIconImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
                mainIconImageView.bottomAnchor.constraint(equalTo: maleButton.topAnchor, constant: -30),
                mainIconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                mainIconImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
                mainIconImageView.bottomAnchor.constraint(equalTo: maleButton.topAnchor, constant: 0),
                mainIconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        }
    }
}


//MARK: - StartPopUpProtocol
extension StartController: StartPopUpProtocol {
    func dailyTrainingChanged(value: Double) {
        trainingView.rightLabel.text = "\(Int(value)) мл"
        UserDefaults.standard.set(value, forKey: "training")
    }
    
    func dailyTargetChanged(value: Double) {
        dailyTargetView.rightLabel.text = "\(Int(value)) мл"
        UserDefaults.standard.set(value, forKey: "target")
    }
    
    func weightChanged(value: Int) {
        weightView.rightLabel.text = "\(value) кг"
        UserDefaults.standard.set(value, forKey: "weight")
        calculateDailyTarget()
    }
}
