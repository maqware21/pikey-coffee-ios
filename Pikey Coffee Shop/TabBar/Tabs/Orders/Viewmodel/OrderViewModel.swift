//
//  OrderViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/11/2022.
//

import Foundation

protocol OrderDelegate: AnyObject {
    func ordersUpdated(_ orders: OrderList?)
    func orderCancelled(_ id: Int?)
}

class OrderViewModel {
    
    weak var delegate: OrderDelegate?
    
    func getOrders(page: Int) {
        Task(priority: .background) {
            let result = await CartService.shared.getOrders(page: page)
            switch result {
            case .success(let data):
                delegate?.ordersUpdated(data)
            case .failure(let error):
                delegate?.ordersUpdated(nil)
                print(error.customMessage)
            }
        }
    }
    
    func cancelOrders(id: Int) {
        Task(priority: .background) {
            let result = await CartService.shared.cancelOrder(id: id)
            switch result {
            case .success:
                delegate?.orderCancelled(id)
            case .failure(let error):
                print(error.customMessage)
                delegate?.orderCancelled(nil)
            }
        }
    }
}
