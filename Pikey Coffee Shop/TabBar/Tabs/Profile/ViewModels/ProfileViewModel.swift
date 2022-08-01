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
    
    func updateProfile(userName: String) {
        Task(priority: .background) {
            let result = await ProfileService.shared.updateProfile(userName: userName)
            switch result {
            case .success(let data):
                delegate?.profileUpdated(data)
            case .failure(let error):
                delegate?.profileUpdated(nil)
                print(error.customMessage)
            }
        }
    }
    
    func updatePassword(oldPassword: String, newPassword: String, confirmPassword: String) {
        Task(priority: .background) {
            let result = await ProfileService.shared.updatePassword(oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword)
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
