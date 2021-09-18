//
//  PriceDetailRouter.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit

public class PriceDetailRouter: PresenterToRouterProtocol {
    static var bundle: Bundle? {
        Bundle(identifier: "com.satish.PriceDetailModule")
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: bundle)
    }
    
    public static func createModule(baseEuroPrice: Double, dateString: String) -> UIViewController {
        guard let view = storyboard.instantiateViewController(withIdentifier: "PriceDetailViewController")
                as? PriceDetailViewController else {
            fatalError("Unable to Load view from storyboard")
        }
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol =
            PriceDetailPresenter(
                baseEuroPrice: baseEuroPrice,
                dateString: dateString
            )
        let interactor: PresenterToInteractorProtocol = PriceDetailInteractor()
        let router: PresenterToRouterProtocol = PriceDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
