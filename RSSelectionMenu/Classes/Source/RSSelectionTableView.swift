//
//  RSSelectionTableView.swift
//  RSSelectionMenu
//
//  Created by Rushi on 05/10/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

/// RSSelectionTableView
class RSSelectionTableView: UITableView {

    // MARK: - Properties
    
    /// parent view
    fileprivate weak var selectionMenu: RSSelectionMenu?
    
    /// datasource for tableView
    public var selectionDataSource: RSSelectionMenuDataSource?
    
    /// delegate for tableView
    public var selectionDelegate: RSSelectionMenuDelegate?
    
    /// delegate for search controller
    public var searchControllerDelegate: RSSelectionMenuSearchDelegate?
    
    /// delegate for search bar search result
    public var searchBarResultDelegate: UISearchBarResult?
    
    /// selection type - default is single selection
    public var selectionType: SelectionType = .single
    
    // MARK: - Life Cycle
    
    convenience init(selectionType: SelectionType, dataSource: RSSelectionMenuDataSource, delegate: RSSelectionMenuDelegate, from: RSSelectionMenu) {
        self.init()
        
        self.selectionDataSource = dataSource
        self.selectionDelegate = delegate
        self.selectionType = selectionType
        self.selectionMenu = from
        
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        
        dataSource = self.selectionDataSource
        delegate = self.selectionDelegate
        tableFooterView = UIView()
        
        // register cells
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.basic.rawValue)
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.rightDetail.rawValue)
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.subTitle.rawValue)
    }
}

//MARK: - Public
extension RSSelectionTableView {
    
    // selection delegate event
    public func setOnDidSelect(delegate: @escaping UITableViewCellSelection) {
        self.selectionDelegate?.selectionDelegate = delegate
    }
    
    // add search bar
    public func addSearchBar(withCompletion: @escaping UISearchBarResult) {
        self.searchBarResultDelegate = withCompletion
        self.searchControllerDelegate = RSSelectionMenuSearchDelegate(controller: selectionMenu!, tableView: self)
        
        // update result on search event
        self.searchControllerDelegate?.didSearch = { [weak self] (searchText) in
            
            let filteredDataSource = !searchText.isEmpty ? self?.searchBarResultDelegate!(searchText) : []
            self?.selectionDataSource?.update(dataSource: filteredDataSource!, inTableView: self!)
        }
    }
    
    // object at indexpath
    public func objectAt(indexPath: IndexPath) -> AnyObject {
        return self.selectionDataSource!.objectAt(indexPath: indexPath)
    }
    
    /// dismiss
    public func dismissControllerIfRequired() {
        if (selectionMenu?.shouldDismissOnSelect)! {
            selectionMenu?.dismiss()
        }
    }
}
