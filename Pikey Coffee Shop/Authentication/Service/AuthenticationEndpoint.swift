
import Foundation

enum AuthenticationEndpoint {
    case signUp(name: String,
                email: String,
                password: String,
                phoneNo: String)
    case signIn(email: String,
                password: String)
    case forgotPassword(email: String)
}

extension AuthenticationEndpoint: Endpoint {
    var path: String {
        switch self {
        case .signUp:
            return "/api/oauth/register"
        case .signIn:
            return "/api/oauth/login"
        case .forgotPassword:
            return "/api/oauth/forget-password"
        }
    }

    var method: RequestMethod {
        switch self {
        case .signUp, .signIn, .forgotPassword:
            return .post
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
        case .forgotPassword(let email):
            let parameter: [String: String] = [
                                "email": email
                            ]
            return parameter
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
}
