//
//  AuthVM.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//

import Foundation
import Alamofire

protocol AuthVMDelegate: CommonViewModelDelegate {
    
}

class AuthVM {
    
    private let apiService = ApiService.shared
    weak var delegate: AuthVMDelegate?
    
    init(_ delegate: AuthVMDelegate) {
        self.delegate = delegate
    }
    
    var resigsterSuccessdata: RegisterUserModel?
    deinit {
        print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: Self.self))")
    }
    
    func registerUser(params: [String : Any]) {
        
        Task {
            do {
                let response = try await apiService.auth.registerUser(params: params)
               
                self.resigsterSuccessdata = response
                
                if let data = resigsterSuccessdata {
                    print("Successfully registered user", data )
                }
               
                self.delegate?.dataLoaded()
            } catch {
                // Extract the actual error message or create a custom error handler
               
                if let afError = error as? AFError {
                    // Handle specific AFError if needed
//                    errorMessage = "Network error: \(afError.localizedDescription)"
                    print("Network error: \(afError.localizedDescription)")
                    self.delegate?.failedWithError(code: 0, message: afError.localizedDescription)
                } else if let urlError = error as? URLError {
                    // Handle URL error
//                    errorMessage = "URL error: \(urlError.localizedDescription)"
                  print("URL error: \(urlError.localizedDescription)")
                    self.delegate?.failedWithError(code: 0, message: urlError.localizedDescription)
                } else {
                    // For other errors
                    debugPrint("Api Error:", error)
                    
                }
                
               
            }
        }
    }
    
    
    func register(params: [String : Any]) {
        self.delegate?.showSpinner()
            Task {
                do {
                    let result = try await ApiService.shared.auth.register(parameters: params)
                    switch result {
                    case .success(let response):
                        self.resigsterSuccessdata = response
                        if let data = resigsterSuccessdata {
                            print("Successfully registered user", data )
                        }
                        self.delegate?.dataLoaded()
                    case .failure(let error):
                        let errorModel = error as RegisterErrorModel
                        print("Eroor \(errorModel.email?.first ?? "")")
                        self.delegate?.failedWithError(code: 0, message: errorModel.email?.first ?? "" )
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
