//
//  Api.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//

import Foundation

let baseUrl = "http://192.168.10.123:8000/"


struct API {
    
    public static let shared = API()
    let auth = AuthApi()
    let product = ProductApi()
}

struct AuthApi {
    let register = baseUrl + "api/users/register/"
    let login = baseUrl + "api/users/login/"
}

struct ProductApi {
    let getProducts = baseUrl + "api/products/"
    let createProduct = baseUrl + "api/products/"
}
