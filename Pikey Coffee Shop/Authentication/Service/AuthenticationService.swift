
import Foundation

protocol AuthenticationServiceable {
    func signUp(name: String,
                email: String,
                password: String,
                phoneNo: String) async -> Result<UserData, RequestError>
    
    func signIn(email: String,
                password: String) async -> Result<User, RequestError>
    
    func forgotPassword(email: String) async -> Result<ForgotPassword, RequestError>
}

struct AuthenticationService: HTTPClient, AuthenticationServiceable {
    
    static let `shared` = AuthenticationService()
    
    func signUp(name: String,
                email: String,
                password: String,
                phoneNo: String) async -> Result<UserData, RequestError> {
        return await sendRequest(endpoint: AuthenticationEndpoint.signUp(name: name, email: email, password: password, phoneNo: phoneNo), responseModel: UserData.self)
    }
    
    func signIn(email: String,
                password: String) async -> Result<User, RequestError> {
        return await sendRequest(endpoint: AuthenticationEndpoint.signIn(email: email, password: password), responseModel: User.self)
    }
    
    func forgotPassword(email: String) async -> Result<ForgotPassword, RequestError> {
        return await sendRequest(endpoint: AuthenticationEndpoint.forgotPassword(email: email), responseModel: ForgotPassword.self)
    }
    
    
}
