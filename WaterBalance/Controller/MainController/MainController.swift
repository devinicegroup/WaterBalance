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
    
    var drinkables = DrinkStart.drinkables
    var dataSource: UICollectionViewDiffableDataSource<Section, DrinkStart>?
    
    var collectionViewHight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationController()
        setupCollectionView()
        createDataSource()
        reloadData()
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
