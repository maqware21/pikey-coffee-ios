//
//  MerchandiseViewmodel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/06/2023.
//

import UIKit

protocol MerchandiseDelegate: AnyObject {
    func categoriesUpdated(_ categories: [MerchandiseCategory]?)
}

class MerchandiseViewmodel {
    
    weak var delegate: MerchandiseDelegate?
    
    func getCategories() {
        Task(priority: .background) {
            let result = await MerchandiseService.shared.getCategories()
            switch result {
            case .success(let data):
                delegate?.categoriesUpdated(data)
            case .failure(let error):
                delegate?.categoriesUpdated(nil)
                print(error.customMessage)
            }
        }
    }
}
