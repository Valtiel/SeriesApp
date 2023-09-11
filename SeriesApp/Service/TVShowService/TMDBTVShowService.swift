//
//  TMDBTVShowService.swift
//  SeriesApp
//
//  Created by César Rosales on 05/09/2023.
//

import Foundation

class TMDBTVShowService: TVShowService {
    
    private let apiKey: String
    private let baseUrl: String = "https://api.themoviedb.org"
    private let path: String = "/3/tv/popular"
    private let searchPath: String = "/3/search/tv"
    
    private        let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMTZmMzY4OWEzMzJjMzMwNjFmZDhmYjc2MmI2NzM0YyIsInN1YiI6IjViOGIyY2E4OTI1MTQxNTE4NzAyODJlNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yDxy0y0CNxNencn0aQYJ6v-Aumh5RKp9zHediEBbbWU"
    ]
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getImageURL(_ path: String, width: Int) -> String {
        return "https://image.tmdb.org/t/p/w\(width)\(path)"
    }
    
    func fetchTVShows() async throws -> [TVShow] {
        return try await fetchTVShows(page: 1)
    }
    
    func searchTVShows(by query: String, page: Int) async throws -> [TVShow] {
        let baseUrl = ServiceBuilder(baseUrl: baseUrl, path: searchPath)
        
        let url = baseUrl
            .addQueryItem(name: "page", value: "\(page)")
            .addQueryItem(name: "language", value: "en-US")
            .addQueryItem(name: "query", value: query)
            .build()
        
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let result = try JSONDecoder().decode(TMDBResult.self, from: data)
            print(data.prettyPrintedJSONString)
            return result.results
        } catch {
            print(error)
            return []
        }
        
    }
    
    func fetchTVShows(page: Int) async throws -> [TVShow] {
        let baseUrl = ServiceBuilder(baseUrl: baseUrl, path: path)
        
        let url = baseUrl
            .addQueryItem(name: "page", value: "\(page)")
            .addQueryItem(name: "api_key", value: apiKey)
            .addQueryItem(name: "language", value: "en-US")
            .build()
        
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let result = try JSONDecoder().decode(TMDBResult.self, from: data)
            return result.results
        } catch {
            print(error)
            return []
        }
        
    }
    
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

private class ServiceBuilder {
    private let baseUrl: String
    private var path: String
    private var queryItems: [URLQueryItem] = []
    
    init(baseUrl: String, path: String) {
        self.baseUrl = baseUrl
        self.path = path
    }
    
    func addQueryItem(name: String, value: String) -> ServiceBuilder {
        queryItems.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    func build() -> URL {
        var components = URLComponents(string: baseUrl)!
        components.path = path
        
        components.queryItems = queryItems
        return components.url!
    }
}