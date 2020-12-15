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
}

protocol VolumesPopUpProtocol : NSObjectProtocol{
    func volumesChanged(value: Double)
}

class SettingsPopUp: UIView {
    
    weak var delegate: SettingsPopUpProtocol? = nil
    weak var volumesDelegate: VolumesPopUpProtocol? = nil
    var type: SettingsChangeType
    
    let cancelButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let pickerView = UIPickerView()
    
    let dailyTargetData = Array(stride(from: 500, through: 5000, by: 5))
    let dailyTrainingData = Array(stride(from: 50, through: 1500, by: 5))
    let containerData = Array(stride(from: 10, through: 1000, by: 5))
    
    init(frame: CGRect, type: SettingsChangeType) {
        self.type = type
        super.init(frame: frame)
        
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        createButtons()
        createPickerView()
        
        switch type {
        case .changeDailyTarget:
            changeDailyTarget()
        case .changeTrainingTarget:
            changeTrainingTarget()
        case .changeContainerVolume:
            changeContainerVolume()
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
        print(index)
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    @objc private func closeSettingsPopUp() {
        SwiftEntryKit.dismiss()
    }
    
    @objc private func saveDate() {
        let row = pickerView.selectedRow(inComponent: 0)
        guard let volume = pickerView(pickerView, titleForRow: row, forComponent: 0)?.toDouble() else { return }
        
        switch type {
        case .changeDailyTarget:
            delegate?.dailyTargetChanged(value: volume)
        case .changeTrainingTarget:
            delegate?.dailyTrainingChanged(value: volume)
        case .changeContainerVolume:
            volumesDelegate?.volumesChanged(value: volume)
        }
        SwiftEntryKit.dismiss()
    }
    
    private func setupConstraints() {
        self.addSubview(cancelButton)
        self.addSubview(saveButton)
        self.addSubview(pickerView)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            cancelButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            saveButton.heightAnchor.constraint(equalToConstant: 30)
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
extension SettingsPopUp: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .changeDailyTarget:
            return dailyTargetData.count
        case .changeTrainingTarget:
            return dailyTrainingData.count
        case .changeContainerVolume:
            return containerData.count
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
        }
    }
}
