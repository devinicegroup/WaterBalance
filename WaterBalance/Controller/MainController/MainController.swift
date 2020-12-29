//
//  MainController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 20.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RealmSwift

class MainController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case drinkables
    }
    
    var collectionView: UICollectionView!
    var collectionViewHight: CGFloat!
    var widthButton: CGFloat!
    var heightDailyProgressBar: CGFloat!
    
    var drinkInDay = 0.0
    var targetInDay = 0.0
    var drinkUps: Results<DrinkUp>!
    
    var drinkables = DrinkStart.drinkables
    var dataSource: UICollectionViewDiffableDataSource<Section, DrinkStart>?
    
    let workoutButton = UIButton(type: .system)
    let trashButton = UIButton(type: .system)
    let addButton = UIButton(type: .system)
    var dailyProgressBar: DailyProgressBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        targetInDay = UserDefaults.standard.double(forKey: "target") + (StorageService.shared.getTraining(date: Date()).first?.volume ?? 0)
        countVolume()
        addVolume(volume: 0)
        isActiveButtons()
    }
    
    private func countVolume() {
        drinkInDay = 0
        drinkUps.forEach { (drinkUp) in
            drinkInDay += drinkUp.hydrationVolume
        }

        UserDefaults.standard.set(drinkInDay >= targetInDay , forKey: DateNotificationsEnum.dailyTargetForNotification.rawValue)
    }
    
    static func saveDataForTodayExtension() {
        print(123123)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationService.shared.notificationCenter.delegate = NotificationService.shared

        widthButton = (self.view.frame.width - 16 * 3) / 3
        drinkUps = StorageService.shared.getDataForDay(date: Date.today()).first
        
        view.backgroundColor = .white
        setupNavigationController()
        setupCollectionView()
        setupButtons()
        createDataSource()
        reloadData()
        setupDailyProgressBar()
        setupConstraints()
        
        if UserDefaults.standard.string(forKey: UserDefaultsServiceEnum.lastDateForCheckingOfSuccessfulDays.rawValue) != nil {
            StreakOfSuccessfulDays.shared.checkingStreaks()
        }
    }
    
    private func setupNavigationController() {
        self.navigationItem.title = "Водный баланс"
        if screenHeight/screenWidth > 2 {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        }
    }
    
    private func setupDailyProgressBar() {
//        let width = self.view.frame.width - 32
        heightDailyProgressBar = self.view.frame.height - ((tabBarController?.tabBar.frame.height)! + (navigationController?.navigationBar.frame.height)!)
        heightDailyProgressBar -= collectionViewHight
        heightDailyProgressBar -= (30 + 16 + 16 + 16)
//        dailyProgressBar = DailyProgressBar(frame: CGRect(x: 0, y: 0, width: width, height: heightDailyProgressBar))
        dailyProgressBar = DailyProgressBar(frame: CGRect(x: 0, y: 0, width: heightDailyProgressBar, height: heightDailyProgressBar))
        
        view.addSubview(dailyProgressBar)
        dailyProgressBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButtons() {
        view.addSubview(workoutButton)
        view.addSubview(trashButton)
        view.addSubview(addButton)
        
        workoutButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        let workoutImage = UIImage(named: "workout")
        workoutButton.tintColor = .mainDark()
        workoutButton.setImage(workoutImage, for: .normal)
        workoutButton.addTarget(self, action: #selector(workoutTapped), for: .touchUpInside)
        
        let trashImage = UIImage(named: "trash")
        trashButton.tintColor = .mainDark()
        trashButton.setImage(trashImage, for: .normal)
        trashButton.addTarget(self, action: #selector(deleteLastDrinkUp), for: .touchUpInside)
        
        let addImage = UIImage(named: "add")
        addButton.tintColor = .mainDark()
        addButton.setImage(addImage, for: .normal)
        addButton.addTarget(self, action: #selector(addLastDrinkUp), for: .touchUpInside)
    }
    
    private func isActiveButtons() {
        if drinkUps.isEmpty {
            trashButton.isEnabled = false
            addButton.isEnabled = false
        } else {
            trashButton.isEnabled = true
            addButton.isEnabled = true
        }
    }
    
    @objc private func deleteLastDrinkUp() {
        guard let drinkUp = drinkUps.first else { return }
        addVolume(volume: -drinkUp.hydrationVolume)
        HealthService.shared.deleteSamples(drinkUp: drinkUp)
        StorageService.shared.deleteObject(object: drinkUp)
        isActiveButtons()
    }
    
    @objc private func workoutTapped() {
        let training = StorageService.shared.getTraining(date: Date()).first
        if training == nil {
            StorageService.shared.saveTraining(training: createTraining())
            let training = StorageService.shared.getTraining(date: Date()).first
            
            addTrain(volume: training!.volume)
        } else {
            addTrain(volume: -training!.volume)
            StorageService.shared.deleteObject(object: training!)
        }
        NotificationService.shared.uploadNotifications()
    }
    
    @objc private func addLastDrinkUp() {
        guard let drinkUp = drinkUps.first else { return }
        let newDrinkUp = createDrinkUp(drink: drinkUp.drink!, volume: drinkUp.volume)
        addVolume(volume: newDrinkUp.hydrationVolume)
        StorageService.shared.saveDrinkUp(drinkUp: newDrinkUp)
        isActiveButtons()
    }
    
    private func addVolume(volume: Double) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let from = drinkInDay / targetInDay
        let to = volume / targetInDay + from
        basicAnimation.fromValue = from
        basicAnimation.toValue = to
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        dailyProgressBar.fgLayer.add(basicAnimation, forKey: "drink")
        drinkInDay += volume
        updateLabeles()
        UserDefaults.standard.set(drinkInDay >= targetInDay , forKey: DateNotificationsEnum.dailyTargetForNotification.rawValue)
        NotificationService.shared.uploadNotifications()
    }
    
    private func updateLabeles() {
        let topText = "\(Int(drinkInDay / (targetInDay / 100)))%"
        dailyProgressBar.topLabel.text = topText
        
        let bottomText = "\(Int(drinkInDay)) / \(Int(targetInDay))"
        dailyProgressBar.bottomLabel.text = bottomText
    }
    
    private func addTrain(volume: Double) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let from = drinkInDay / targetInDay
        basicAnimation.fromValue = from
        targetInDay += volume
        let to = drinkInDay / targetInDay
        basicAnimation.toValue = to
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        dailyProgressBar.fgLayer.add(basicAnimation, forKey: "drink")
        updateLabeles()
        UserDefaults.standard.set(drinkInDay >= targetInDay , forKey: DateNotificationsEnum.dailyTargetForNotification.rawValue)
        NotificationService.shared.uploadNotifications()
    }
    
    func setupCollectionView() {
        let collectionViewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        collectionView = UICollectionView(frame: collectionViewSize, collectionViewLayout: createCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        
        collectionView.register(DrinkablesCell.self, forCellWithReuseIdentifier: DrinkablesCell.reuseId)
        collectionView.delegate = self
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .drinkables:
                return self.createDrinkablesSection()
            }
        }
        return layout
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DrinkStart>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, person) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .drinkables:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkablesCell.reuseId, for: indexPath) as! DrinkablesCell
                let drink = self.drinkables[indexPath.item]
                cell.configure(with: drink)
                return cell
            }
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DrinkStart>()
        snapshot.appendSections([.drinkables])
        snapshot.appendItems(drinkables, toSection: .drinkables)
        dataSource?.apply(snapshot)
    }
    
    func createDrinkablesSection() -> NSCollectionLayoutSection {
        let spacing = CGFloat(16)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let width = (view.bounds.width - spacing * 5) / 4
        let hight = (width * 2) + (spacing * 3)
        collectionViewHight = hight + spacing * 3
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(hight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
        return section
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(tabBarController?.tabBar.frame.height)! + 16),
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHight)
        ])
        
        NSLayoutConstraint.activate([
            trashButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            trashButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            trashButton.widthAnchor.constraint(equalToConstant: widthButton),
            trashButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            workoutButton.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor, constant: -8),
            workoutButton.bottomAnchor.constraint(equalTo: trashButton.bottomAnchor),
            workoutButton.widthAnchor.constraint(equalToConstant: widthButton),
            workoutButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: trashButton.trailingAnchor, constant: 8),
            addButton.bottomAnchor.constraint(equalTo: trashButton.bottomAnchor),
            addButton.widthAnchor.constraint(equalToConstant: widthButton),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        if screenHeight/screenWidth > 2 {
            NSLayoutConstraint.activate([
                dailyProgressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                dailyProgressBar.bottomAnchor.constraint(equalTo: trashButton.topAnchor, constant: -16),
                dailyProgressBar.heightAnchor.constraint(equalToConstant: heightDailyProgressBar - 8),
                dailyProgressBar.widthAnchor.constraint(equalToConstant: heightDailyProgressBar - 8)
            ])
        } else {
            NSLayoutConstraint.activate([
                dailyProgressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                dailyProgressBar.bottomAnchor.constraint(equalTo: trashButton.topAnchor, constant: -8),
                dailyProgressBar.heightAnchor.constraint(equalToConstant: heightDailyProgressBar + 20),
                dailyProgressBar.widthAnchor.constraint(equalToConstant: heightDailyProgressBar + 20)
            ])
        }
    }
}


