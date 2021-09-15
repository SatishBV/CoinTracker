//
//  PriceDetailProtocol.swift
//  PriceDetailModule
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol PresenterToViewProtocol: AnyObject {
    func refreshCurrencyText()
    func showError()
}

protocol PresenterToRouterProtocol: AnyObject {
    
}

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    
    func fetchForexRates(for dateString: String)
}
