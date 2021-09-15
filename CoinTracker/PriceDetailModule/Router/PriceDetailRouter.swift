//
//  PriceDetailRouter.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit

class PriceDetailRouter {
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static func createModule(baseEuroPrice: Double, dateString: String) -> PriceDetailViewController {
        guard let view = mainstoryboard.instantiateViewController(withIdentifier: "PriceDetailViewController")
                as? PriceDetailViewController else {
            fatalError("Unable to Load view from storyboard")
        }
        
        view.viewModel = PriceDetailViewModel(baseEuroPrice: baseEuroPrice, dateString: dateString)
        
//        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = CoinHistoryPresenter()
//        let interactor: PresenterToInteractorProtocol = CoinHistoryInteractor()
//        let router: PresenterToRouterProtocol = CoinHistoryRouter()
//        
//        view.presenter = presenter
//        presenter.view = view
//        presenter.router = router
//        presenter.interactor = interactor
//        interactor.presenter = presenter
        
        return view
    }
}
