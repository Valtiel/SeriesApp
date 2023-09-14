//
//  URLSessionRequestBuilder.swift
//  SeriesApp
//
//  Created by César Rosales on 13/09/2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
}

protocol Endpoint {
    var path: String { get }
}

enum HTTPContentType: String {
    case json = "application/json"
    case html = "text/html"
}

enum HTTPLanguage: String {
    case usEnglish = "en-US"
}

class URLSessionRequestBuilder {
    private let baseUrl: String
    private var endpoint: Endpoint
    private var queryItems: [URLQueryItem] = []
    private var headers: [String : String] = [:]
    private var httpMethod: HTTPMethod = .get

    init(baseUrl: String, endpoint: Endpoint) {
        self.baseUrl = baseUrl
        self.endpoint = endpoint
    }
    
    @discardableResult
    func addQueryItem(name: String, value: String) -> URLSessionRequestBuilder {
        queryItems.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    @discardableResult
    func setHTTPMethod(_ httpMethod: HTTPMethod) -> URLSessionRequestBuilder {
        self.httpMethod = httpMethod
        return self
    }
    
    @discardableResult
    func addHeader(name: String, value: String) -> URLSessionRequestBuilder {
        headers.updateValue(value, forKey: name)
        return self
    }
    
    @discardableResult
    func setContentType(_ contentType: HTTPContentType) -> URLSessionRequestBuilder {
        headers.updateValue(contentType.rawValue, forKey: "accept")
        return self
    }
    
    @discardableResult
    func setLanguage(_ language: HTTPLanguage) -> URLSessionRequestBuilder {
        addQueryItem(name: "language", value: language.rawValue)
        return self
    }
    
    func build() -> URLRequest? {
        var components = URLComponents(string: baseUrl)!
        components.path = endpoint.path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}
