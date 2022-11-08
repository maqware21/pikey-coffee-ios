//
//  ProfileViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 22/07/2022.
//

import Foundation

protocol ProfileDelegate: AnyObject {
    func profileUpdated(_ user: User?)
    func addressListUpdated(addresses: AddressList?)
}


extension ProfileDelegate {
    func profileUpdated(_ user: User?) {return}
    func addressListUpdated(addresses: AddressList?) {return}
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

    func getAddressList(for page: Int) {
        Task(priority: .background) {
            let result = await ProfileService.shared.getAddresses(page: page)
            switch result {
            case .success(let data):
                delegate?.addressListUpdated(addresses: data)
            case .failure(let error):
                delegate?.addressListUpdated(addresses: nil)
                print(error.customMessage)
            }
        }
    }
}
