//
//  HomeViewModel.swift
//  SeriesApp
//
//  Created by César Rosales on 04/09/2023.
//

import Foundation

enum HomeViewModelError: Error {
    case cannotLoadMore
    case cannotFetchRemoteTVShows
    case cannotFetchSubscribedTVShows
    
    var errorMessage: String {
        switch self {
        case .cannotLoadMore:
            return ""
        case .cannotFetchRemoteTVShows:
            return ""
        case .cannotFetchSubscribedTVShows:
            return ""
        }
    }
}

class HomeViewModel: ObservableObject {
    
    let tvShowService: TVShowService
    let subscribedShowService: SubscribedShowsService
    
    @Published private(set) var tvShows: [TVShow] = []
    @Published private(set) var foundTVShows: [TVShow] = []
    @Published private(set) var subscribedTVShows: [TVShow] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isSearching: Bool = false
    @Published private(set) var page : Int = 1
    @Published private(set) var searchPage : Int = 1

    init(tvShowService: TVShowService, subscribedShowService: SubscribedShowsService) {
        self.tvShowService = tvShowService
        self.subscribedShowService = subscribedShowService
    }
    
    func getFormattedPosterUrl(index: Int, width: Int) -> String {
        guard let path = subscribedTVShows[index].posterPath else {
            return ""
        }
        return tvShowService.getImageURL(path, width: width)
    }
    
    func getFormattedPosterUrlForSearch(index: Int, width: Int) -> String {
        guard let path = foundTVShows[index].posterPath else {
            return ""
        }
        return tvShowService.getImageURL(path, width: width)
    }
    
    func getFormattedPosterUrlForSearch(tvShow: TVShow, width: Int) -> String {
        guard let path = tvShow.posterPath else {
            return ""
        }
        return tvShowService.getImageURL(path, width: width)
    }
    
    func getFormattedBackdropUrl(index: Int, width: Int) -> String {
        guard let path = tvShows[index].backdropPath else {
            return ""
        }
        return tvShowService.getImageURL(path, width: width)
    }
    
    func isSubscribed(_ tvShow: TVShow) -> Bool {
        return subscribedTVShows.contains(tvShow)
    }
    
    @MainActor
    func addNewSubscribe(_ tvShow: TVShow) async {
        do {
            try await subscribedShowService.addNewSubscription(tvShow)
            subscribedTVShows = try await subscribedShowService.fetchSubsribedShows()
        } catch _ {
            
        }
    }
    
    @MainActor
    func loadMoreSearchContent(index: Int) async {
        let thresholdIndex = self.tvShows.index(self.foundTVShows.endIndex, offsetBy: -1)
        if thresholdIndex == index {
            do {
                searchPage += 1
                let newPage = try await tvShowService.fetchTVShows(page: page)
                foundTVShows.append(contentsOf: newPage)
            } catch _ {
                
            }
            
        }
    }
    
    @MainActor
    func search(by query: String) async {
        guard !query.isEmpty else {
            isSearching = false
            foundTVShows = []
            return
        }
        
        do {
            isSearching = true
            foundTVShows = try await tvShowService.searchTVShows(by: query, page: 1)
        } catch _ {
            
        }
        
    }
    
    @MainActor
    func loadMoreContent(index: Int) async {
        let thresholdIndex = self.tvShows.index(self.tvShows.endIndex, offsetBy: -1)
        if thresholdIndex == index {
            do {
                page += 1
                let newPage = try await tvShowService.fetchTVShows(page: page)
                tvShows.append(contentsOf: newPage)
            } catch _ {
                
            }
            
        }
    }
    
    @MainActor
    func refresh() async {
        do {
            isLoading = true
            tvShows = try await tvShowService.fetchTVShows()
            subscribedTVShows = try await subscribedShowService.fetchSubsribedShows()
            isLoading = false
        } catch _ {
            isLoading = false
        }
    }
    
}
