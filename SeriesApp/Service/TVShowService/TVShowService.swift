//
//  TVShowService.swift
//  SeriesApp
//
//  Created by César Rosales on 05/09/2023.
//

import Foundation

protocol TVShowService {
    func fetchTVShows() async throws -> [TVShow]
    func fetchTVShows(page: Int) async throws -> [TVShow]
    func searchTVShows(by query: String, page: Int) async throws -> [TVShow] 
    func getImageURL(_ path: String, width: Int) -> String
}

