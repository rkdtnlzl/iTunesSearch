//
//  SearchViewModel.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let searchList: Observable<[SearchResult]>
    }
    
    func transform(input: Input) -> Output {
        
        let searchList = PublishSubject<[SearchResult]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .flatMap { value in
                NetworkManager.shared.fetchSearch(term: value)
            }
            .subscribe(with: self, onNext: { owner, search in
                dump(search)
                searchList.onNext(search.results)
            }, onError: { owner, error in
                print("error: \(error)")
            }, onCompleted: { owner in
                print("onCompleted")
            }, onDisposed: { owner in
                print("onDisposed")
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 글자 인식 \(value)")
            }
            .disposed(by: disposeBag)
        
        return Output(searchList: searchList)
    }
}
