//
//  SettingsPopUp.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 10.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol SettingsPopUpProtocol : NSObjectProtocol{
    func dailyTargetChanged(value: Double)
    func dailyTrainingChanged(value: Double)
    func biologicalSexChanged(value: String)
    func weightChanged(value: Int)
}

protocol VolumesPopUpProtocol : NSObjectProtocol{
    func volumesChanged(value: Double)
}

class SettingsPopUp: UIView {
    
    weak var delegate: SettingsPopUpProtocol?
    weak var volumesDelegate: VolumesPopUpProtocol?
    var type: SettingsChangeType
    
    let cancelButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let nameLabel = UILabel()
    let pickerView = UIPickerView()
    
    let dailyTargetData = Array(stride(from: 500, through: 5000, by: 5))
    let dailyTrainingData = Array(stride(from: 50, through: 1500, by: 5))
    let containerData = Array(stride(from: 10, through: 1000, by: 5))
    let weightData = Array(stride(from: 10, through: 300, by: 1))
    let biologicalSexData: [String] = {
        var allBiologicalSex = [String]()
        for value in BiologicalSex.allCases {
            allBiologicalSex.append(value.rawValue)
        }
        return allBiologicalSex
    }()
    
    init(frame: CGRect, type: SettingsChangeType, name: String) {
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
            changeDailyTarget()
        case .changeTrainingTarget:
            changeTrainingTarget()
        case .changeContainerVolume:
            changeContainerVolume()
        case .changeBiologicalSex:
            changeBiologicalSex()
        case .changeWeight:
            changeWeight()
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
    
    private func createLabel() {
        nameLabel.textAlignment = .center
        nameLabel.textColor = .typographyLight()
        nameLabel.font = .bodyMedium()
    }
    
    private func createPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.mainDark(), forKeyPath: "textColor")
    }
    
    //Change daily target
    private func changeDailyTarget() {
        let dailyTarget = Int(UserDefaults.standard.double(forKey: "target"))
        guard let index = dailyTargetData.firstIndex(of: Int(dailyTarget)) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    //Change training target
    private func changeTrainingTarget() {
        let trainingTarget = Int(UserDefaults.standard.double(forKey: "training"))
        guard let index = dailyTrainingData.firstIndex(of: Int(trainingTarget)) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    //Change container volume
    private func changeContainerVolume() {
        guard let containerVolume = VolumesController.selectedContainer?.value else { return }
        guard let index = containerData.firstIndex(of: Int(containerVolume)) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    //Change biologicalSex
    private func changeBiologicalSex() {
        guard let biologicalSex = UserDefaults.standard.string(forKey: "biologicalSex") else { return }
        guard let index = biologicalSexData.firstIndex(of: biologicalSex) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    //Change weight
    private func changeWeight() {
        let weight = UserDefaults.standard.integer(forKey: "weight")
        guard let index = weightData.firstIndex(of: weight) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    @objc private func closeSettingsPopUp() {
        SwiftEntryKit.dismiss()
    }
    
    @objc private func saveDate() {
        let row = pickerView.selectedRow(inComponent: 0)
        
        switch type {
        case .changeDailyTarget:
            guard let volume = pickerView(pickerView, titleForRow: row, forComponent: 0)?.toDouble() else { return }
            delegate?.dailyTargetChanged(value: volume)
        case .changeTrainingTarget:
            guard let volume = pickerView(pickerView, titleForRow: row, forComponent: 0)?.toDouble() else { return }
            delegate?.dailyTrainingChanged(value: volume)
        case .changeContainerVolume:
            guard let volume = pickerView(pickerView, titleForRow: row, forComponent: 0)?.toDouble() else { return }
            volumesDelegate?.volumesChanged(value: volume)
        case .changeBiologicalSex:
            guard let value = pickerView(pickerView, titleForRow: row, forComponent: 0) else { return }
            delegate?.biologicalSexChanged(value: value)
        case .changeWeight:
            guard let value = pickerView(pickerView, titleForRow: row, forComponent: 0) else { return }
            delegate?.weightChanged(value: Int(value)!)
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
        
        print(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension SettingsPopUp: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .changeDailyTarget:
            return dailyTargetData.count
        case .changeTrainingTarget:
            return dailyTrainingData.count
        case .changeContainerVolume:
            return containerData.count
        case .changeBiologicalSex:
            return biologicalSexData.count
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
            return "\(dailyTrainingData[row])"
        case .changeContainerVolume:
            return "\(containerData[row])"
        case .changeBiologicalSex:
            return biologicalSexData[row]
        case .changeWeight:
            return "\(weightData[row])"
        }
    }
}
