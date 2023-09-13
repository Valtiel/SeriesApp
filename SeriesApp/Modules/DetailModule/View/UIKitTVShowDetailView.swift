//
//  UIKitTVShowDetailView.swift
//  SeriesApp
//
//  Created by César Rosales on 11/09/2023.
//

import Foundation
import UIKit

class UIKitTVShowDetailView: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MOVIE TITLE"
        label.textAlignment = .center
        label.textColor = .white
        label.font = label.font.withSize(24)
        return label
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.text = "9999"
        label.textAlignment = .center
        label.textColor = .white
        label.font = label.font.withSize(16)
        return label
    }()
    
    lazy var subscribeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .black
        button.setTitle("SUSCRIBIRSE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.text = "OVERVIEW"
        label.textAlignment = .left
        label.textColor = .black
        label.font = label.font.withSize(14)
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        textView.textAlignment = .left
        textView.textColor = .white
        textView.font = textView.font?.withSize(14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var scrollView: UIScrollView = {
       let sv = UIScrollView()
       return sv
     }()
    
    private lazy var contentView: UIView = {
      let view = UIView()
      return view
    }()
    
    private func setupContentViewConstraints() {
       scrollView.addSubview(contentView)
       contentView.translatesAutoresizingMaskIntoConstraints = false
       let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
       heightConstraint.priority = UILayoutPriority(250)
       NSLayoutConstraint.activate([
         contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
         contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
         contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
         contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
         contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
         heightConstraint,
       ])
     }
     
    
    private func setupScrollViewContstraints() {
       scrollView.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
         scrollView.topAnchor.constraint(equalTo: topAnchor),
         scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
         scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
         scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
       ])
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        addSubview(scrollView)
        setupScrollViewContstraints()
        contentView.addSubview(imageView)
        setupImageConstraints()
        contentView.addSubview(titleLabel)
        setupTitleConstraints()
        contentView.addSubview(yearLabel)
        setupYearConstraints()
        contentView.addSubview(subscribeButton)
        setupSubscribeButtonConstraints()
        contentView.addSubview(overviewLabel)
        setupOverviewConstraints()
        contentView.addSubview(textView)
        setupTextViewConstraints()
        setupContentViewConstraints()
        load()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load() {
        if let url = URL(string: "https://picsum.photos/") {
            imageView.load(url: url)
        }
        layoutSubviews()

    }
    
    private func setupOverviewConstraints() {
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.topAnchor.constraint(equalTo: self.subscribeButton.bottomAnchor, constant: 23).isActive = true
        overviewLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 37).isActive = true
        overviewLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    private func setupTitleConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 23).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    private func setupYearConstraints() {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2).isActive = true
        yearLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        yearLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    private func setupSubscribeButtonConstraints() {
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.topAnchor.constraint(equalTo: self.yearLabel.bottomAnchor, constant: 22).isActive = true
        subscribeButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        subscribeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        subscribeButton.widthAnchor.constraint(equalToConstant: 195).isActive = true
    }
    
    private func setupTextViewConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.overviewLabel.bottomAnchor, constant: 43).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 43).isActive = true
        textView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 37).isActive = true
        textView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -37).isActive = true
    }
    
    private func setupImageConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 43).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 273).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 182).isActive = true
    }
    
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
