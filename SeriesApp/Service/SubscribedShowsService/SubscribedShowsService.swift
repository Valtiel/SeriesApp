//
//  SubscribedShowsService.swift
//  SeriesApp
//
//  Created by César Rosales on 05/09/2023.
//

import Foundation

protocol SubscribedShowsService {
    func fetchSubsribedShows() async throws -> [TVShow]
    func addNewSubscription(_ tvShow: TVShow) async throws
    func saveSubscriptions(_ tvShows: [TVShow]) async throws
}
