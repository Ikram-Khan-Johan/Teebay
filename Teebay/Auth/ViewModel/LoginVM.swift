//
//  LoginVM.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 16/6/25.
//

import Foundation

protocol LoginVMDelegate: CommonViewModelDelegate {
    
}

class LoginVM {
    
    private let apiService = ApiService.shared
    weak var delegate: LoginVMDelegate?
    
    init(_ delegate: LoginVMDelegate) {
        self.delegate = delegate
    }
    
    var loginResponse: LoginResponseModel?
    
    deinit {
        print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: Self.self))")
    }
    
    
    func login(params: [String: Any]) {
        
        self.delegate?.showSpinner()
            Task {
                do {
                    let result = try await ApiService.shared.auth.login(parameters: params)
                    switch result {
                    case .success(let response):
                        self.loginResponse = response
                        if let data = loginResponse {
                            print("Successfully registered user", data )
                        }
                        self.delegate?.dataLoaded()
                    case .failure(let error):
                        let errorModel = error as LoginErrorModel
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
