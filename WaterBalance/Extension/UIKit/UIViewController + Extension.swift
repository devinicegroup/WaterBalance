//
//  UIViewController + Extension.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 03.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAllert(with title: String, and message: String, completion: @escaping (Double) -> Void = { _ in }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "0.0"
            textField.keyboardType = .numberPad
        }
        let okAction = UIAlertAction(title: "Ок", style: .default) { [unowned alertController](_) in
            guard let volume = alertController.textFields![0].text?.toDouble(), volume != 0 else { return }
            completion(volume)
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
