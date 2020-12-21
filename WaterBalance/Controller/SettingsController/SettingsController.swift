//
//  SettingsController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 20.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit
import MessageUI

enum SettingsChangeType {
    case changeDailyTarget
    case changeTrainingTarget
    case changeContainerVolume
}

class SettingsController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var tableView: UITableView!
    var selectedIndexPath: IndexPath!
    
    var settingsData: [[SettingsModel]]!
    var settings = Settings()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsData = settings.settingsData
        
        setupTableView()
        setupConstraints()

        view.backgroundColor = .systemIndigo
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.backgroundColor = .mainWhite()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 0)
//        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        
        tableView.register(SettingsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: SettingsTableViewHeader.reuseId)
        
        tableView.register(SettingsStandardCell.self, forCellReuseIdentifier: SettingsStandardCell.reuseId)
        tableView.register(SettingsSublabelCell.self, forCellReuseIdentifier: SettingsSublabelCell.reuseId)
        tableView.register(SettingsToggleCell.self, forCellReuseIdentifier: SettingsToggleCell.reuseId)
    }
    
    private func showSettingsPopUpWithPickerView(type: SettingsChangeType) {
        let height = (view.frame.width / 2.4) + 22 + 11 + 50
        let settingsPopUp = SettingsPopUp(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height), type: type)
        settingsPopUp.delegate = self
        SwiftEntryKit.display(entry: settingsPopUp, using: EKAttributesPopUp.createAttributes())
    }
    
    private func shareApp() {
        if let urlStr = URL(string: "https://www.google.ru/") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }

            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["s.polivanov@icloud.com"])
            mail.setSubject("Водный баланс")
            mail.setMessageBody("\(AboutApp().createSupportMessage())", isHTML: false)
            present(mail, animated: true)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataForCell = settingsData[indexPath.section][indexPath.row]
        
        switch dataForCell.type {
        case .standard:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsStandardCell.reuseId, for: indexPath) as! SettingsStandardCell
            cell.configure(with: dataForCell)
            return cell
        case .sublabel:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSublabelCell.reuseId, for: indexPath) as! SettingsSublabelCell
            cell.configure(with: dataForCell)
            return cell
        case .toggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsToggleCell.reuseId, for: indexPath) as! SettingsToggleCell
            cell.configure(with: dataForCell)
            return cell
        case .chevron:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsStandardCell.reuseId, for: indexPath) as! SettingsStandardCell
            cell.configure(with: dataForCell)
            createAccessoryView(cell: cell)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = SettingsTableViewHeader()
        
        switch section {
        case 0: headerView.configure(name: settings.headerTitles[section])
        case 1: headerView.configure(name: settings.headerTitles[section])
        case 2: headerView.configure(name: settings.headerTitles[section])
        default:
            return nil
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            RateService.showRatesController(delay: false)
        case IndexPath(row: 1, section: 0):
            shareApp()
        case IndexPath(row: 2, section: 0):
            sendEmail()
        case IndexPath(row: 3, section: 2):
            self.navigationController?.pushViewController(VolumesController(), animated: true)
        case IndexPath(row: 4, section: 2):
            showSettingsPopUpWithPickerView(type: .changeDailyTarget)
        case IndexPath(row: 5, section: 2):
            showSettingsPopUpWithPickerView(type: .changeTrainingTarget)
        default:
            print(indexPath)
            break
        }
    }
    
    private func createAccessoryView(cell: SettingsStandardCell) {
        let image = UIImage(named: "right")?.withTintColor(.typographySecondary())
        let imageView = UIImageView(image: image)
        cell.accessoryView = imageView
    }
}


//MARK: - SettingsPopUpProtocol
extension SettingsController: SettingsPopUpProtocol {
    func dailyTargetChanged(value: Double) {
        UserDefaults.standard.set(value, forKey: "target")
        let dailyTarget = StorageService.shared.getDailyTarget(date: Date()).first
        let newDailyTarget = DailyTarget(target: value, date: Date())
        
        if dailyTarget != nil {
            StorageService.shared.updateDailyTarget(dailyTarget: dailyTarget!, volume: value)
        } else {
            StorageService.shared.saveDailyTarget(dailyTarget: newDailyTarget)
        }
        
        settingsData[selectedIndexPath.section][selectedIndexPath.row].subtitle = "\(Int(value))"
        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
    }
    
    func dailyTrainingChanged(value: Double) {
        UserDefaults.standard.set(value, forKey: "training")
        settingsData[selectedIndexPath.section][selectedIndexPath.row].subtitle = "\(Int(value))"
        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        
        guard let training = StorageService.shared.getTraining(date: Date()).first else { return }
        StorageService.shared.updateTraining(training: training, volume: value)
    }
}
