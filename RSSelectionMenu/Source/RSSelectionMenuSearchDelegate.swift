//
//  RSSelectionMenuSearchDelegate.swift
//
//  Copyright (c) 2017 Rushi Sangani
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

/// RSSelectionMenuSearchDelegate
open class RSSelectionMenuSearchDelegate: NSObject {

    // MARK: - Properties
    public let searchController = UISearchController(searchResultsController: nil)
    
    /// to execute on search event
    public var didSearch: ((String) -> ())?
    
    // MARK: - Initialize
    init(controller: UIViewController, tableView: UITableView, placeHolder: String, tintColor: UIColor) {
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
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let search = didSearch {
            search(searchController.searchBar.text ?? "")
        }
    }
}
