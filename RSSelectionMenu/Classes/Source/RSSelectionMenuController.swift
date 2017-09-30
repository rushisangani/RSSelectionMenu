//
//  RSSelectionMenuController.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

/// RSSelectionMenuController
class RSSelectionMenu: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    open static let `default`: RSSelectionMenu = {
        return UIStoryboard.instantiateRSSelectionMenu()
    }()
    
    /// datasource for tableView
    fileprivate var dataSource: RSSelectionMenuDataSource?
    
    /// delegate for tableView
    fileprivate var delegate: RSSelectionMenuDelegate?
    
    /// delegate for search controller
    fileprivate var searchControllerDelegate: RSSelectionMenuSearchDelegate?
    
    /// delegate for search bar search result
    fileprivate var searchBarResultDelegate: UISearchBarResult?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    fileprivate func setup() {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        addSearchController()
    }
}

// MARK:- Public
extension RSSelectionMenu {
    
    /// Initialize
    func initWith(dataSource: DataSource, cellType: CellType? = .basic, configuration: @escaping UITableViewCellConfiguration) -> RSSelectionMenu {
        self.dataSource = RSSelectionMenuDataSource(dataSource: dataSource, forCellType: cellType!, configuration: configuration)
        return self
    }
    
    /// Selection event
    func didSelectRow(_ delegate: @escaping UITableViewCellSelection)  {
        self.delegate = RSSelectionMenuDelegate(delegate: delegate)
    }
    
    /// Searchbar
    func addSearchBar(withCompletion: @escaping UISearchBarResult) {
        self.searchBarResultDelegate = withCompletion
    }
    
    /// Show
    func show(from: UIViewController) {
        from.present(self, animated: true, completion: nil)
    }
    
    func show(as: PresentationStyle, from: UIViewController) {
    }
}

//MARK:- Private
extension RSSelectionMenu {

    /// checks if searchbar needs to add
    fileprivate func addSearchBar() -> Bool {
        return (self.searchBarResultDelegate != nil)
    }
    
    /// adds search controller if search is enabled
    fileprivate func addSearchController() {
        guard addSearchBar() else { return }
        
        self.searchControllerDelegate = RSSelectionMenuSearchDelegate(controller: self, tableView: tableView)
        
        // search event
        self.searchControllerDelegate?.didSearch = { [weak self] (searchText) in
            self?.onDidStartSearch(text: searchText)
        }
    }
    
    /// called on searchcontroller search event
    fileprivate func onDidStartSearch(text: String) {
        
        let filteredDataSource = !text.isEmpty ? self.searchBarResultDelegate!(text) : []
        self.dataSource?.update(dataSource: filteredDataSource, inTableView: tableView)
    }
}
