//
//  PriceDetailRouter.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit

protocol PresenterToRouterProtocol: AnyObject {}

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
        
        let interactor: PresenterToInteractorProtocol = PriceDetailInteractor()
        let router: PresenterToRouterProtocol = PriceDetailRouter()
        let presenter = PriceDetailPresenter(
            baseEuroPrice: baseEuroPrice,
            dateString: dateString,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        
        return view
    }
}
