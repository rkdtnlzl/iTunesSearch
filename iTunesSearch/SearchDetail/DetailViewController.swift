//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import WebKit
import AVFoundation
import AVKit

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
    
    let preview: UIImageView = {
        let view = UIImageView()
        let darkOverlay = UIView()
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(darkOverlay)
        darkOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .gray
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    var viewModel: DetailViewModel?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        configure()
        bind()
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    @objc func playButtonTapped() {
        print(#function)
        guard let viewModel = viewModel, let urlString = viewModel.previewUrl, let previewURL = URL(string: urlString) else {
            return
        }
        let player = AVPlayer(url: previewURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.trackName
        artistLabel.text = viewModel.artistName
        
        if let url = viewModel.artworkUrl100, let imageURL = URL(string: url) {
            titleImageView.kf.setImage(with: imageURL)
            preview.kf.setImage(with: imageURL)
            
        }
    }
    
    private func configure() {
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
        view.addSubview(artistLabel)
        view.addSubview(preview)
        view.addSubview(playButton)
        
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
        preview.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom).offset(60)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
        playButton.snp.makeConstraints { make in
            make.center.equalTo(preview)
            make.size.equalTo(70)
        }
    }
}
