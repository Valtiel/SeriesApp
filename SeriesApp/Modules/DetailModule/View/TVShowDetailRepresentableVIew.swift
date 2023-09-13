//
//  TVShowDetailRepresentableVIew.swift
//  SeriesApp
//
//  Created by César Rosales on 11/09/2023.
//

import Foundation
import SwiftUI

struct TVShowDetailRepresentableView: UIViewRepresentable {
    typealias UIViewType = UIKitTVShowDetailView
    
    func makeUIView(context: Context) -> UIKitTVShowDetailView {
        UIKitTVShowDetailView()
        
    }
    
    func updateUIView(_ uiView: UIKitTVShowDetailView, context: Context) {
        //        uiView.attributedText = text
        uiView.load()
    }
    
}
