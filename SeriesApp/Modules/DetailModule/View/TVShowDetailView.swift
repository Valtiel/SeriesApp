//
//  TVShowDetailView.swift
//  SeriesApp
//
//  Created by César Rosales on 06/09/2023.
//

import SwiftUI

struct TVShowDetailView: View {
    
    @ObservedObject var viewModel: TVShowDetailViewModel
    @State var tvShow: TVShow
    @State var imageHeight: CGFloat = 273
    @State var imageWidth: CGFloat = 182
    
    enum Constants {
        static let imageWidth: CGFloat = 182
        static let imageHeight: CGFloat = 237
    }
    
    var body: some View {
        
        VStack {
            AsyncImage(url: URL(string: viewModel.getFormattedPosterUrl(tvShow: tvShow, width: 500)))
            { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                case .success(let image):
                    image
                        .resizable()
                case .failure:
                    Image(systemName: "wifi.slash")
                @unknown default:
                    Image(systemName: "wifi.slash")
                }
            }.frame(width: imageWidth, height: imageHeight)
                .cornerRadius(4)
            ScrollView {
                
                Text(tvShow.name)
                    .foregroundColor(.white)
                Text("\(tvShow.firstAirDate)")
                    .foregroundColor(.white)
                
                Button(action: {
                    Task {
                        do {
                            try await viewModel.addNewSubscribtion(tvShow)
                        } catch _ {
                            
                        }
                    }
                }) {
                    Text("SUSCRIBIRME")
                        .frame(minWidth: 0, maxWidth: 200)
                        .font(.system(size: 16).bold())
                        .padding(14)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                
                Text("Overview")
                    .foregroundColor(.white)
                    .padding(.top, 37)
                    .padding(.leading, 37)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text(tvShow.overview)
                    .foregroundColor(.white)
                    .padding(37)
                
            }
        }
        .background(AsyncImage(url: URL(string: viewModel.getFormattedBackdropUrl(tvShow: tvShow, width: 500)))
                    { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                Color.black.opacity(0.2)
                    .ignoresSafeArea(.all)
            case .failure:
                Image(systemName: "wifi.slash")
            @unknown default:
                EmptyView()
            }
        }
        )
        
    }
}

extension TVShowDetailView {
    private func resizeImage(offset: CGFloat) {
        //        let scale = (Constants.imageHeight - offset) / Constants.imageHeight
        //        imageWidth = CGFloat(Constants.imageWidth * scale)
        //        imageHeight = CGFloat(Constants.imageHeight * scale)
        imageHeight = imageHeight - 1
    }
}



struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = TVShowDetailViewModel(tvShowService: MockTVShowService(), subscribedShowService: MockSubscribedShowService())
        TVShowDetailView(viewModel: mockViewModel, tvShow: TVShow.mock())
    }
}

enum ScrollOffsetNamespace {
    
    static let namespace = "scrollView"
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct ScrollViewOffsetTracker: View {
    
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geo.frame(in: .named(ScrollOffsetNamespace.namespace)).origin
                )
        }
        .frame(height: 0)
    }
}

private extension ScrollView {
    
    func withOffsetTracking(
        action: @escaping (_ offset: CGPoint) -> Void
    ) -> some View {
        self.coordinateSpace(name: ScrollOffsetNamespace.namespace)
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: action)
    }
}
