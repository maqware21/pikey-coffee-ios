//
//  GiftCardViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/09/2023.
//

import Foundation

protocol GiftCardDelegate: AnyObject {
    func giftCardCreated(_ error: Error?)
}

class GiftCardViewModel {
    
    weak var delegate: GiftCardDelegate?
    
    func createGiftCard(giftCard: GiftCard) {
        Task(priority: .background) {
            let result = await ProfileService.shared.createGiftCard(giftCard: giftCard)
            switch result {
            case .success(let data):
                delegate?.giftCardCreated(nil)
            case .failure(let error):
                delegate?.giftCardCreated(error)
                print(error.customMessage)
            }
        }
    }
}
