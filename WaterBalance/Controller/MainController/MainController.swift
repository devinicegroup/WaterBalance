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
    var targetInDay = UserDefaults.standard.double(forKey: "target")
    
    var drinkables = DrinkStart.drinkables
    var dataSource: UICollectionViewDiffableDataSource<Section, DrinkStart>?
    
    let workoutButton = UIButton(type: .system)
    let trashButton = UIButton(type: .system)
    let addButton = UIButton(type: .system)
    var dailyProgressBar: DailyProgressBar!
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        widthButton = (self.view.frame.width - 16 * 3) / 3
        
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.typographyPrimary()]
        //        navigationController?.navigationBar.barTintColor = .darkGray
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupDailyProgressBar() {
        let width = self.view.frame.width - 32
        heightDailyProgressBar = self.view.frame.height - ((tabBarController?.tabBar.frame.height)! + (navigationController?.navigationBar.frame.height)!)
        heightDailyProgressBar -= collectionViewHight
        heightDailyProgressBar -= (30 + 16 + 16 + 16)
        dailyProgressBar = DailyProgressBar(frame: CGRect(x: 0, y: 0, width: width, height: heightDailyProgressBar))
        
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
        trashButton.backgroundColor = .green
        
        let addImage = UIImage(named: "add")
        addButton.tintColor = .mainDark()
        addButton.setImage(addImage, for: .normal)
        addButton.addTarget(self, action: #selector(addLastDrinkUp), for: .touchUpInside)
    }
    
    @objc private func deleteLastDrinkUp() {
        
    }
    
    @objc private func workoutTapped() {
        addTrain(volume: 1000)
    }
    
    @objc private func addLastDrinkUp() {
        addDrink(volume: 500)
    }
    
    private func addDrink(volume: Double) {
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
        
        NSLayoutConstraint.activate([
            dailyProgressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dailyProgressBar.bottomAnchor.constraint(equalTo: trashButton.topAnchor, constant: -16),
            dailyProgressBar.heightAnchor.constraint(equalToConstant: heightDailyProgressBar),
            dailyProgressBar.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32)
        ])
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
                let drinkUp = self.createDrinkUp(drink: drink, volume: volume)
                StorageService.shared.saveDrinkUp(drinkUp: drinkUp)
            }
        } else {
            let drinkUp = createDrinkUp(drink: drink, volume: volume)
            StorageService.shared.saveDrinkUp(drinkUp: drinkUp)
        }
    }
    
    func createDailyTarget() -> DailyTarget {
        let target = UserDefaults.standard.double(forKey: "target")
        let dailyTarget = DailyTarget(target: target, date: Date())
        return dailyTarget
    }
    
    func createDrinkUp(drink: Drink, volume: Double) -> DrinkUp {
        let drinkUp = DrinkUp(volume: volume, hydrationVolume: volume * drink.hydration, caffeine: volume * drink.caffeine, time: Date(), drink: drink, id: UUID().uuidString)
        StorageService.shared.saveDrinkUp(drinkUp: drinkUp)
        return drinkUp
    }
}
