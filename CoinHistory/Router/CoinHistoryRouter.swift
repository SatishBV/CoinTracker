//
//  CoinHistoryRouter.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit
import PriceDetailModule

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
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = CoinHistoryPresenter()
        let interactor: PresenterToInteractorProtocol = CoinHistoryInteractor()
        let router: PresenterToRouterProtocol = CoinHistoryRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
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
