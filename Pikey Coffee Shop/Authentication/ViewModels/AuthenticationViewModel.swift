//
//  RegistrationViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 19/07/2022.
//

protocol AuthenticationDelegate: AnyObject {
    func authenticated(_ user: User?)
}

protocol ForgotPasswordDelegate: AnyObject {
    func forgotPasswordResponse(with message: String)
}

import Foundation

class AuthenticationViewModel {
    
    weak var authenticationDelegate: AuthenticationDelegate?
    weak var forgotPasswordDelegate: ForgotPasswordDelegate?
    
    func registerUser(name: String,
                      email: String,
                      password: String,
                      phoneNo: String) {
        Task(priority: .background) {
            let result = await AuthenticationService.shared.signUp(name: name,
                                                             email: email,
                                                             password: password,
                                                             phoneNo: phoneNo)
            switch result {
            case .success(let data):
                authenticationDelegate?.authenticated(data.data)
            case .failure(let error):
                authenticationDelegate?.authenticated(nil)
                print(error.customMessage)
            }
        }
    }
    
    func loginUser(email: String,
                    password: String) {
        Task(priority: .background) {
            let result = await AuthenticationService.shared.signIn(email: email,
                                                             password: password)
            switch result {
            case .success(let data):
                authenticationDelegate?.authenticated(data)
            case .failure(let error):
                authenticationDelegate?.authenticated(nil)
                print(error.customMessage)
            }
        }
    }
    
    func sendForgotPasswordReq(for email: String) {
        Task(priority: .background) {
            let result = await AuthenticationService.shared.forgotPassword(email: email)
            switch result {
            case .success(let data):
                forgotPasswordDelegate?.forgotPasswordResponse(with: data.message ?? "")
            case .failure(let error):
                forgotPasswordDelegate?.forgotPasswordResponse(with: error.customMessage)
            }
        }
    }
}
