//
//  Api.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//

import Foundation

let baseUrl = "http://192.168.0.191:8000/"


struct API {
    
    public static let shared = API()
    
    let auth = AuthApi()
   
}

struct AuthApi {
    let register = baseUrl + "api/users/register/"
}
