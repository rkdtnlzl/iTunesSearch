//
//  DetailViewModel.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
    
    struct Input {
        let playButtonTap: ControlEvent<Void>
        let trackName: String
        let artistName: String
        let artworkUrl100: String
        let previewUrl: String
    }
    
    struct Output {
        let trackName: Observable<String>
        let artistName: Observable<String>
        let artworkUrl100: Observable<URL>
        let playVideo: Observable<URL>
    }
    
    func transform(input: Input) -> Output {
        let trackName = Observable.just(input.trackName)
        let artistName = Observable.just(input.artistName)
        let artworkUrl100 = Observable.just(URL(string: input.artworkUrl100)!)
        
        let playVideo = input.playButtonTap
            .compactMap { URL(string: input.previewUrl) }
        
        return Output(
            trackName: trackName,
            artistName: artistName,
            artworkUrl100: artworkUrl100,
            playVideo: playVideo
        )
    }
}
