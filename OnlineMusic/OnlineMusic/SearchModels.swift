//
//  SearchModels.swift
//  OnlineMusic
//
//  Created by Neo Hsu on 2022/6/24.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [SearchResult]
}


struct SearchResult: Decodable {
    let trackId: Int
    let artistName: String
    let trackCensoredName: String
    let previewUrl: String
}

struct Song {
    let trackId: Int
    let artistName: String
    let trackCensoredName: String
    let previewUrl: String
}
