
import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
    var queryParams: [URLQueryItem]? { get }
}

extension Endpoint {
    var scheme: String {
        return "http"
    }

    var host: String {
        return "18.144.161.235"
    }
    
    var header: [String: String]? {
        var header = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        if let token = UserDefaults.standard[.user]?.accessToken {
            header["Authorization"] = "Bearer \(token)"
        }
        
        print("😇")
        print(header)
        return header
    }
}
