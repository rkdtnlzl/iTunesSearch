//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift

class DetailViewController: UIViewController {
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    var viewModel: DetailViewModel?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        configure()
        bind()
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.trackName
        artistLabel.text = viewModel.artistName
        if let url = viewModel.artworkUrl100, let imageURL = URL(string: url) {
            titleImageView.kf.setImage(with: imageURL)
        }
    }
    
    private func configure() {
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
        view.addSubview(artistLabel)
        
        titleImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
