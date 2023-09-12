//
//  RouterDestination.swift
//  SeriesApp
//
//  Created by César Rosales on 11/09/2023.
//

import Foundation

enum RouterDestination: Hashable {
    
    case details(tvShow: TVShow)
    case home
    case search
    
}
