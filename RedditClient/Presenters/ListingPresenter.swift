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
    fileprivate var pageSize: Int? = 50
    
    fileprivate var alreadyReadLinksIds: Set<String> = { Set<String>() }()
    
    private var redditAPIService: RDTAPIService!
    
    public init(_ redditAPIService: RDTAPIService ) {
        self.redditAPIService = redditAPIService
    }
    
    public func fetchData(onSuccess: (([LinkState]) -> ())?, onError: ((Error) -> ())?) {
        isFetchingData = true;
        redditAPIService
            .fetchListing(by: RDTAPIListingType.top,
                          count: pageSize,
                          before: nil,
                          after: nil,
                          successHandler: { [unowned self] (ListingRspDTO) in
                            self.isFetchingData = false;
                            self.listingData = ListingRspDTO.data.children.map {
                                LinkState(link: $0.data, read:( $0.data.id != nil ? self.alreadyReadLinksIds.contains($0.data.id!) : false))
                            }
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
    
    public func loadMore(onSuccess: (([LinkState]) -> ())?, onError: ((Error) -> ())?) {
        isFetchingData = true;
        redditAPIService
            .fetchListing(by: RDTAPIListingType.top,
                          count: pageSize,
                          before: nil,
                          after: self.after,
                          successHandler: { [unowned self] (ListingRspDTO) in
                            self.isFetchingData = false;
                            let newData =  ListingRspDTO.data.children.map {
                                LinkState(link: $0.data, read:( $0.data.id != nil ? self.alreadyReadLinksIds.contains($0.data.id!) : false))
                            }
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
    
    public func markAsRead(linkItem: LinkState) {
        if let idx = listingData.firstIndex(where: { $0.link.id == linkItem.link.id }) {
            listingData[idx].read = true
            alreadyReadLinksIds.insert(listingData[idx].link.id!)
        }
    }
    
    public func removeFromList(linkItem: LinkState) -> Int {
        if let idx = listingData.firstIndex(where: { $0.link.id == linkItem.link.id }) {
            listingData.remove(at: idx)
            return idx
        }
        return -1
    }

}

