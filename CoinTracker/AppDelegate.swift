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
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CoinHistoryViewController") as? CoinHistoryViewController {
            viewController.viewModel = CoinHistoryViewModel(delegate: viewController)
            
            let nav = UINavigationController(rootViewController: viewController)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
}

/**
 TODOS:
 - [ ] Add Errors for APIs. Present alerts
 - [ ] Remove maximum force unwrappings
 - [ ] Write Timer logic to refresh today's price
 - [ ] Implement Router navigation
 - [ ] Split the code into frameworks
 - [ ] Write unit tests for viewModels and utility classes
 */
