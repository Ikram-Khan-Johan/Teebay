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
                
                let url = API.shared.auth.login
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
}
