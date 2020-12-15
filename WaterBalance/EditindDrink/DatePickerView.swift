//
//  DatePickerView.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 17.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol DatePickerViewProtocol : NSObjectProtocol{
    func dateChanged(date: Date)
}

class DatePickerView: UIView {
    
    weak var delegate: DatePickerViewProtocol? = nil
    
    let datePicker = UIDatePicker()
    let cancelButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    
    init(frame: CGRect, date: Date) {
        super.init(frame: frame)
        
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        setupConstraints()
        createButtons()
        createDatePicker(date: date)
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
        cancelButton.addTarget(self, action: #selector(closeDatePickerView), for: .touchUpInside)
        
        let saveImage = UIImage(named: "checkmark")
        saveButton.tintColor = .mainDark()
        saveButton.setImage(saveImage, for: .normal)
        saveButton.addTarget(self, action: #selector(saveDate), for: .touchUpInside)
    }
    
    private func createDatePicker(date: Date) {
        if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
        datePicker.date = date
        datePicker.setValue(UIColor.mainDark(), forKeyPath: "textColor")
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long

        let minDate = formatter.date(from: UserDefaults.standard.string(forKey: UserDefaultsServiceEnum.firstDate.rawValue)!)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = Date()
    }
    
    @objc private func closeDatePickerView() {
        SwiftEntryKit.dismiss()
    }
    
    @objc private func saveDate() {
        let date = datePicker.date
        delegate?.dateChanged(date: date)
        SwiftEntryKit.dismiss()
    }
    
    private func setupConstraints() {
        self.addSubview(cancelButton)
        self.addSubview(saveButton)
        self.addSubview(datePicker)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
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
