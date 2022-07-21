//
//  ProfileViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 22/07/2022.
//

import Foundation

protocol ProfileDelegate: AnyObject {
    func profileUpdated(_ user: User?)
}

class ProfileViewModel {
    
    weak var delegate: ProfileDelegate?
    
    func getProfile() {
        Task(priority: .background) {
            let result = await ProfileService.shared.getProfile()
            switch result {
            case .success(let data):
                delegate?.profileUpdated(data)
            case .failure(let error):
                delegate?.profileUpdated(nil)
                print(error.customMessage)
            }
        }
    }
}
