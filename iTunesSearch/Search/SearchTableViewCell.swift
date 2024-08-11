//
//  SearchTableViewCell.swift
//  iTunesSearch
//
//  Created by 강석호 on 8/8/24.
//

import UIKit
import SnapKit

final class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
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
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        return button
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(downloadButton)
        
        appIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-17)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        artistLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(17)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        downloadButton.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(72)
        }
    }
}
