//
//  WelcomeViewController.swift
//  Instafilter
//
//  Created by Aleksandra Nikiforova on 22/03/23.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
        
    private let imageView: UIImageView = {
        let imageName = "picture"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Welcome to PhotoEditor"
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        nameLabel.textColor = UIColor.tintColor
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let greetLabel: UILabel = {
        let hiLabel = UILabel()
        hiLabel.text = "Let's turn your photos into stunning works of art!"
        hiLabel.textColor = UIColor.tintColor
        hiLabel.font = UIFont.systemFont(ofSize: 16)
        hiLabel.translatesAutoresizingMaskIntoConstraints = false
        return hiLabel
    }()
    
    let buttonView: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Start editing", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(named: "ButtonGreen")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 5
        
        btn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func didTapButton() {
        let mainScreen = FilterImageViewController()
        navigationController?.pushViewController(mainScreen, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackColor")
        setupConstrains()
    }
    
    private func setupConstrains() {
        view.backgroundColor = UIColor(named: "BackColor")
        let welcomeView = UIView()
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        welcomeView.addSubview(imageView)
        welcomeView.addSubview(nameLabel)
        welcomeView.addSubview(greetLabel)
        view.addSubview(welcomeView)
        view.addSubview(buttonView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: welcomeView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 240),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: welcomeView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: welcomeView.trailingAnchor),
            
            greetLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            greetLabel.leadingAnchor.constraint(equalTo: welcomeView.leadingAnchor),
            greetLabel.trailingAnchor.constraint(equalTo: welcomeView.trailingAnchor),
            greetLabel.bottomAnchor.constraint(equalTo: welcomeView.bottomAnchor),
            
            welcomeView.widthAnchor.constraint(greaterThanOrEqualTo: greetLabel.widthAnchor, multiplier: 1),
            welcomeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
