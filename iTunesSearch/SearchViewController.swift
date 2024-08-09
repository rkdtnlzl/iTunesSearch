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
        let input = SearchViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.searchList
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.trackName
                cell.artistLabel.text = element.artistName
                if let url = element.artworkUrl100 {
                    let imageURL = URL(string: url)
                    cell.appIconImageView.kf.setImage(with: imageURL)
                }
            }
            .disposed(by: disposeBag)
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
