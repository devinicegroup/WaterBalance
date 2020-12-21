//
//  StatisticsController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 20.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class StatisticsController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHightConstraint: NSLayoutConstraint!
    
    var segmentegControl: UISegmentedControl!
    let previousDatesButton = UIButton(type: .system)
    let nextDatesButton = UIButton(type: .system)
    let datesLabel = UILabel()
    let dayAverageLabel = UILabel()
    let allVolumeLabel = UILabel()
    let chartView = ChartView()
        
    let formatter = DateFormatter()
    var dates: [Date]!
    var drinksVolume = [StatisticVolume]()
    var allValue = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        getDrinksVolume()
        setVolumeLabeles()
        tableView.reloadData()
        chartView.setChartData(dates: dates)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.navigationItem.title = "Статистика"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        topViewHightConstraint.constant = 350
        
        let monday = Date.today().previous(.monday, considerToday: true)
        dates = Date.getDatesFor(date: monday.removeTimeStamp ?? Date.today(), days: 7)
        
        setupSegmentedControl()
        setupTopElements()
        setupTableView()
        chartView.setupChartView()
        chartView.setChartData(dates: dates)
        setupConstraints()
    }
    
    private func setupSegmentedControl() {
        let items = ["Неделя", "30 дней"]
        segmentegControl = UISegmentedControl(items: items)
        segmentegControl.selectedSegmentIndex = 0
        segmentegControl.backgroundColor = .mainWhite()
        fixBackgroundSegmentedControl(segmentegControl)
        
        let titleTextAttributesForNormal = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary(), NSAttributedString.Key.font: UIFont.bodyRegularMin1()]
        segmentegControl.setTitleTextAttributes(titleTextAttributesForNormal, for:.normal)
    
        let titleTextAttributesForSelected = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary(), NSAttributedString.Key.font: UIFont.bodyMediumMin1()]
        segmentegControl.setTitleTextAttributes(titleTextAttributesForSelected, for:.selected)
        
        segmentegControl.addTarget(self, action: #selector(countDaysDidChange), for: .valueChanged)
    }
    
    private func fixBackgroundSegmentedControl(_ segmentControl: UISegmentedControl) {
        DispatchQueue.main.async() {
            for i in 0...(segmentControl.numberOfSegments-1)  {
                segmentControl.subviews[i].isHidden = true
            }
        }
    }
    
    private func setupTopElements() {
        datesLabel.textColor = .typographyPrimary()
        datesLabel.font = .bodyMediumMin1()
        datesLabel.textAlignment = .center
        setDatesLabel()
        
        let leftImage = UIImage(named: "left")?.withTintColor(.mainDark()).withRenderingMode(.alwaysOriginal)
        previousDatesButton.setImage(leftImage, for: .normal)
        previousDatesButton.addTarget(self, action: #selector(previousDatesButtonTapped), for: .touchUpInside)
        
        let rightImage = UIImage(named: "right")?.withTintColor(.mainDark()).withRenderingMode(.alwaysOriginal)
        nextDatesButton.setImage(rightImage, for: .normal)
        nextDatesButton.addTarget(self, action: #selector(nextDatesButtonTapped), for: .touchUpInside)
        
        dayAverageLabel.textColor = .typographySecondary()
        dayAverageLabel.font = .bodyMediumMin2()
        
        allVolumeLabel.textColor = .typographySecondary()
        allVolumeLabel.font = .bodyMediumMin2()
        allVolumeLabel.textAlignment = .right
    }
    
    private func setVolumeLabeles() {
        var activeDates: [Date] = []
        
        dates.forEach { (date) in
            guard let date = date.removeTimeStamp else { return }
            if (date >= (UserDefaults.standard.object(forKey: UserDefaultsServiceEnum.firstDate.rawValue) as! Date).removeTimeStamp!) && date <= Date.today().removeTimeStamp! {
                activeDates.append(date)
            }
        }
        
        var dayAverage = 0.0
        if activeDates.count > 0 { dayAverage = (allValue / Double(activeDates.count)) / 1000 }
        dayAverageLabel.text = "Среднее за день: \(dayAverage.rounded(toPlaces: 2)) л"
        
        let allVolume = allValue / 1000
        allVolumeLabel.text = "Всего: \(allVolume.rounded(toPlaces: 2)) л"
    }
    
    private func setDatesLabel() {
        formatter.dateFormat = "dd MMM"
        let firstDate = formatter.string(from: dates.first!)
        let lastDate = formatter.string(from: dates.last!)
        datesLabel.text = "\(firstDate) - \(lastDate)"
    }
    
    @objc private func countDaysDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let date = dates.last ?? Date.today()
            let monday = date.previous(.monday, considerToday: true)
            didChangeDates(date: monday, count: 7)
        case 1:
            let date = dates.last ?? Date.today()
            didChangeDates(date: date, count: -30)
        default:
            break
        }
    }
    
    @objc private func previousDatesButtonTapped() {
        switch segmentegControl.selectedSegmentIndex {
        case 0:
            let date = dates.first ?? Date.today()
            let monday = date.previous(.monday, considerToday: true)
            didChangeDates(date: monday, count: 7)
        case 1:
            let date = dates.first ?? Date.today()
            didChangeDates(date: date, count: -30)
        default:
            break
        }
    }
    
    @objc private func nextDatesButtonTapped() {
        switch segmentegControl.selectedSegmentIndex {
        case 0:
            let date = dates.first ?? Date.today()
            let monday = date.next(.monday, considerToday: true)
            didChangeDates(date: monday, count: 7)
        case 1:
            let date = dates.last ?? Date.today()
            didChangeDates(date: date, count: 30)
        default:
            break
        }
    }
    
    private func didChangeDates(date: Date, count: Int) {
        dates = Date.getDatesFor(date: date, days: count)
        getDrinksVolume()
        setDatesLabel()
        setVolumeLabeles()
        ChartView.dates = dates
        chartView.setChartData(dates: dates)
        tableView.reloadData()
    }
    
    private func setupConstraints() {
        segmentegControl.translatesAutoresizingMaskIntoConstraints = false
        datesLabel.translatesAutoresizingMaskIntoConstraints = false
        nextDatesButton.translatesAutoresizingMaskIntoConstraints = false
        previousDatesButton.translatesAutoresizingMaskIntoConstraints = false
        dayAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        allVolumeLabel.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false

        topView.addSubview(segmentegControl)
        topView.addSubview(datesLabel)
        topView.addSubview(nextDatesButton)
        topView.addSubview(previousDatesButton)
        topView.addSubview(dayAverageLabel)
        topView.addSubview(allVolumeLabel)
        topView.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            segmentegControl.topAnchor.constraint(equalTo: topView.topAnchor, constant: 16),
            segmentegControl.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            segmentegControl.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            datesLabel.topAnchor.constraint(equalTo: segmentegControl.bottomAnchor, constant: 19),
            datesLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            datesLabel.widthAnchor.constraint(equalToConstant: 140)
        ])
        
        NSLayoutConstraint.activate([
            previousDatesButton.trailingAnchor.constraint(equalTo: datesLabel.leadingAnchor, constant: -27),
            previousDatesButton.centerYAnchor.constraint(equalTo: datesLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nextDatesButton.leadingAnchor.constraint(equalTo: datesLabel.trailingAnchor, constant: 27),
            nextDatesButton.centerYAnchor.constraint(equalTo: datesLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayAverageLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            dayAverageLabel.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 16),
            dayAverageLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 1.85)
        ])
        
        NSLayoutConstraint.activate([
            allVolumeLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            allVolumeLabel.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 16),
            allVolumeLabel.leadingAnchor.constraint(equalTo: dayAverageLabel.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: dayAverageLabel.bottomAnchor, constant: 0),
            chartView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            chartView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0)
        ])
    }
     
    func getDrinksVolume() {
        guard !dates.isEmpty else { return }
        drinksVolume = []
        allValue = 0
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
        tableView.isUserInteractionEnabled = false
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
