//
//  SearchViewController.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/8/24.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    // MARK: Property
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    // MARK: Rx Binding
    func bind() {
        let input = SearchViewModel.Input(
            searchButtonTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty,
            itemSelected: tableView.rx.itemSelected
        )
        let output = viewModel.transform(input: input)
        
        output.searchList
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.trackName
                cell.artistLabel.text = element.artistName
                let imageURL = URL(string: element.artworkUrl100)
                cell.appIconImageView.kf.setImage(with: imageURL)
            }
            .disposed(by: disposeBag)
        
        output.selectedItem
            .bind(with: self, onNext: { owner, result in
                let artistImageURL = owner.imageSizeUp(urlString: result.artworkUrl100)
                let detailVC = DetailViewController()
                let detailInput = DetailViewModel.Input(
                    playButtonTap: detailVC.playButton.rx.tap,
                    trackName: result.trackName,
                    artistName: result.artistName,
                    artworkUrl100: artistImageURL,
                    previewUrl: result.previewUrl
                )
                let detailVM = DetailViewModel()
                let detailOutput = detailVM.transform(input: detailInput)
                detailVC.viewModel = detailVM
                detailVC.bind(output: detailOutput)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: 이미지 해상도 높이기
    func imageSizeUp(urlString: String) -> String {
        var url = urlString
        let index1 = url.index(url.endIndex, offsetBy: -11)
        let index2 = url.index(url.endIndex, offsetBy: -7)
        url.insert(contentsOf: "00", at: index2)
        url.insert(contentsOf: "00", at: index1)
        return url
    }
    
    // MARK: Configure UI
    func configure() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        tableView.rowHeight = 100
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        navigationItem.titleView = searchBar
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: SearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
