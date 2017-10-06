//
//  RSSelectionMenuSearchDelegate.swift
//  RSSelectionMenu
//
//  Created by Rushi on 30/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

/// FilteredDataSource
typealias FilteredDataSource = [AnyObject]

/// UISearchBarResult
typealias UISearchBarResult = ((_ searchText: String) -> (FilteredDataSource))

/// RSSelectionMenuSearchDelegate
class RSSelectionMenuSearchDelegate: NSObject {

    // MARK: - Properties
    public let searchController = UISearchController(searchResultsController: nil)
    
    /// to execute on search event
    public var didSearch: ((String) -> ())?
    
    // MARK: - Initialize
    init(controller: UIViewController, tableView: UITableView, placeHolder: String? = defaultPlaceHolder, tintColor: UIColor? = defaultSearchBarTintColor) {
        super.init()
        
        controller.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = tintColor
        searchController.searchBar.placeholder = placeHolder
        searchController.hidesNavigationBarDuringPresentation = false
        
        // add as tableHeaderView
        tableView.tableHeaderView = searchController.searchBar
    }
}

// MARK:- UISearchResultsUpdating
extension RSSelectionMenuSearchDelegate : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let search = didSearch {
            search(searchController.searchBar.text ?? "")
        }
    }
}
