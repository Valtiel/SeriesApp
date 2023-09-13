//
//  HomeView.swift
//  SeriesApp
//
//  Created by César Rosales on 04/09/2023.
//

import SwiftUI


struct HomeView: View {
    
    @EnvironmentObject var router: AppRouter
    @ObservedObject var viewModel: HomeViewModel
    @State private var query = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    SubscribedCarousel(viewModel: viewModel, title: "Suscritas").padding(20)
                    TVShowsList(viewModel: viewModel, title: "TODOS").padding(20)
                }
            }.task {
                await viewModel.refresh()
            }
            .background(Color.black)
            .navigationDestination(for: RouterDestination.self) { destination in
                router.route(destination: destination)
            }
            .preferredColorScheme(.dark).refreshable {
                await viewModel.refresh()
            }
            .searchable(
                text: $query,
                placement: .toolbar,
                prompt: "Type something..."
            )
            .navigationTitle("TV Show Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: query) { newQuery in
                Task {
                    await viewModel.search(by: query)
                }
            }.overlay {
                if viewModel.isSearching && !query.isEmpty {
                    TVShowSearchListView(viewModel: viewModel, query: $query).frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if viewModel.isLoading {
                    LoadingView().frame(maxWidth: .infinity, maxHeight: .infinity).background() {
                        Color.black
                    }
                }
            }
        }
    }
    
}

struct LoadingView: View {
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            Text("WAITING FOR API... ")
                .foregroundColor(.white)
        }
    }
}

struct TVShowSearchListView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var query: String
    
    var body: some View {
        
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.foundTVShows.indices, id: \.self) { index in
                        let tvShow = viewModel.foundTVShows[index]
                        NavigationLink(value: RouterDestination.details(tvShow: tvShow)) {
                            TVShowSearchView(viewModel: viewModel, tvShow: tvShow)
                                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                                .padding(15)
                        }.task {
                            await viewModel.loadMoreSearchContent(index: index)
                        }
                        Divider()
                    }
                }
            }
            
        }.background(Color.black)
    }
}

struct TVShowSearchView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State var tvShow: TVShow
    @State var isSubscribed = false
    
    var body: some View {
        HStack {
            
            let url = viewModel.getFormattedPosterUrlForSearch(tvShow: tvShow, width: 500)
            let isSubscribed = viewModel.isSubscribed(tvShow)
            let genre = ""
            AsyncImage(url: URL(string: url))
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
                    EmptyView()
                }
            }.frame(maxWidth: 48, maxHeight: 72)
                .cornerRadius(4)
                .animation(.easeInOut(duration: 0.5))
            
            VStack {
                Text(tvShow.name)
                    .foregroundColor(.white)
//                Text(tvShow.genre)
//                    .foregroundColor(.white)
            }
            Spacer()
            Button(action: {
                Task {
                    await viewModel.addNewSubscribe(tvShow)
                }
            }) {
                
                if isSubscribed {
                    Text("AGREGADO")
                        .frame(minWidth: 0, maxWidth: 79)
                        .font(.system(size: 16).bold())
                        .padding(14)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.white, lineWidth: 1)
                        )
                } else {
                    Text("AGREGAR")
                        .frame(minWidth: 0, maxWidth: 79)
                        .font(.system(size: 16).bold())
                        .padding(14)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                
            }
            
        }.background(Color.black)
            .task {
                isSubscribed = viewModel.isSubscribed(tvShow)
            }
        
    }
    
}


struct TVShowsList: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(Color.white.opacity(0.56))
                .padding(.bottom, 13)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVStack {
                ForEach(viewModel.tvShows.indices, id: \.self) { index in
                    let tvShow = viewModel.tvShows[index]
                    let url = viewModel.getFormattedBackdropUrl(index: index, width: 500)
                    
                    NavigationLink(value: RouterDestination.details(tvShow: tvShow)) {
                        TVShowCard(name: tvShow.name, url: url, tags: [""])
                            .frame(maxWidth: .infinity, minHeight: 156, maxHeight: 156)
                    }.task {
                        await viewModel.loadMoreContent(index: index)
                    }
                }
                
            }
        }
    }
    
}

struct SubscribedCarousel: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    let title: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("SUSCRIPTAS")
                .foregroundColor(Color.white.opacity(0.56))
                .padding(.bottom, 13)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.subscribedTVShows.indices, id: \.self) { index in
                        let tvShow = viewModel.subscribedTVShows[index]
                        NavigationLink(value: RouterDestination.details(tvShow: tvShow)) {
                            let url = viewModel.getFormattedPosterUrl(index: index, width: 500)
                            SubscribedShowCard(url: url)
                                .frame(width: 100, height: 150)
                        }
                    }
                }
            }
        }
    }
    
}

struct SubscribedShowCard: View {
    
    @State var url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url))
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
                EmptyView()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(4)
            .animation(.easeInOut(duration: 0.5))
    }
}

struct TVShowCard: View {
    
    @State var name: String
    @State var url: String
    @State var tags: [String]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack() {
                ForEach(tags.indices) {
                    indice in
                    Text(tags[indice])
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color(hex:0xe1f5ff))
                }
                
            }.frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
            
            Text(name)
                .font(.title)
                .bold()
                .foregroundColor(Color(hex:0xe1f5ff))
                .padding(20)
            
            
        }
        .background(
            AsyncImage(url: URL(string: url))
            { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    LinearGradient(gradient: Gradient(colors: [Color(hex: 0x3c5663)
                                                               , Color(hex: 0x091920)]), startPoint: .top, endPoint: .bottom)
                    .blendMode(.color)
                    
                case .failure:
                    Image(systemName: "wifi.slash")
                @unknown default:
                    EmptyView()
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        )
        .cornerRadius(4)
        .clipped()
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockTVService = MockTVShowService()
        let mockSubscribedService = MockSubscribedShowService()
        let viewModel = HomeViewModel(tvShowService: mockTVService, subscribedShowService: mockSubscribedService)
        HomeView(viewModel: viewModel)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
