//
//  BaseViewController.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 26.08.2024.
//

import UIKit

class BaseViewController: UIViewController {
    private var activityIndicator: UIActivityIndicatorView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        prepareActivityIndicator()
        prepareNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLoading), name: .showLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideLoading), name: .hideLoading, object: nil)
    }
    
    private func prepareNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .primaryBlue
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: .largePoint)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        if navigationController?.viewControllers.count ?? 0 <= 1 {
            let titleLabel = UILabel()
            titleLabel.text = self.title?.isEmpty == false ? self.title : TextConstants.eMarket.rawValue
            titleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            titleLabel.font = UIFont.boldSystemFont(ofSize: .largePoint)
            titleLabel.sizeToFit()
            
            let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
            navigationItem.leftBarButtonItem = leftBarButtonItem
        } else {
            let backButtonImage = UIImage(systemName: SystemImages.leftArrow.rawValue)
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
            backButton.tintColor = .white
            
            navigationItem.leftBarButtonItem = backButton
            self.title = self.title?.isEmpty == false ? self.title : TextConstants.eMarket.rawValue
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func prepareActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = view.center
        activityIndicator?.hidesWhenStopped = true
        activityIndicator.color = .primaryBlue
        view.addSubview(activityIndicator)
    }
    
    @objc func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }
    }

    @objc func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
        }
    }
}
