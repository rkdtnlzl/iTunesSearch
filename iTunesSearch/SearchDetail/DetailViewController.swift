//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit

class DetailViewController: UIViewController {
    
    // MARK: Property
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
    let disposeBag = DisposeBag()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    // MARK: Rx Binding
    func bind(output: DetailViewModel.Output) {
        output.trackName
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.artistName
            .bind(to: artistLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.artworkUrl100
            .bind(with: self, onNext: { owner, url in
                owner.titleImageView.kf.setImage(with: url)
                owner.preview.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        output.playVideo
            .bind(with: self, onNext: { owner, url in
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                owner.present(playerViewController, animated: true) {
                    player.play()
                }
            })
            .disposed(by: disposeBag)
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
