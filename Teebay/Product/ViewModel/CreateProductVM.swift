//
//  CreateProductVM.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//

import Foundation

protocol CreateProductVMDelegate: CommonViewModelDelegate {}

class CreateProductVM {
    
    private let apiService = ApiService.shared
    weak var delegate: CreateProductVMDelegate?
    
    init(_ delegate: CreateProductVMDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: Self.self))")
    }
    
    
    func createProduct(
        title: String,
        description: String,
        categories: [String],
        imageData: Data,
        purchasePrice: String,
        rentPrice: String,
        rentOption: String
    )
    {
        self.delegate?.showSpinner()
        Task {
            do {
                let result = try await ApiService.shared.product.createProduct(title: title, description: description, categories: categories, imageData: imageData, purchasePrice: purchasePrice, rentPrice: rentPrice, rentOption: rentOption)
                switch result {
                case .success(let response):
                    
                    print("My Products", response)
                    self.delegate?.dataLoaded()
                case .failure(let error):
                    let errorModel = error as! LoginErrorModel
                    print("Error \(errorModel.error ?? "")")
                    self.delegate?.failedWithError(code: 0, message: errorModel.error ?? "" )
                }
            } catch {
                print("Error msg \(error.localizedDescription)")
                //                    self.errorMessage = error.localizedDescription
                //                    self.user = nil
                self.delegate?.failedWithError(code: 0, message: error.localizedDescription )
            }
            
            self.delegate?.hideSpinner()
        }
    }
}
