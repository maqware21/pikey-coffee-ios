//
//  MoviesEndpoint.swift
//  RequestApp
//
//  Created by Victor Catão on 18/02/22.
//

enum RegistrationEndpoint {
    case signUp(name: String,
                email: String,
                password: String,
                phoneNo: String)
    case signIn(email: String,
                password: String)
}

extension RegistrationEndpoint: Endpoint {
    var path: String {
        switch self {
        case .signUp:
            return "/api/oauth/register"
        case .signIn:
            return "/api/oauth/login"
        }
    }

    var method: RequestMethod {
        switch self {
        case .signUp, .signIn:
            return .post
        }
    }

    var header: [String: String]? {
        switch self {
        case .signUp, .signIn:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .signUp(let name, let email, let password, let phoneNo):
            let namecomponents = name.components(separatedBy: " ")
            let parameter: [String: String] = [
                                "email": email,
                                "password": password,
                                "first_name": namecomponents.first ?? "",
                                "last_name": namecomponents.last ?? "",
                                "password_confirmation": password,
                                "phone_number": phoneNo
                            ]
            return parameter
        case .signIn(let email, let password):
            let parameter: [String: String] = [
                                "email": email,
                                "password": password,
                                "client_id": "2",
                                "client_secret": "iJNPgKRPYEgnxHRhCJDKESGC2ZV904r7cGuByH5N",
                                "grant_type": "password"
                            ]
            return parameter
        }
    }
}
