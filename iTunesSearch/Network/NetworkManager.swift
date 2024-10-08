//
//  NetworkManager.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/8/24.
//

import Foundation
import Alamofire
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func fetchSearch(term: String) -> Single<Search> {
        let urlString = "https://itunes.apple.com/search?term=\(term)&entity=musicVideo"
        
        return Single.create { observer -> Disposable in
            guard let url = URL(string: urlString) else {
                observer(.failure(APIError.invalidURL))
                return Disposables.create()
            }
            
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Search.self) { response in
                    switch response.result {
                    case .success(let searchResult):
                        observer(.success(searchResult))
                    case .failure:
                        observer(.failure(APIError.unknownResponse))
                    }
                }
            
            return Disposables.create()
        }.debug("조회")
    }
    
    //    func fetchSearch(term: String) -> Observable<Search>{
    //        let url = "https://itunes.apple.com/search?term=\(term)&entity=musicVideo"
    //
    //        let result = Observable<Search>.create { observer in
    //            guard let url = URL(string: url) else {
    //                observer.onError(APIError.invalidURL)
    //                return Disposables.create()
    //            }
    //
    //            URLSession.shared.dataTask(with: url) {data, response, error in
    //                if error != nil {
    //                    observer.onError(APIError.unknownResponse)
    //                    return
    //                }
    //
    //                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
    //                    observer.onError(APIError.statusError)
    //                    return
    //                }
    //
    //                if let data = data,
    //                   let appData = try? JSONDecoder().decode(Search.self, from: data) {
    //                    observer.onNext(appData)
    //                    observer.onCompleted()
    //                } else {
    //                    print("응답이 왔으나 디코딩 실패")
    //                    observer.onError(APIError.unknownResponse)
    //                }
    //            }.resume()
    //
    //            return Disposables.create()
    //        }.debug("조회")
    //
    //        return result
    //    }
}
