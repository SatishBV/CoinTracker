//
//  AppDelegate.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let coinHistory = CoinHistoryRouter.createModule()
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [coinHistory]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

/**
 TODOS:
 - [x] Add Errors for APIs. Present alerts
 - [x] Remove maximum force unwrappings
 - [x] Write Timer logic to refresh today's price
 - [x] Implement Router navigation
 - [ ] Move `CoinHistoryModule` to a new framework
 - [ ] Write unit tests for viewModels and utility classes
 */
