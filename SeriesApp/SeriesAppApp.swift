//
//  SeriesAppApp.swift
//  SeriesApp
//
//  Created by César Rosales on 04/09/2023.
//

import SwiftUI

@main
struct SeriesAppApp: App {
    var body: some Scene {
        WindowGroup {
            
            
            let tvService = TMDBTVShowService(apiKey: "016f3689a332c33061fd8fb762b6734c")
            let subscriptionsService = DiskSubscribedShowsService()
            let viewModel = HomeViewModel(tvShowService: tvService, subscribedShowService: subscriptionsService)
            
            HomeView(viewModel: viewModel)
            
            
        }
    }
}
