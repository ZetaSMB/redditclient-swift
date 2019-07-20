//
//  ReeditAPIProtocol.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation

protocol RDTAPIService {
    
    func fetchListing(by listingType: RDTAPIListingType,
                      count pageSize: Int?,
                      before beforeLinkId: String?,
                      after afterLinkId: String?,
                      successHandler: @escaping (_ response: ListingRspDTO) -> Void,
                      errorHandler: @escaping(_ error: Error) -> Void)
}

public enum RDTAPIListingType : String, CustomStringConvertible {
    case top

    public var description: String {
        switch self {
            case .top: return "top"
        }
    }
}

public enum RDTAPIError: Error {
    case requestError(Error)
    case invalidResponse
    case serializationError
    case noData
}
