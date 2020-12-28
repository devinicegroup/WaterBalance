//
//  EditingController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 16.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit
import HealthKit

protocol EditingControllerProtocol : NSObjectProtocol{
    func deleteDrinkUp()
    func closeEditingController()
}

class EditingController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    weak var delegate: EditingControllerProtocol? = nil
    
    var drinkUp: DrinkUp!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        tableView.separatorColor = UIColor.clear
        tableView.register(EditingCell.self, forCellReuseIdentifier: EditingCell.reuseId)
    }
    
    private func setupNavigationController() {
        self.navigationController?.presentationController?.delegate = self
        navigationController?.navigationBar.tintColor = .mainDark()
        self.navigationItem.title = "Редактирование"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        
        let leftImage = UIImage(named: "trash")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(deleteDrinkUp))
        
        let rightImage = UIImage(named: "checkmark")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(saveDrinkUp))
    }
    
    @objc private func deleteDrinkUp() {
        HealthService.shared.deleteSamples(drinkUp: drinkUp)
        
        StorageService.shared.deleteObject(object: drinkUp)
        delegate?.deleteDrinkUp()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveDrinkUp() {
        delegate?.closeEditingController()
        dismiss(animated: true, completion: nil)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.closeEditingController()
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditingCell.reuseId, for: indexPath) as! EditingCell
        
        switch indexPath.row {
        case 0:
            let imageString = drinkUp.drink!.imageString
            let topText = "Напиток"
            let bottomText = drinkUp.drink!.nameForUser
            cell.configure(imageString: imageString, topText: topText, bottomText: bottomText)
        case 1:
            let imageString = "volume"
            let topText = "Объем"
            let bottomText = "\(drinkUp.volume) мл"
            cell.configure(imageString: imageString, topText: topText, bottomText: bottomText)
        case 2:
            let imageString = "calendar"
            let topText = "Дата"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy, HH:mm"
            let bottomText = formatter.string(from: drinkUp.time)
            cell.configure(imageString: imageString, topText: topText, bottomText: bottomText)
        case 3:
            let imageString = "target"
            let topText = "Эффективность"
            let bottomText = "\(drinkUp.hydrationVolume) мл"
            cell.configure(imageString: imageString, topText: topText, bottomText: bottomText)
        case 4:
            let imageString = "caffeine"
            let topText = "Кофеин"
            let bottomText = "\(Int(drinkUp.caffeine)) мг"
            cell.configure(imageString: imageString, topText: topText, bottomText: bottomText)
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let editingDrinkController = EditingDrinkController()
            editingDrinkController.currentDrink = drinkUp.drink
            editingDrinkController.delegate = self
            let navController = UINavigationController(rootViewController: editingDrinkController)
            present(navController, animated: true, completion: nil)
        case 1:
            guard let drinkName = drinkUp.drink?.nameForUser else { return }
            showAllert(with: drinkName, and: "Укажите кол-во выпитой жидкости") { (volume) in
                self.volumeChanged(volume: volume)
            }
        case 2:
            let height = (view.frame.width / 2.4) + 22 + 11 + 50
            let containerPopUp = DatePickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height), date: drinkUp.time)
            containerPopUp.delegate = self
            SwiftEntryKit.display(entry: containerPopUp, using: EKAttributesPopUp.createAttributes())
        default:
            break
        }
    }
}


// MARK: - EditingDrinkControllerProtocol
extension EditingController: EditingDrinkControllerProtocol, DatePickerViewProtocol {
    
    func drinkChanged(drink: Drink) {
        let hydrationVolume = drinkUp.volume * drink.hydration
        let caffeine = drinkUp.volume * drink.caffeine
        let (dietaryWaterId, dietaryCaffeineId) = updateDrinkUpInHealthStore(hydrationVolume: hydrationVolume, caffeine: caffeine, date: drinkUp.time)
        
        StorageService.shared.updateDrink(drinkUp: drinkUp, drink: drink, dietaryWaterId: dietaryWaterId ?? "", dietaryCaffeineId: dietaryCaffeineId ?? "")
        tableView.reloadData()
    }
    
    func dateChanged(date: Date) {
        let hydrationVolume = drinkUp.hydrationVolume
        let caffeine = drinkUp.caffeine
        let (dietaryWaterId, dietaryCaffeineId) = updateDrinkUpInHealthStore(hydrationVolume: hydrationVolume, caffeine: caffeine, date: date)

        StorageService.shared.updateDate(drinkUp: drinkUp, date: date, dietaryWaterId: dietaryWaterId ?? "", dietaryCaffeineId: dietaryCaffeineId ?? "")
        tableView.reloadData()
    }
    
    func volumeChanged(volume: Double) {
        let hydrationVolume = volume * drinkUp.drink!.hydration
        let caffeine = volume * drinkUp.drink!.caffeine
        let (dietaryWaterId, dietaryCaffeineId) = updateDrinkUpInHealthStore(hydrationVolume: hydrationVolume, caffeine: caffeine, date: drinkUp.time)

        StorageService.shared.updateVolume(drinkUp: drinkUp, volume: volume, dietaryWaterId: dietaryWaterId ?? "", dietaryCaffeineId: dietaryCaffeineId ?? "")
        tableView.reloadData()
    }
    
    
    private func updateDrinkUpInHealthStore(hydrationVolume: Double, caffeine: Double, date: Date) -> (dietaryWaterId: String?, dietaryCaffeineId: String?) {
        HealthService.shared.deleteSamples(drinkUp: drinkUp)
        
        var dietaryWaterId = ""
        var dietaryCaffeineId = ""
        
        let group = DispatchGroup()
        group.enter()
        HealthService.shared.saveDietaryWaterSample(volume: hydrationVolume, date: date) { (id) in
            if id != nil {
                dietaryWaterId = "\(id!)"
            }
            group.leave()
        }
        
        group.enter()
        if caffeine > 0 {
            print(caffeine)
            HealthService.shared.saveDietaryCaffeineSample(mg: caffeine, date: date) { (id) in
                if id != nil {
                    dietaryCaffeineId = "\(id!)"
                }
                group.leave()
            }
        } else {
            group.leave()
        }
        
        group.wait()
        return (dietaryWaterId, dietaryCaffeineId)
    }
}
