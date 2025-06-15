//
//  ApiService.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//


import Foundation
import Alamofire

class ApiService {

    private static var instance: ApiService?
    
    public static var shared: ApiService {
        if instance == nil {
            instance = ApiService()
        }
        return instance!
    }

    func dispose() {
        ApiService.instance = nil
        print("Disposed Singleton instance")
    }

    public let sessionManager: Session
    
    private init() {
        let configuration = URLSessionConfiguration.af.default
//        let interceptor = CustomRequestInterceptor()
        
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        if #available(iOS 13.0, *) {
            configuration.allowsExpensiveNetworkAccess = true
            configuration.allowsConstrainedNetworkAccess = true
        }
        
        sessionManager = Session(configuration: configuration)
    }
    
  
    lazy var auth = AuthApiSevice()
   
}
