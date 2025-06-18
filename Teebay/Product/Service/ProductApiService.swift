//
//  ProductApiService.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 17/6/25.
//

import Foundation
import Alamofire
class ProductApiService {
    
    func getProducts() async throws -> Result<AllProductModel, Error> {
            return try await withCheckedThrowingContinuation { continuation in
                
                let url = API.shared.product.getProducts
                AF.request(url,
                           method: .get,
                           encoding: JSONEncoding.default)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    guard let statusCode = response.response?.statusCode else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                        return
                    }

                    switch response.result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        if statusCode == 200 || statusCode == 201  {
                            do {
                                let success = try decoder.decode(AllProductModel.self, from: data)
                                continuation.resume(returning: .success(success))
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        } else {
                            do {
                                let errorResponse = try decoder.decode(LoginErrorModel.self, from: data)
                                continuation.resume(returning: .failure(errorResponse))
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }

                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    
    
//    func saveProduct(
//        title: String,
//        description: String,
//        categories: [String],
//        imageData: Data,
//        purchasePrice: String,
//        rentPrice: String,
//        rentOption: String
//    ) {
//        // Replace with your local IP if running on physical device
//        let url = API.shared.product.createProduct
//            .replacingOccurrences(of: " ", with: "%20")
//        
//        let headers: HTTPHeaders = [
//            "Content-Type": "multipart/form-data"
//        ]
//        
//        AF.upload(multipartFormData: { formData in
//               formData.append(Data(title.utf8), withName: "title")
//               formData.append(Data(description.utf8), withName: "description")
//           for category in categories {
//                formData.append(Data(category.utf8), withName: "categories[]")
//            }
//            formData.append(Data(purchasePrice.utf8), withName: "purchase_price")
//            formData.append(Data(rentPrice.utf8), withName: "rent_price")
//            formData.append(Data(rentOption.utf8), withName: "rent_option")
//               formData.append(imageData, withName: "product_image", fileName: "product.jpg", mimeType: "image/jpeg")
//           }, to: url, method: .post, headers: headers)
//           .validate()
//           .responseDecodable(of: AllProductModelElement.self) { response in
//               switch response.result {
//               case .success(let product):
//                   print("✅ Product Created: \(product)")
//               case .failure(let error):
//                   print("❌ Decoding Error: \(error.localizedDescription)")
//               }
//           }
//    }
//
    
    func getProductCategories() async throws -> Result<ProductCategoriesModel, Error> {
        
            return try await withCheckedThrowingContinuation { continuation in
                
                let url = API.shared.product.getProductCategories
                
                AF.request(url,
                           method: .get,
                           encoding: JSONEncoding.default)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    guard let statusCode = response.response?.statusCode else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                        return
                    }

                    switch response.result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        if statusCode == 200 || statusCode == 201  {
                            do {
                                let success = try decoder.decode(ProductCategoriesModel.self, from: data)
                                continuation.resume(returning: .success(success))
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        } else {
                            do {
                                let errorResponse = try decoder.decode(LoginErrorModel.self, from: data)
                                continuation.resume(returning: .failure(errorResponse))
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }

                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    
    func createProduct(
        title: String,
        description: String,
        categories: [String],
        imageData: Data,
        purchasePrice: String,
        rentPrice: String,
        rentOption: String,
        sellerId: String
    ) async throws ->  Result<AllProductModelElement, Error> {
        let url = API.shared.product.createProduct
            .replacingOccurrences(of: " ", with: "%20")

        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        return try await withCheckedThrowingContinuation { continuation in
           

            AF.upload(
                multipartFormData: { formData in
                    formData.append(Data(sellerId.utf8), withName: "seller")
                       formData.append(Data(title.utf8), withName: "title")
                       formData.append(Data(description.utf8), withName: "description")
                   for category in categories {
                        formData.append(Data(category.utf8), withName: "categories[]")
                    }
                    formData.append(Data(purchasePrice.utf8), withName: "purchase_price")
                    formData.append(Data(rentPrice.utf8), withName: "rent_price")
                    formData.append(Data(rentOption.utf8), withName: "rent_option")
                       formData.append(imageData, withName: "product_image", fileName: "product_1.jpg", mimeType: "image/jpeg")
                   }, to: url, method: .post, headers: headers)
            .validate()
            .responseData { response in
                guard let statusCode = response.response?.statusCode else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }

                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if statusCode == 200 || statusCode == 201  {
                        do {
                            let success = try decoder.decode(AllProductModelElement.self, from: data)
                            continuation.resume(returning: .success(success))
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    } else {
                        do {
                            let errorResponse = try decoder.decode(LoginErrorModel.self, from: data)
                            continuation.resume(returning: .failure(errorResponse))
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func deleteProduct(productId: String, completion: @escaping (Result<Void, AFError>) -> Void) {
        let url = API.shared.product.deleteProduct
            .replacingOccurrences(of: " ", with: "%20")
            .replacingOccurrences(of: "{$id}", with: productId)

        print("URL ==> \(url)")
        AF.request(url, method: .delete).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                // Assuming success returns no body
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
   
}
