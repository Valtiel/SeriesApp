//
//  TMDBTVShowService.swift
//  SeriesApp
//
//  Created by César Rosales on 05/09/2023.
//

import Foundation

class TMDBTVShowService: TVShowService {
    
    private let apiKey: String
    private let baseUrl: String
    
    enum TMDBEndpoint: Endpoint {
        
        case popular(page: Int)
        case search(page: Int, query: String)
        
        var path: String {
            switch self {
            case .popular:
                return "/3/tv/popular"
            case .search:
                return "/3/search/tv"
            }
        }
        
        
    }
    
    init(apiKey: String, baseUrl: String) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
    func fetchTVShows() async throws -> [TVShow] {
        return try await fetchTVShows(page: 1)
    }
    
    func searchTVShows(by query: String, page: Int) async throws -> [TVShow] {
        let response = try await get(endpoint: .search(page: page, query: query))
        return response.results
    }
    
    func fetchTVShows(page: Int) async throws -> [TVShow] {
        let response = try await get(endpoint: .popular(page: page))
        return response.results
        
    }
    
    private func get(endpoint: TMDBEndpoint) async throws -> TMDBResult {
        
        let builder = URLSessionRequestBuilder(baseUrl: baseUrl, endpoint: endpoint)
        builder.setHTTPMethod(.get)
            .setContentType(.json)
            .setLanguage(.usEnglish)
            .addHeader(name: "Authorization", value: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjA3NjMzM2EyMzlkMDUzMzRiZDU5ZjNmNjkyZWMzMyIsInN1YiI6IjViOGIyY2E4OTI1MTQxNTE4NzAyODJlNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8tZQ4o9UkfAPNBDH5-Fkmp9kamNmQk2qHh_T1T_EFFI")
            .addQueryItem(name: "api_key", value: apiKey)
        switch endpoint {
        case .popular(let page):
            builder.addQueryItem(name: "page", value: "\(page)")
        case .search(let page, let query):
            builder.addQueryItem(name: "page", value: "\(page)")
                .addQueryItem(name: "query", value: query)
        }
        
        guard let request = builder.build() else {
            throw TMDBRequestError.errorBuildingRequest
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(TMDBResult.self, from: data)
        return result
    }
    
    func getImageURL(_ path: String?, width: Int) -> String {
        guard let path = path else {
            return "PLACEHOLDER"
        }
        return "https://image.tmdb.org/t/p/w\(width)\(path)"
    }
}

enum TMDBRequestError: Error {
    case errorBuildingRequest
    case timeOut
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

struct TMDBResult: Codable {
    let page: Int
    let results: [TVShow]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
