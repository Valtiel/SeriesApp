//
//  MockTVShowService.swift
//  SeriesApp
//
//  Created by César Rosales on 05/09/2023.
//

import Foundation

class MockTVShowService: TVShowService {
    
    func getImageURL(_ path: String, width: Int) -> String {
        return "https://picsum.photos/\(path)"
    }
    
    func fetchTVShows(page: Int) async throws -> [TVShow] {
        return [TVShow.mock(), TVShow.mock()]
    }

    func fetchTVShows() async throws -> [TVShow] {
        return [TVShow.mock(), TVShow.mock()]
    }
    
    func searchTVShows(by query: String, page: Int) async throws -> [TVShow]  {
        return [TVShow.mock(), TVShow.mock()]
    }
    
}
