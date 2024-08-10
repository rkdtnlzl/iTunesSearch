//
//  DetailViewModel.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/9/24.
//

import Foundation
import RxSwift

class DetailViewModel {
    
    let trackName: String
    let artistName: String
    let artworkUrl100: String?
    let previewUrl: String?
    
    init(trackName: String, artistName: String, artworkUrl100: String?, previewUrl: String?) {
        self.trackName = trackName
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
    }
}
