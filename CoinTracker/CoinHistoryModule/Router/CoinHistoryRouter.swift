//
//  CoinHistoryRouter.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit

class CoinHistoryRouter: PresenterToRouterProtocol {
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static func createModule() -> CoinHistoryViewController {
        guard let view = mainstoryboard.instantiateViewController(withIdentifier: "CoinHistoryViewController")
                as? CoinHistoryViewController else {
            fatalError("Unable to Load view from storyboard")
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
