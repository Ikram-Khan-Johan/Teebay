//
//  ProductVM.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 17/6/25.
//

import Foundation


protocol ProductVMDelegate: CommonViewModelDelegate {
    
}

class ProductVM {
    
    private let apiService = ApiService.shared
    weak var delegate: ProductVMDelegate?
    
    init(_ delegate: ProductVMDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: Self.self))")
    }
    
    var products : AllProductModel = []
    
    func getProducts() {
        
        self.delegate?.showSpinner()
            Task {
                do {
                    let result = try await ApiService.shared.product.getProducts()
                    switch result {
                    case .success(let response):
                        self.products = response
                        print("My Products", self.products)
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
