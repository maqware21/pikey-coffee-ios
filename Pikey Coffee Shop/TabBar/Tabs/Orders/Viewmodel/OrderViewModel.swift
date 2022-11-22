//
//  OrderViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/11/2022.
//

import Foundation

protocol OrderDelegate: AnyObject {
    func ordersUpdated(_ orders: [Order]?)
}

class OrderViewModel {
    
    weak var delegate: OrderDelegate?
    
    func getOrders() {
        Task(priority: .background) {
            let result = await CartService.shared.getOrders()
            switch result {
            case .success(let data):
                delegate?.ordersUpdated(data)
            case .failure(let error):
                delegate?.ordersUpdated(nil)
                print(error.customMessage)
            }
        }
    }
}
