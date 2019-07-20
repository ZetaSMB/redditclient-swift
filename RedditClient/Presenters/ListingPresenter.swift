//
//  ListingPresenter.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation

protocol ListingPresenterDelegateActions {
    var onMustReload: (([LinkState]) ->())? { get set }
    var onMustShowError: ((Error) ->())? { get set }
    var listingData: [LinkState] { get }
}

protocol ListingPresenterInputActions {
    func fetchData();
    func loadMore();
    func markAsRead(linkItem: LinkState);
    func removeFromList(linkItem: LinkState);
}

class TopListPresenter : ListingPresenterDelegateActions & ListingPresenterInputActions {
    
    var onMustReload: (([LinkState]) -> ())? = nil
    
    var onMustShowError: ((Error) -> ())? = nil
    
    private(set) var listingData: [LinkState] = []
    
    fileprivate var after: String?
    fileprivate var before: String?
    fileprivate var pageSize: Int? = 25
    
    private var redditAPIService: RDTAPIService!
    
    public init(_ redditAPIService: RDTAPIService ) {
         self.redditAPIService = redditAPIService
    }
    
    func fetchData() {
        fetchDataWithAction(.insertAtBegining)
    }
    
    func loadMore() {
       fetchDataWithAction(.append)
    }
    
    func markAsRead(linkItem: LinkState) {
        if let idx = listingData.firstIndex(where: { $0 == linkItem }) {
            listingData[idx].read = true
        }
    }
    
    func removeFromList(linkItem: LinkState) {
        if let idx = listingData.firstIndex(where: { $0 == linkItem }) {
            listingData.remove(at: idx)
        }
    }
    
    fileprivate enum DataAction {
        case insertAtBegining
        case append
    }
    
    private func fetchDataWithAction(_ action: DataAction) {
        redditAPIService
            .fetchListing(by: RDTAPIListingType.top,
                          count: pageSize,
                          before: self.before,
                          after: self.after,
                          successHandler: { [unowned self] (ListingRspDTO) in
                            let newData = ListingRspDTO.data.children.map {LinkState(link: $0.data, read: false)}
                            switch action {
                                case .insertAtBegining: do {
                                    self.listingData.insert(contentsOf: newData, at: 0)
                                }
                                case .append: do {
                                    self.listingData.append(contentsOf: newData)
                                }
                            }
                            self.after = ListingRspDTO.data.after
                            self.before = ListingRspDTO.data.before
                            guard let completionHandler = self.onMustReload else { return }
                            completionHandler(self.listingData)
                },
                          errorHandler: { (error) in
                            guard let completionHandler = self.onMustShowError else { return }
                            completionHandler(error)
            })
    }
    
}

