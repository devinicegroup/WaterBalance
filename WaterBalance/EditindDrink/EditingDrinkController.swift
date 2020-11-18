//
//  EditingDrinkController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 16.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import RealmSwift

protocol EditingDrinkControllerProtocol: NSObjectProtocol {
    func drinkChanged(drink: Drink)
}

class EditingDrinkController: UITableViewController {
    
    weak var delegate: EditingDrinkControllerProtocol? = nil
    
    var drinks: Results<Drink>!
    var currentDrink: Drink!
    var selectedIndexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        drinks = realm.objects(Drink.self)
        tableView.separatorColor = UIColor.clear
        tableView.register(EditingDrinkCell.self, forCellReuseIdentifier: EditingDrinkCell.reuseId)
        selectedIndexPath = IndexPath(row: currentDrink.id, section: 0)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.tintColor = .mainDark()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        self.navigationItem.title = "Выберите напиток"
        
        let leftImage = UIImage(named: "close")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(closeController))
    }
    
    @objc private func closeController() {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Table view data source
extension EditingDrinkController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditingDrinkCell.reuseId, for: indexPath) as! EditingDrinkCell
        let drink = drinks[indexPath.row]
        cell.configure(drink: drink)
        
        if drink.id == currentDrink.id {
            createAccessoryView(cell: cell)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let oldCell = tableView.cellForRow(at: selectedIndexPath) as? EditingDrinkCell
        oldCell?.accessoryView = nil
        selectedIndexPath = indexPath
        let newCell = tableView.cellForRow(at: indexPath) as! EditingDrinkCell
        createAccessoryView(cell: newCell)
        
        delegate?.drinkChanged(drink: drinks[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func createAccessoryView(cell: EditingDrinkCell) {
        let image = UIImage(named: "checkmark")?.withTintColor(.mainDark())
        let imageView = UIImageView(image: image)
        cell.accessoryView = imageView
    }
}
