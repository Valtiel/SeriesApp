//
//  AppRouter.swift
//  SeriesApp
//
//  Created by César Rosales on 11/09/2023.
//

import Foundation
import SwiftUI

@MainActor
class AppRouter: ObservableObject {
    
    let tvShowService: TVShowService
    let subscribedShowService: SubscribedShowsService
    
    init(tvShowService: TVShowService, subscribedShowService: SubscribedShowsService) {
        self.tvShowService = tvShowService
        self.subscribedShowService = subscribedShowService
    }
    
    @ViewBuilder func start() -> some View {
        createHomeView().environmentObject(self)
       
    }
    
    @ViewBuilder func route(destination: RouterDestination) -> some View {
        switch destination {
        case .home:
            createHomeView()
        case .details(let tvShow):
            createDetailView(tvShow: tvShow)
//            createDetailViewRepresentable(tvShow: tvShow)
        case .search:
            createHomeView()
        }
    }
    
    @ViewBuilder private func createDetailView(tvShow: TVShow) -> some View {
        let viewModel = TVShowDetailViewModel(tvShowService: tvShowService, subscribedShowService: subscribedShowService)
        
        TVShowDetailView(viewModel: viewModel, tvShow: tvShow)
    }
    
    @ViewBuilder private func createDetailViewRepresentable(tvShow: TVShow) -> some View {
        TVShowDetailRepresentableView()
    }
    
    @ViewBuilder private func createHomeView() -> some View {
        let viewModel = HomeViewModel(tvShowService: tvShowService, subscribedShowService: subscribedShowService)
        HomeView(viewModel: viewModel)
    }
}
