//
//  StartPopUp.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 22.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol StartPopUpProtocol: NSObjectProtocol {
    func dailyTargetChanged(value: Double)
    func dailyTrainingChanged(value: Double)
    func weightChanged(value: Int)
}

class StartPopUp: UIView {
    
    weak var delegate: StartPopUpProtocol?
    var type: StartChangeType
    
    let cancelButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let nameLabel = UILabel()
    let pickerView = UIPickerView()
    
    let weightData = Array(stride(from: 10, through: 300, by: 1))
    let dailyTargetData = Array(stride(from: 500, through: 5000, by: 5))
    let trainingData = Array(stride(from: 50, through: 1500, by: 5))
    
    init(frame: CGRect, type: StartChangeType, name: String, currentValue: String) {
        self.type = type
        super.init(frame: frame)
        
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        nameLabel.text = name
        
        createButtons()
        createPickerView()
        createLabel()

        switch type {
        case .changeDailyTarget:
            changeDailyTarget(currentDailyTarget: currentValue)
        case .changeTrainingTarget:
            changeTrainingTarget(currentTrainingTarget: currentValue)
        case .changeWeight:
            changeWeight(currentWeight: currentValue)
        }

        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func createButtons() {
        let cancelImage = UIImage(named: "close")
        cancelButton.tintColor = .mainDark()
        cancelButton.setImage(cancelImage, for: .normal)
        cancelButton.addTarget(self, action: #selector(closeSettingsPopUp), for: .touchUpInside)
        
        let saveImage = UIImage(named: "checkmark")
        saveButton.tintColor = .mainDark()
        saveButton.setImage(saveImage, for: .normal)
        saveButton.addTarget(self, action: #selector(saveDate), for: .touchUpInside)
    }
    
    private func createPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.mainDark(), forKeyPath: "textColor")
    }
    
    private func createLabel() {
        nameLabel.textAlignment = .center
        nameLabel.textColor = .typographyLight()
        nameLabel.font = .bodyMedium()
    }
    
    private func changeWeight(currentWeight: String) {
        guard let weight = Int(currentWeight) else { return }
        guard let index = weightData.firstIndex(of: weight) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    private func changeDailyTarget(currentDailyTarget: String) {
        guard var dailyTarget = Int(currentDailyTarget) else { return }
        if dailyTarget == 0 { dailyTarget = 1500}
        guard let index = dailyTargetData.firstIndex(of: dailyTarget) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    private func changeTrainingTarget(currentTrainingTarget: String) {
        guard let trainingTarget = Int(currentTrainingTarget) else { return }
        guard let index = trainingData.firstIndex(of: trainingTarget) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    @objc private func closeSettingsPopUp() {
        SwiftEntryKit.dismiss()
    }
    
    @objc private func saveDate() {
        let row = pickerView.selectedRow(inComponent: 0)
        
        switch type {
        case .changeDailyTarget:
            guard let dailyTargetString = pickerView(pickerView, titleForRow: row, forComponent: 0), let dailyTarget = dailyTargetString.toDouble() else { return }
            delegate?.dailyTargetChanged(value: dailyTarget)
        case .changeTrainingTarget:
            guard let trainingTargetString = pickerView(pickerView, titleForRow: row, forComponent: 0), let trainingTarget = trainingTargetString.toDouble() else { return }
            delegate?.dailyTrainingChanged(value: trainingTarget)
        case .changeWeight:
            guard let weightString = pickerView(pickerView, titleForRow: row, forComponent: 0), let weight = Int(weightString) else { return }
            delegate?.weightChanged(value: weight)
        }
        
        SwiftEntryKit.dismiss()
    }
    
    private func setupConstraints() {
        self.addSubview(cancelButton)
        self.addSubview(saveButton)
        self.addSubview(nameLabel)
        self.addSubview(pickerView)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: self.frame.width/3),
            cancelButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: self.frame.width/3),
            saveButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension StartPopUp: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .changeDailyTarget:
            return dailyTargetData.count
        case .changeTrainingTarget:
            return trainingData.count
        case .changeWeight:
            return weightData.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type {
        case .changeDailyTarget:
            return "\(dailyTargetData[row])"
        case .changeTrainingTarget:
            return "\(trainingData[row])"
        case .changeWeight:
            return "\(weightData[row])"
        }
    }
}
