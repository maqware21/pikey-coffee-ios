//
//  RegistrationViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 19/07/2022.
//

protocol RegisterDelegate: AnyObject {
    func authenticated(_ user: User?)
}

import Foundation

class RegistrationViewModel {
    
    weak var registerDelegate: RegisterDelegate?
    
    func registerUser(name: String,
                      email: String,
                      password: String,
                      phoneNo: String) {
        Task(priority: .background) {
            let result = await RegisterService.shared.signUp(name: name,
                                                             email: email,
                                                             password: password,
                                                             phoneNo: phoneNo)
            switch result {
            case .success(let data):
                registerDelegate?.authenticated(data.data)
            case .failure(let error):
                registerDelegate?.authenticated(nil)
                print(error.customMessage)
            }
        }
    }
    
    func loginUser(email: String,
                    password: String) {
        Task(priority: .background) {
            let result = await RegisterService.shared.signIn(email: email,
                                                             password: password)
            switch result {
            case .success(let data):
                registerDelegate?.authenticated(data)
            case .failure(let error):
                registerDelegate?.authenticated(nil)
                print(error.customMessage)
            }
        }
    }
}
