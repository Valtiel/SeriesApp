//
//  TVShowDetailViewModel.swift
//  SeriesApp
//
//  Created by César Rosales on 07/09/2023.
//

import Foundation

class TVShowDetailViewModel: ObservableObject {

    private let tvShowService: TVShowService
    private let subscribedShowService: SubscribedShowsService

    @Published private(set) var tvShow: TVShow
    @Published private(set) var isLoading: Bool = false
    
    init(tvShow: TVShow, tvShowService: TVShowService, subscribedShowService: SubscribedShowsService) {
        self.tvShowService = tvShowService
        self.subscribedShowService = subscribedShowService
        self.tvShow = tvShow
    }
    
    func addNewSubscribtion(_ tvShow: TVShow) async throws {
        try await subscribedShowService.addNewSubscription(tvShow)
    }
    
    func getFormattedPosterUrl(width: Int) -> String {
        guard let path = tvShow.posterPath else {
            return ""
        }
        return tvShowService.getImageURL(path, width: width)
    }
    
    func getFormattedBackdropUrl(width: Int) -> String {
        guard let path = tvShow.backdropPath else {
            return ""
        }
        return tvShowService.getImageURL(path, width: width)
    }
    
    
}