//MARK: - UICollectionViewDelegate
extension MainController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let height = (view.frame.width / 2.4) + 22 + 11 + 50
        let containerPopUp = ContainerPopUp(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height))
        containerPopUp.delegate = self
        SwiftEntryKit.display(entry: containerPopUp, using: EKAttributesPopUp.createAttributes())
    }
}


//MARK: - UICollectionViewDelegate
extension MainController : ContainerPopUpProtocol {
    func buttonTapped(volume: Double) {
        guard let itemIndex = collectionView.indexPathsForSelectedItems?.first?.item else { return }
        guard let drink = realm.objects(Drink.self).filter("id == %@", itemIndex).first else { return }
        
        let dailyTarget = StorageService.shared.getDailyTarget(date: Date()).first
        if dailyTarget == nil {
            StorageService.shared.saveDailyTarget(dailyTarget: createDailyTarget())
        }
        
        if volume == 0 {
            showAllert(with: drink.nameForUser, and: "Укажите кол-во выпитой жидкости") { (volume) in
                self.saveDrinkUp(drink: drink, volume: volume)
            }
        } else {
            saveDrinkUp(drink: drink, volume: volume)
        }
        isActiveButtons()
    }
    
    private func saveDrinkUp(drink: Drink, volume: Double) {
        let drinkUp = self.createDrinkUp(drink: drink, volume: volume)
        StorageService.shared.saveDrinkUp(drinkUp: drinkUp)
        addVolume(volume: drinkUp.hydrationVolume)
    }
    
