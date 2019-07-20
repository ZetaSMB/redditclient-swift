//
//  ReeditAPIRepository.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation

class ReeditAPIRepository: RDTAPIService {
    
    public static let shared = ReeditAPIRepository()
    
    private enum APIParamKey {
        static let after  = "after"
        static let before = "before"
        static let limit  = "limit"
    }

    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }()
    
    fileprivate func fetchCodableEntity<T: Codable>(from request: URLRequest,
                                                    successHandler: @escaping (T) -> Void,
                                                    errorHandler: @escaping (Error) -> Void) {

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard  error == nil else {
                DispatchQueue.main.async {
                    errorHandler(RDTAPIError.requestError(error!))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorHandler(RDTAPIError.noData)
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    errorHandler(RDTAPIError.invalidResponse)
                }
                return
            }
            
            do {
                let rsp = try self.jsonDecoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    successHandler(rsp)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    errorHandler(RDTAPIError.serializationError)
                }
            }
            
        }.resume()
    }
    
    public func fetchListing(by listingType: RDTAPIListingType,
                             count pageSize: Int? = 25,
                             before beforeLinkId: String?,
                             after afterLinkId: String?,
                             successHandler: @escaping (_ response: ListingRspDTO) -> Void,
                             errorHandler: @escaping(_ error: Error) -> Void) {
        
        var parameters : [String:String] = [:]
        if let beforeLinkId = beforeLinkId {
            parameters[APIParamKey.before] = beforeLinkId
        }
        if let afterLinkId = afterLinkId {
            parameters[APIParamKey.after] = afterLinkId
        }
        if let pageSize = pageSize {
            parameters[APIParamKey.limit] = "\(pageSize)"
        }
        
        let urlRequest = ReeditAPIRequest.listing(listingType).asURLRequest(withParams: parameters)
        
        self.fetchCodableEntity(from: urlRequest, successHandler: successHandler, errorHandler: errorHandler)
    }
}
