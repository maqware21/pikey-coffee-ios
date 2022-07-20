//
//  RequestPath.swift
//  RequestApp
//
//  Created by Victor Catão on 30/01/22.
//

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "http"
    }

    var host: String {
        return "18.144.161.235"
    }
}
