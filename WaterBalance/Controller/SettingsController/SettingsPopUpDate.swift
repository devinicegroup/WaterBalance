//
//  SettingsPopUpDate.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 28.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol SettingsDatePopUpProtocol: NSObjectProtocol {
    func startDateChanges(date: Date)
    func endDateChanges(date: Date)
    func timeIntervalChanges(timeInterval: TimeInterval)
}

enum DateNotificationsEnum: String {
    case startDate = "startDate"
    case endDate = "endDate"
    case dateInterval = "dateInterval"
    case stopNotification = "stopNotification"
}

class SettingsPopUpDate: UIView {
    
    weak var delegate: SettingsDatePopUpProtocol?
    var type: SettingsChangeDateType
    
    let cancelButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let nameLabel = UILabel()
    let datePicker = UIDatePicker()
    
    let dateFormatter = DateFormatter()
    
    init(frame: CGRect, type: SettingsChangeDateType, name: String) {
        self.type = type
        super.init(frame: frame)
        
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        nameLabel.text = name
        
        createButtons()
        createLabel()
        createDatePicker()
        
        switch type {
        case .startDate:
            changeStartDate()
        case .endDate:
            changeEndDate()
        case .timeInterval:
            changeTimeInterval()
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
    
    private func createDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.setValue(UIColor.mainDark(), forKeyPath: "textColor")
        
//        guard let minDate = UserDefaults.standard.object(forKey: UserDefaultsServiceEnum.firstDate.rawValue) as? Date else { return }
//        datePicker.minimumDate = minDate
//        datePicker.maximumDate = Date()
    }
    
    //Change start date
    private func changeStartDate() {
        dateFormatter.dateFormat = "HH:mm"
        guard let stringDate = UserDefaults.standard.string(forKey: DateNotificationsEnum.startDate.rawValue) else { return }
        guard let startDateNotification = dateFormatter.date(from: stringDate) else { return }
        
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 10
        datePicker.date = startDateNotification
    }
    
    //Change end date
    private func changeEndDate() {
        dateFormatter.dateFormat = "HH:mm"
        guard let stringDate = UserDefaults.standard.string(forKey: DateNotificationsEnum.endDate.rawValue) else { return }
        guard let endDateNotification = dateFormatter.date(from: stringDate) else { return }
        
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 10
        datePicker.date = endDateNotification
    }
    
    //Change time interval
    private func changeTimeInterval() {
        datePicker.datePickerMode = .countDownTimer
        datePicker.minuteInterval = 15
        datePicker.countDownDuration = UserDefaults.standard.double(forKey: DateNotificationsEnum.dateInterval.rawValue)
    }
    
    @objc private func closeSettingsPopUp() {
        SwiftEntryKit.dismiss()
    }
    
    @objc private func saveDate() {
        let date = datePicker.date
        switch type {
        case .startDate:
            delegate?.startDateChanges(date: date)
        case .endDate:
            delegate?.endDateChanges(date: date)
        case .timeInterval:
            delegate?.timeIntervalChanges(timeInterval: datePicker.countDownDuration)
        }
        SwiftEntryKit.dismiss()
    }
    
    private func setupConstraints() {
        self.addSubview(cancelButton)
        self.addSubview(saveButton)
        self.addSubview(datePicker)
        self.addSubview(nameLabel)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            datePicker.topAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
