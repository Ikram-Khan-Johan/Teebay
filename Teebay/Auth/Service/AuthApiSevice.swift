//
//  AuthApiSevice.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//

import Alamofire
import Foundation

class AuthApiSevice {
    

    func registerUser(params: [String : Any]) async throws -> RegisterUserModel {
        
        let urlString = API.shared.auth.register
           .replacingOccurrences(of: " ", with: "%20")
     
        return try await AF.asyncNetworking(url: urlString,method: .post, parameters: params, expecting: RegisterUserModel.self)
        
    }

    
    func register(parameters: [String: Any]) async throws -> Result<RegisterUserModel, RegisterErrorModel> {
            return try await withCheckedThrowingContinuation { continuation in
                let url = API.shared.auth.register
                AF.request(url,
                           method: .post,
                           parameters: parameters,
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
                                let success = try decoder.decode(RegisterUserModel.self, from: data)
                                continuation.resume(returning: .success(success))
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        } else {
                            do {
                                let errorResponse = try decoder.decode(RegisterErrorModel.self, from: data)
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
    
    func login(parameters: [String: Any]) async throws -> Result<LoginResponseModel, LoginErrorModel> {
            return try await withCheckedThrowingContinuation { continuation in
                
                let url = API.shared.auth.login
                AF.request(url,
                           method: .post,
                           parameters: parameters,
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
                                let success = try decoder.decode(LoginResponseModel.self, from: data)
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
