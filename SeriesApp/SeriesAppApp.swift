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
            let apiKey = PlistAppConfiguration.getApiKey()
            let tvService = TMDBTVShowService(apiKey: apiKey)
            let subscriptionsService = DiskSubscribedShowsService()
            let appRouter = AppRouter(tvShowService: tvService, subscribedShowService: subscriptionsService)
            appRouter.start()
            
        }
    }
}
