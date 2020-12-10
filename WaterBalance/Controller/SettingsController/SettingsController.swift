//
//  SettingsController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 20.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit

enum SettingsChangeType {
    case changeDailyTarget
    case changeTrainingTarget
    case changeContainerVolume
}

class SettingsController: UIViewController {
    
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
        
        tableView.register(SettingsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: SettingsTableViewHeader.reuseId)
        
        tableView.register(SettingsStandardCell.self, forCellReuseIdentifier: SettingsStandardCell.reuseId)
        tableView.register(SettingsSublabelCell.self, forCellReuseIdentifier: SettingsSublabelCell.reuseId)
        tableView.register(SettingsToggleCell.self, forCellReuseIdentifier: SettingsToggleCell.reuseId)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    private func showSettingsPopUpWithPickerView(type: SettingsChangeType) {
        let height = (view.frame.width / 2.4) + 22 + 11 + 50
        let settingsPopUp = SettingsPopUp(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height), type: type)
        settingsPopUp.delegate = self
        SwiftEntryKit.display(entry: settingsPopUp, using: EKAttributesPopUp.createAttributes())
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
    }
}
