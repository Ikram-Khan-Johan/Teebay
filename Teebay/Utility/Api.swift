//
//  Api.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//

import Foundation

let baseUrl = "http://127.0.0.1:8000/"


struct API {
    
    public static let shared = API()
    let auth = AuthApi()
    let product = ProductApi()
    let transaction = PurchaseApi()
}

struct AuthApi {
    let register = baseUrl + "api/users/register/"
    let login = baseUrl + "api/users/login/"
}

struct ProductApi {
    let getProducts = baseUrl + "api/products/"
    let createProduct = baseUrl + "api/products/"
    let deleteProduct = baseUrl + "api/products/{$id}/"
    let editProduct = baseUrl + "api/products/{$id}/"
    let getProductCategories = baseUrl + "api/products/categories/"
}
struct PurchaseApi {
    let postRenatal = baseUrl + "api/transactions/rentals/"
    let buyProduct = baseUrl + "api/transactions/purchases/"
}
