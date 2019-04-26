//
//  APIRequests.swift
//  CurrencyChanger
//
//  Created by Bartosz Nowacki on 12/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct APICurrenciesRequest: Codable, APIEndpoint {
    
    func endpoint() -> String {
        return "latest"
    }
    
    func params() -> [URLQueryItem]? {
        return nil
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: Currencies) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _: Error) -> Void)) {
        
        APIRequest.get(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}
