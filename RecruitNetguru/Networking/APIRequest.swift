//
//  APIRequest.swift
//  RecruitNetguru
//
//  Created by Bartosz Nowacki on 12/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

protocol APIEndpoint {
    func endpoint() -> String
    func params() -> [URLQueryItem]?
}

class APIRequest {
    struct ErrorResponse: Codable {
        let success: String
        let error: ErrorData
    }
    
    struct ErrorData: Codable {
        let code: Int
        let type: String
        let info: String
    }
    
    
    enum APIError: Error {
        case invalidEndpoint
        case errorResponseDetected
        case noData
    }
}

extension APIRequest {
    
    public static func processResponse<T: Codable, E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: ((_: T) -> Void),
        onError: ((_: E?, _: Error) -> Void)) {
        if let data = dataOrNil {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                onSuccess(decodedResponse)
            } catch {
                let originalError = error
                
                do {
                    let errorResponse = try JSONDecoder().decode(E.self, from: data)
                    onError(errorResponse, APIError.errorResponseDetected)
                } catch {
                    onError(nil, originalError)
                }
            }
        } else {
            onError(nil, errorOrNil ?? APIError.noData)
        }
    }
    
    public static func urlRequest(from request: APIEndpoint) -> URLRequest? {
        let endpoint = request.endpoint()
        guard let baseUrl = Bundle.main.infoDictionary?["API URL"] as? String else { return nil }
        guard let apiKey = Bundle.main.infoDictionary?["API KEY"] as? String else { return nil }
        let urlComponents = NSURLComponents(string: "\(baseUrl)\(endpoint)")!
        var items = [URLQueryItem]()
        if let params = request.params() {
            items = params
        }
        items.append(URLQueryItem(name: "access_key", value: apiKey))
        urlComponents.queryItems = items
        var endpointRequest = URLRequest(url: urlComponents.url!)
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return endpointRequest
    }
    
    public static func get<R: Codable & APIEndpoint, T: Codable, E: Codable>(
        request: R,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void)) {
        
        guard var endpointRequest = self.urlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        endpointRequest.httpMethod = "GET"
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
        }).resume()
    }
}
