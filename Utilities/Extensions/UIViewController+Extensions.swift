//
//  UIViewController+Extensions.swift
//  Utilities
//
//  Created by Satish Bandaru on 18/09/21.
//

import UIKit

public extension UIViewController {
    func showAlert(title: String?,
                   message: String?,
                   handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: handler))
        present(alert, animated: true, completion: nil)
    }
}
