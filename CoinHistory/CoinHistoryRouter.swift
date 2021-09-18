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
