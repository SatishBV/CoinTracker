//
//  CoinHistoryRouter.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit
import PriceDetailModule

protocol PresenterToRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func pushToPriceDetailsScreen(navigationConroller: UINavigationController,
                                  baseEuroPrice: Double,
                                  dateString: String)
}

public class CoinHistoryRouter: PresenterToRouterProtocol {
    static var bundle: Bundle? {
        Bundle(identifier: "com.satish.CoinHistory")
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: bundle)
    }
    
    /// Starting point of the Module `CoinHistory`
    /// - Returns: Instantiation of the rootVieiwController for the module
    public static func createModule() -> UIViewController {
        guard let view = storyboard.instantiateViewController(withIdentifier: String(describing: CoinHistoryViewController.self))
                as? CoinHistoryViewController else {
            fatalError("Unable to load View from storyboard")
        }
        
        let interactor: PresenterToInteractorProtocol = CoinHistoryInteractor()
        let router: PresenterToRouterProtocol = CoinHistoryRouter()
        let presenter = CoinHistoryPresenter(interactor: interactor, router: router)
        
        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        
        return view
    }
    
    /// Pushes the price details screen
    /// - Parameters:
    ///   - navigationConroller: Navigation controller where the new screen has to be pushed
    ///   - baseEuroPrice: Price which the new screen will be using to display all the details
    ///   - dateString: Date which the new screen will be using to fetch all details
    func pushToPriceDetailsScreen(
        navigationConroller: UINavigationController,
        baseEuroPrice: Double,
        dateString: String
    ) {
        let priceDetailModule = PriceDetailRouter.createModule(baseEuroPrice: baseEuroPrice,
                                                               dateString: dateString)
        navigationConroller.pushViewController(priceDetailModule, animated: true)
    }
}
