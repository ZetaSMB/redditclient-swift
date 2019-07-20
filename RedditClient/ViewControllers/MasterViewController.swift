//
//  MasterViewController.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    private var listingPresenter : ListingPresenter
    
    required init?(coder aDecoder: NSCoder) {
        listingPresenter = TopListPresenter(ReeditAPIRepository.shared)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.refresh(self)
    }
    
    func configureTableView() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc private func refresh(_ sender: Any) {
        listingPresenter.fetchData(onSuccess: { [unowned self] _ in
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            },
                                     onError:{ [unowned self] (error) in
                                        self.refreshControl?.endRefreshing()
                                        self.showFetchError(error)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    private func showFetchError(_ error : Error) {
        //TODO:
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = listingPresenter.listingData[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingPresenter.listingData.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == listingPresenter.listingData.count {
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
            cell.configure(with: listingPresenter.listingData[indexPath.row]) {
                //complete
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= listingPresenter.listingData.count,
            !listingPresenter.isFetchingData {
            listingPresenter.loadMore(onSuccess:
                { [unowned self] (newData) in
                    let startIndex = self.listingPresenter.listingData.count - newData.count
                    let endIndex = startIndex + newData.count
                    let indexesToAdd = Array(startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                    self.tableView.performBatchUpdates({
                        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
                        self.tableView.insertRows(at:indexesToAdd, with: UITableView.RowAnimation.fade)
                    }, completion: nil)
                    
                },
                                      onError:
                { [unowned self] (error) in
                    self.showFetchError(error)
            })
        }
    }
}
