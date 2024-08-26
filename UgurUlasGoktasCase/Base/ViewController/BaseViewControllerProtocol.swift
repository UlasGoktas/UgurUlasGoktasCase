//
//  BaseViewControllerProtocol.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 26.08.2024.
//

protocol BaseViewControllerProtocol: AnyObject {
    associatedtype ViewModel: BaseViewModelProtocol
    var viewModel: ViewModel { get set }
}
