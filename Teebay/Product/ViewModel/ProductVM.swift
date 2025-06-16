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
    
    func getProducts() {
        
    }
    
}
