//
//  BaseViewController.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 26.08.2024.
//

import UIKit

class BaseViewController<VM: BaseViewModelProtocol>: UIViewController, BaseViewControllerProtocol {
    var viewModel: VM
    private var activityIndicator: UIActivityIndicatorView!

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        prepareActivityIndicator()
    }

    func prepareActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = view.center
        activityIndicator?.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func showLoading() {
        activityIndicator?.startAnimating()
    }

    func hideLoading() {
        activityIndicator?.stopAnimating()
    }
}
