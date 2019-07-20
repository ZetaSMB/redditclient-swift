//
//  ListingPresenter.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation

protocol ListingPresenter {
    func fetchData(onSuccess: (([LinkState]) ->())?, onError:((Error) ->())?);
    func loadMore(onSuccess: (([LinkState]) ->())?, onError:((Error) ->())?);
    var listingData: [LinkState] { get }
    var isFetchingData: Bool { get }
    func markAsRead(linkItem: LinkState);
    func removeFromList(linkItem: LinkState) -> Int;
}

class TopListPresenter : ListingPresenter {
    
    private(set) var listingData: [LinkState] = []
    private(set) var isFetchingData: Bool = false
    
    fileprivate var after: String?
    fileprivate var before: String?
    fileprivate var pageSize: Int? = 5
    
    private var redditAPIService: RDTAPIService!
    
    public init(_ redditAPIService: RDTAPIService ) {
         self.redditAPIService = redditAPIService
    }
    
    func fetchData(onSuccess: (([LinkState]) -> ())?, onError: ((Error) -> ())?) {
        isFetchingData = true;
        redditAPIService
            .fetchListing(by: RDTAPIListingType.top,
                          count: pageSize,
                          before: nil,
                          after: nil,
                          successHandler: { [unowned self] (ListingRspDTO) in
                            self.isFetchingData = false;
                            self.listingData = ListingRspDTO.data.children.map {LinkState(link: $0.data, read: false)}
                            self.after = ListingRspDTO.data.after
                            self.before = ListingRspDTO.data.before
                            guard let onSuccess = onSuccess else { return }
                            onSuccess(self.listingData)
                        },
                          errorHandler: { (error) in
                            self.isFetchingData = false;
                            guard let onError = onError else { return }
                            onError(error)
            })
    }
    
    func loadMore(onSuccess: (([LinkState]) -> ())?, onError: ((Error) -> ())?) {
        isFetchingData = true;
        redditAPIService
            .fetchListing(by: RDTAPIListingType.top,
                          count: pageSize,
                          before: nil,
                          after: self.after,
                          successHandler: { [unowned self] (ListingRspDTO) in
                            self.isFetchingData = false;
                            let newData = ListingRspDTO.data.children.map {LinkState(link: $0.data, read: false)}
                            self.after = ListingRspDTO.data.after
                            self.listingData.append(contentsOf: newData)
                            guard let onSuccess = onSuccess else { return }
                            onSuccess(newData)
                         },
                          errorHandler: { (error) in
                            self.isFetchingData = false;
                            guard let onError = onError else { return }
                            onError(error)
            })
    }
    
    func markAsRead(linkItem: LinkState) {
        if let idx = listingData.firstIndex(where: { $0 == linkItem }) {
            listingData[idx].read = true
        }
    }
    
    func removeFromList(linkItem: LinkState) -> Int {
        if let idx = listingData.firstIndex(where: { $0 == linkItem }) {
            listingData.remove(at: idx)
            return idx
        }
        return -1
    }
    
    func removeAll() {
        listingData = []
    }
}

