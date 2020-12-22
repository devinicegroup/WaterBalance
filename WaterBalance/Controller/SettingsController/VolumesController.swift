//
//  VolumesController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 09.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit

class VolumesController: UITableViewController {
    
    var containers = Container.containers
    static var selectedContainer: Container?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containers.removeLast()
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(SettingsSublabelCell.self, forCellReuseIdentifier: SettingsSublabelCell.reuseId)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 0)
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        view.backgroundColor = .mainWhite()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        self.navigationItem.title = "Объемы"
        self.navigationController?.navigationBar.tintColor = .typographySecondary()
        if screenHeight/screenWidth > 2 {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        }
    }
}


// MARK: - Table view data source
extension VolumesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSublabelCell.reuseId, for: indexPath) as! SettingsSublabelCell
        let container = containers[indexPath.row]
        cell.configure(with: container)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        VolumesController.selectedContainer = containers[indexPath.row]
        let name = containers[indexPath.row].nameForUser
        showSettingsPopUpWithPickerView(type: .changeContainerVolume, name: name)
    }
    
    private func showSettingsPopUpWithPickerView(type: SettingsChangeType, name: String) {
        let height = (view.frame.width / 2.4) + 22 + 11 + 50
        let settingsPopUp = SettingsPopUp(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height), type: type, name: name)
        settingsPopUp.volumesDelegate = self
        SwiftEntryKit.display(entry: settingsPopUp, using: EKAttributesPopUp.createAttributes())
    }
}


//MARK: - SettingsPopUpProtocol
extension VolumesController: VolumesPopUpProtocol {
    func volumesChanged(value: Double) {
        guard var updateContainer = VolumesController.selectedContainer else { return}
        updateContainer.value = value
        
        UserDefaults.standard.set(value, forKey: updateContainer.name)
        containers[updateContainer.id] = updateContainer
        Container.containers[updateContainer.id] = updateContainer
        
        let indexPath = IndexPath(row: updateContainer.id, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
