//
//  HistoryController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 20.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class HistoryController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHightConstraint: NSLayoutConstraint!
    
    let labelTableViewIsEmpty = UILabel()
    var dates: [Date]!
    var calendar: FSCalendar!
    var formatter = DateFormatter()
    var drinkUpsForCalendar = [Results<DrinkUp>]()
    var drinkUps = [Results<DrinkUp>]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.reloadData()
        calendar.reloadData()
        labelIsHidden()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationController()
        
        dates = Date.getDatesForMonth(date: Date())
        drinkUpsForCalendar = StorageService.shared.getDataForMonth(date: Date())
        drinkUps = StorageService.shared.getDataForMonth(date: Date()).reversed()
        setupCalendar()
        setupTableView()
        setupLabel()
    }
    
    private func setupNavigationController() {
        self.navigationItem.title = "История"
        if screenHeight/screenWidth > 2 {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        }
    }
    
    func setupCalendar() {
        let width = view.bounds.width
        let hight = (width / 7) * 6
        topViewHightConstraint.constant = hight
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: width, height: hight))
        //calendar.locale = Locale(identifier: "ru_Ru")
        calendar.firstWeekday = 2
        calendar.delegate = self
        calendar.dataSource = self
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.reuseId)
        changeNavTitle()
        
        calendar.appearance.titleFont = .bodyRegular()
        calendar.appearance.weekdayFont = .bodyMediumMin3()
        calendar.appearance.caseOptions = .weekdayUsesUpperCase
        calendar.appearance.weekdayTextColor = .typographyPrimary()
        calendar.appearance.titleDefaultColor = .typographySecondary()
        calendar.appearance.titlePlaceholderColor = .typographyLight()
        calendar.appearance.todayColor = .mainSecondary()
        calendar.appearance.selectionColor = .gray()
        calendar.headerHeight = 0
        topView.addSubview(calendar)
    }
    
    func setupTableView() {
        tableView.register(DrinkUpCell.self, forCellReuseIdentifier: DrinkUpCell.reuseId)
        tableView.register(HistoryTableViewHeader.self, forHeaderFooterViewReuseIdentifier: HistoryTableViewHeader.reuseId)
        tableView.separatorColor = UIColor.clear
    }
    
    func setupLabel() {
        labelTableViewIsEmpty.text = "Нет записей за данный период времени"
        labelTableViewIsEmpty.numberOfLines = 0
        labelTableViewIsEmpty.textAlignment = .center
        labelTableViewIsEmpty.font = .bodyMedium()
        labelTableViewIsEmpty.textColor = .typographySecondary()
        labelIsHidden()
        
        labelTableViewIsEmpty.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelTableViewIsEmpty)
        
        NSLayoutConstraint.activate([
            labelTableViewIsEmpty.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 32),
            labelTableViewIsEmpty.widthAnchor.constraint(equalToConstant: tableView.frame.width - 120),
            labelTableViewIsEmpty.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
    
    func labelIsHidden() {
        var tableIsEmpty = true
        drinkUps.forEach { (result) in
            if !result.isEmpty { tableIsEmpty = false }
        }
        
        if tableIsEmpty {
            labelTableViewIsEmpty.isHidden = false
        } else {
            labelTableViewIsEmpty.isHidden = true
        }
    }
    
    func changeNavTitle() {
        formatter.dateFormat = "LLLL yyyy"
        //formatter.locale = Locale(identifier: "ru_Ru")
        let date = formatter.string(from: calendar.currentPage).capitalizingFirstLetter()
        self.navigationItem.title = date
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize", object is UITableView, let newValue = change?[.newKey] else { return }
        let newSize = newValue as! CGSize
        tableViewHightConstraint.constant = newSize.height
    }
    
    func countVolume(for section: Int, from: [Results<DrinkUp>]) -> Double {
        var volume = 0.0
        from[section].forEach { (drinkUp) in
            volume += drinkUp.hydrationVolume
        }
        return volume
    }
    
}


//MARK: - FSCalendarDelegate, FSCalendarDataSource
extension HistoryController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.reuseId, for: date, at: position) as! CalendarCell
        
        formatter.dateFormat = "dd MMMM yyyy"
        
        for (index, dateFromArray) in dates.enumerated() {
            if formatter.string(from: dateFromArray) == formatter.string(from: date) {
                if !drinkUpsForCalendar[index].isEmpty {
                    if !drinkUpsForCalendar[index].isEmpty {
                        let volume = countVolume(for: index, from: drinkUpsForCalendar)
                        cell.configure(with: volume, date: dateFromArray)
                    }
                } else {
                    cell.configure(with: 0, date: dateFromArray)
                }
            }
        }
        return cell
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        if calendar.selectedDate != nil {
            calendar.deselect(calendar.selectedDate!)
        }
        dates = Date.getDatesForMonth(date: calendar.currentPage)
        drinkUpsForCalendar = StorageService.shared.getDataForMonth(date: calendar.currentPage)
        drinkUps = StorageService.shared.getDataForMonth(date: calendar.currentPage).reversed()
        changeNavTitle()
        self.calendar.reloadData()
        tableView.reloadData()
        labelIsHidden()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMMM-yyyy"
        drinkUps = StorageService.shared.getDataForDay(date: date)
        tableView.reloadData()
        labelIsHidden()
    }
    
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension HistoryController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return drinkUps.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkUps[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DrinkUpCell.reuseId, for: indexPath) as! DrinkUpCell
        let drinkUp = drinkUps[indexPath.section][indexPath.row]
        cell.configure(with: drinkUp)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !drinkUps[section].isEmpty {
            
            let headerView = HistoryTableViewHeader()
            formatter.dateFormat = "dd MMMM"
            let date = drinkUps[section].first!.time
            var stringDate = formatter.string(from: date)
            
            if date.removeTimeStamp == Date().removeTimeStamp {
                stringDate = "Сегодня"
            } else if date.removeTimeStamp == Date().yesterday?.removeTimeStamp {
                stringDate = "Вчера"
            } else if date.removeTimeStamp == Date().tomorrow?.removeTimeStamp {
                stringDate = "Завтра"
            }
            
            let volume = countVolume(for: section, from: drinkUps)
            let dailyTarget = StorageService.shared.getDailyTarget(date: date).first?.target ?? 1
            let volumeText = "\(Int(volume)) / \(Int(dailyTarget + (StorageService.shared.getTraining(date: date).first?.volume ?? 0))) МЛ"
            
            headerView.configure(date: stringDate, volume: volumeText)
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !drinkUps[section].isEmpty {
            return 41
        }
        return 0
    }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editingController = EditingController()
        editingController.drinkUp = drinkUps[indexPath.section][indexPath.row]
        editingController.delegate = self
        let navController = UINavigationController(rootViewController: editingController)
        present(navController, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HistoryController: EditingControllerProtocol {
    func deleteDrinkUp() {
        tableView.reloadData()
        calendar.reloadData()
        labelIsHidden()
    }
    
    func closeEditingController() {
        tableView.reloadData()
        calendar.reloadData()
        labelIsHidden()
    }
}
