//
//  MockSubscribedShowsService.swift
//  SeriesApp
//
//  Created by César Rosales on 05/09/2023.
//

import Foundation

class MockSubscribedShowService: SubscribedShowsService {
    
    var tvShows: [TVShow] = [TVShow.mock(), TVShow.mock(), TVShow.mock()]
    
    func addNewSubscription(_ tvShow: TVShow) async throws {
        tvShows.append(tvShow)
    }
    func saveSubscriptions(_ tvShows: [TVShow]) async throws {
        self.tvShows = tvShows
    }
    
    func fetchSubsribedShows() async throws -> [TVShow] {
        return tvShows
    }
    
}
