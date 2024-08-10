//
//  Search.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/8/24.
//

import Foundation

struct Search: Decodable {
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let artworkUrl100: String
    let trackName: String
    let artistName: String
    let previewUrl: String
}