    func createDailyTarget() -> DailyTarget {
        let target = UserDefaults.standard.double(forKey: "target")
        let dailyTarget = DailyTarget(target: target, date: Date())
        return dailyTarget
    }
    
    func createTraining() -> Training {
        let trainingVolume = UserDefaults.standard.double(forKey: "training")
        let training = Training(volume: trainingVolume, date: Date())
        return training
    }
    
    func createDrinkUp(drink: Drink, volume: Double) -> DrinkUp {
        let hydrationVolume = volume * drink.hydration
        let caffeine = volume * drink.caffeine
        var dietaryWaterId = ""
        var dietaryCaffeineId = ""
        
        let group = DispatchGroup()
        if UserDefaults.standard.bool(forKey: "health") {
            group.enter()
            HealthService.shared.saveDietaryWaterSample(volume: hydrationVolume, date: Date()) { (id) in
                if id != nil {
                    dietaryWaterId = "\(id!)"
                }
                group.leave()
            }
            
            group.enter()
            if caffeine > 0 {
                HealthService.shared.saveDietaryCaffeineSample(mg: caffeine, date: Date()) { (id) in
                    if id != nil {
                        dietaryCaffeineId = "\(id!)"
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        group.wait()
        let drinkUp = DrinkUp(volume: volume, hydrationVolume: volume * drink.hydration, caffeine: volume * drink.caffeine, time: Date(), drink: drink, id: UUID().uuidString, dietaryWaterId: dietaryWaterId, dietaryCaffeineId: dietaryCaffeineId)
        return drinkUp
    }
}
