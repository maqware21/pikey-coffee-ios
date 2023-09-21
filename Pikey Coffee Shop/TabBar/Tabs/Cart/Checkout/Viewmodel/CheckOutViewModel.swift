//
//  CheckOutViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/11/2022.
//

import Foundation

protocol CheckOutDelegate: AnyObject {
    func orderCreated(_ order: Order?)
    func couponValidated(_ couponValidated: CouponValidated?)
}

class CheckOutViewModel {
    
    weak var delegate: CheckOutDelegate?
    
    func createOrder(cart: Cart?) {
        Task(priority: .background) {
            let result = await CartService.shared.createOrder(cart: cart)
            switch result {
            case .success(let data):
                delegate?.orderCreated(data)
            case .failure(let error):
                delegate?.orderCreated(nil)
                print(error.customMessage)
            }
        }
    }
    
    func validateCoupon(code: String) {
        
        Task(priority: .background) {
            let result = await CartService.shared.validateCoupon(code: code)
            switch result {
            case .success(let data):
                delegate?.couponValidated(data)
            case .failure(let error):
                delegate?.couponValidated(nil)
                print(error.customMessage)
            }
        }
    }
}
