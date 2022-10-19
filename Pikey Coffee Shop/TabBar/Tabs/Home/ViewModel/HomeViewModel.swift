//
//  HomeViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/10/2022.
//

protocol HomeDelegate: AnyObject {
    func categoryResponse(with categoryData: CategoryData?)
}

import Foundation

class HomeViewModel {
    
    weak var delegate: HomeDelegate?
    
    func getCategories(for page: Int) {
        Task(priority: .background) {
            let result = await HomeService.shared.getCategories(page: page)
            switch result {
            case .success(let data):
                delegate?.categoryResponse(with: data)
            case .failure(let error):
                delegate?.categoryResponse(with: nil)
                print(error.customMessage)
            }
        }
    }
}
