//
//  DiskSubscribedShowsService.swift
//  SeriesApp
//
//  Created by César Rosales on 07/09/2023.
//

import Foundation

class DiskSubscribedShowsService: SubscribedShowsService {
    
    private let filename = "subscribedData.json"
    
    func getFileURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first
    }
    
    func fetchSubsribedShows() async throws -> [TVShow] {
        if let url = getFileURL() {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONDecoder().decode([TVShow].self, from: data)
            return jsonObject
        }
        return []
    }
    
    func saveSubscriptions(_ tvShows: [TVShow]) async throws {
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            var alreadyThere = Set<TVShow>()
            let dataWithoutDuplicates = tvShows.compactMap { (show) -> TVShow? in
                guard !alreadyThere.contains(show) else { return nil }
                alreadyThere.insert(show)
                return show
            }
            let data = try JSONEncoder().encode(dataWithoutDuplicates)
            guard fileManager.fileExists(atPath: fileURL.path) else {
                fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)
                return
            }
            try data.write(to: fileURL, options: [.atomicWrite])
        }
        
    }
    
    func addNewSubscription(_ tvShow: TVShow) async throws {
        do {
            var currentData = try await fetchSubsribedShows()
            currentData.append(tvShow)
            try await saveSubscriptions(currentData)
        } catch _ {
            try await saveSubscriptions([tvShow])
        }

        
    }
    
    
}
