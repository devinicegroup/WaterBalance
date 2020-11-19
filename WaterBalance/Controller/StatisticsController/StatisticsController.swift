//
//  StatisticsController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 20.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import RealmSwift

struct StatisticVolume {
    let name: String
    let nameForUser: String
    let imageString: String
    var caffeine: Double
    var volume: Double
    var hydrationVolume: Double
}

class StatisticsController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHightConstraint: NSLayoutConstraint!
    
    var dates: [Date]!
    var drinksVolume = [StatisticVolume]()
    var allValue = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.navigationItem.title = "Статистика"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        dates = Date.getDatesFor(date: Date(), days: -7)
        getDrinksVolume()
        setupTableView()
    }
     
    func getDrinksVolume() {
        guard !dates.isEmpty else { return }
        let drinks = StorageService.shared.getDrinks()
        
        drinks.forEach { (drink) in
            let drinkUps = StorageService.shared.getDataForOneDrink(from: dates.first!, to: dates.last!, drink: drink)
            if drinkUps.count != 0 {
                addDrinksVolume(drinkUps: drinkUps)
            }
        }
        sortedArray()
    }
    
    func addDrinksVolume(drinkUps: Results<DrinkUp>) {
        guard let drink = drinkUps.first!.drink else { return }
        var drinkVolume = StatisticVolume(name: drink.name, nameForUser: drink.nameForUser, imageString: drink.imageString, caffeine: 0, volume: 0, hydrationVolume: 0)
        drinkUps.forEach { (drinkUp) in
            drinkVolume.caffeine += drinkUp.caffeine
            drinkVolume.volume += drinkUp.volume
            drinkVolume.hydrationVolume += drinkUp.hydrationVolume
            allValue += drinkUp.volume
        }
        drinksVolume.append(drinkVolume)
    }
    
    func sortedArray() {
        drinksVolume.sort {
            $0.volume > $1.volume
        }
    }
    
    func setupTableView() {
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.reuseId)
        tableView.separatorColor = UIColor.clear
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize", object is UITableView, let newValue = change?[.newKey] else { return }
        let newSize = newValue as! CGSize
        tableViewHightConstraint.constant = newSize.height
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension StatisticsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksVolume.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.reuseId, for: indexPath) as! StatisticsCell
        let drinkVolume = drinksVolume[indexPath.row]
        let percent = drinkVolume.volume / allValue
        cell.configure(with: drinkVolume, percent: percent)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
