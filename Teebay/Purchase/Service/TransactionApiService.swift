//
//  TransactionApiService.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//

import Alamofire

class TransactionApiService {
    
    func postRental(_ rental: RentalRequestMdoel) async throws {
       
        return try await withCheckedThrowingContinuation { continuation in
            let url = API.shared.transaction.postRenatal
                .replacingOccurrences(of: " ", with: "%20")
            
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json"
                ]

                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601

                AF.request(
                    url,
                    method: .post,
                    parameters: rental,
                    encoder: .json(encoder: encoder),
                    headers: headers
                )
                .validate(statusCode: 200..<300)
                .responseDecodable(of: EmptyResponse.self) { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
    }
    

    func buyProduct(_ buyModel: BuyRequestModel) async throws {
       
        return try await withCheckedThrowingContinuation { continuation in
            let url = API.shared.transaction.buyProduct
                .replacingOccurrences(of: " ", with: "%20")
            
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json"
                ]

                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601

                AF.request(
                    url,
                    method: .post,
                    parameters: buyModel,
                    encoder: .json(encoder: encoder),
                    headers: headers
                )
                .validate(statusCode: 200..<300)
                .responseDecodable(of: EmptyResponse.self) { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
    }
}
