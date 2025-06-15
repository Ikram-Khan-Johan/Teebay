//
//  AlamofireExt.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//


import Foundation
import UIKit
import Alamofire

class CustomErrorr: Error {
    
    var code: Int = 0
    var message: String = ""
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
 
}

extension Session {
    
    public func asyncNetworking<T: Codable>(
        url convertible: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        queryParameters: Parameters? = nil,
        expecting dataType: T.Type
    ) async throws -> T {
        
        var headers2: HTTPHeaders = headers ?? [:]
        headers2["Connection"] = "close"

        
        // Append query parameters to the URL if provided
        let finalURLConvertible: URLConvertible
        
        if let queryParameters = queryParameters {
            do {
                let urlRequest = try URLRequest(url: convertible, method: method, headers: headers2)
                var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
                components?.queryItems = queryParameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
                
                if let urlWithQuery = components?.url {
                    finalURLConvertible = urlWithQuery
                } else {
                    throw CustomErrorr(code: 405, message: "NetworkError.invalidURL")
                }
            } catch {
                throw error
            }
        } else {
            finalURLConvertible = convertible
        }
        
        let request = ApiService.shared.sessionManager.request(finalURLConvertible, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers2)
        
        do {
            let data = try await request.validate().serializingData().value

            // Print the response for debugging
            debugPrintRequest(request, data)

            let model = try JSONDecoder().decode(dataType, from: data)
            return model
            
        } catch let error as AFError {

            let data = try await request.validate().serializingData().value

            // Print the response for debugging
            debugPrintRequest(request, data)

            let model = try JSONDecoder().decode(dataType, from: data)
            
            debugPrint("Api Error 1st:", error.localizedDescription)

            // Print the response for debugging
            debugPrintRequest(request, nil)

            if let data = (error as? AFError)?.underlyingError as? Data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    let message = jsonResult?["message"] as? String
                    let code = jsonResult?["status_code"] as? Int
                    debugPrint("Api Error:", message)
                    throw CustomErrorr(code: code ?? 404, message: message ?? "API error")
                } catch {
                    debugPrint("Api Error:", error.localizedDescription)
                    throw error
                }
            } else {
                debugPrint("Api Error:", error.localizedDescription)
                throw error
            }
        }
    }
    
    /// A custom method, which creates a DataRequest from a URLRequest created using the passed components.
    /// - Parameters:
    ///   - convertible: URLConvertible (String) value to be used as the URLRequest’s URL.
    ///   - method: HTTPMethod for the URLRequest. '.post' by default.
    ///   - parameter: Parameter of type Encodable to be encoded into the URLRequest.
    ///   - headers: HTTPHeaders value to be added to the URLRequest. nil by default.
    ///   - dataType: Codable model (a.k.a. Model.self) for decoding data.
    public func asyncNetworkingV2<T: Codable, P: Encodable>(url convertible: URLConvertible, method: HTTPMethod = .post, parameter: P? = nil, headers: HTTPHeaders? = nil, expecting dataType: T.Type) async throws -> T {
        
        var headers2: HTTPHeaders = headers ?? [:]
        headers2["Connection"] = "close"

        
        let request = ApiService.shared.sessionManager.request(convertible, method: method, parameters: parameter, encoder: JSONParameterEncoder.default, headers: headers2)
        
//        request
//            .responseData { response in
//            switch response.result {
//            case .success(let data):
//                // Even if status code is 400, this can be triggered.
//                if let statusCode = response.response?.statusCode, statusCode >= 400 {
//                    // Parse error body
//                    if let errorMessage = String(data: data, encoding: .utf8) {
//                        print("Server returned error: \(errorMessage)")
//                    }
//                } else {
//                    // Handle success
//                    print("Success: \(String(data: data, encoding: .utf8) ?? "")")
//                }
//
//            case .failure(let error):
//                // Network error (not server-side status code errors)
//                print("Request failed with error: \(error)")
//            }
//        }
        do {
            let data = try await request.validate().serializingData().value
            // Print the response for debugging
            debugPrintRequest(request, data)

            let model = try JSONDecoder().decode(dataType, from: data)
            return model
            
        } catch let error as AFError {
            // Print the response for debugging
            debugPrintRequest(request, nil)

            debugPrint("Api Error 1st:", error.localizedDescription)
            if let data = (error as? AFError)?.underlyingError as? Data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    let message = jsonResult?["message"] as? String
                    let code = jsonResult?["status_code"] as? Int
                    debugPrint("Api Error:", message)
                    throw CustomErrorr(code: code ?? 404, message: message ?? "API error")
                } catch {
                    debugPrint("Api Error:", error.localizedDescription)
                    throw error
                }
            } else {
                debugPrint("Api Error:", error.localizedDescription)
                throw error
            }
        }
    }
    
    fileprivate func debugPrintRequest(_ request: DataRequest, _ data: Data?) {
        // Print the response for debugging
        print("\n====================> RESPONSE START <====================")
        print("\n[Request]:", request.request?.httpMethod ?? "(No Method)", request.request?.url?.absoluteString ?? "(No Url)")
        
        let header = request.request?.allHTTPHeaderFields ?? [:]
        let headervalues = header.map { "\($0.key ): \($0.value)" }.joined(separator: "\n\t\t")
        print("\t[Headers]:\n\t\t", headervalues)
        if let httpBody = request.request?.httpBody {
            if let jsonBody = try? JSONSerialization.jsonObject(with: httpBody, options: .mutableContainers),
               let prettyPrintedBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted),
               let jsonString = String(data: prettyPrintedBody, encoding: .utf8) {
                print("\t[Body]:\n\t\t", jsonString)
            } else {
                print("\t[Body]:\n\t\t", String(data: httpBody, encoding: .utf8) ?? "Cannot decode body")
            }
        } else {
            print("\t[Body]: (No Body)")
        }
        
        print("\n[Response]:")
        print("\t[Status Code]:", request.response?.statusCode ?? "(No Status Code)")
        
        let rpHeader = request.response?.allHeaderFields ?? [:]
        let rpHeadervalues = rpHeader.map { "\($0.key ): \($0.value)" }.joined(separator: "\n\t\t")
        
        print("\t[Headers]:\n\t\t", rpHeadervalues)
        print("\t[Body]:", data)
        
        print("\n[Response Json]:  \(String(describing: data?.prettyPrintedJSONString ?? ""))")
        print("====================> RESPONSE END <====================\n")
    }
    
    
}
