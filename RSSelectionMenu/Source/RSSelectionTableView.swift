//
//  RSSelectionTableView.swift
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

/// RSSelectionTableView
open class RSSelectionTableView: UITableView {

    // MARK: - Properties
    
    /// parent view
    fileprivate weak var selectionMenu: RSSelectionMenu?
    
    /// datasource for tableView
    var selectionDataSource: RSSelectionMenuDataSource?
    
    /// delegate for tableView
    var selectionDelegate: RSSelectionMenuDelegate?
    
    /// delegate for search controller
    var searchControllerDelegate: RSSelectionMenuSearchDelegate?
    
    /// delegate for search bar search result
    var searchBarResultDelegate: UISearchBarResult?
    
    /// selection type - default is single selection
    var selectionType: SelectionType = .single
    
    // MARK: - Life Cycle
    
    convenience public init(selectionType: SelectionType, dataSource: RSSelectionMenuDataSource, delegate: RSSelectionMenuDelegate, from: RSSelectionMenu) {
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
    func setOnDidSelect(delegate: @escaping UITableViewCellSelection) {
        self.selectionDelegate?.selectionDelegate = delegate
    }
    
    // add search bar
    func addSearchBar(withCompletion: @escaping UISearchBarResult) {
        self.searchBarResultDelegate = withCompletion
        self.searchControllerDelegate = RSSelectionMenuSearchDelegate(controller: selectionMenu!, tableView: self)
        
        // update result on search event
        self.searchControllerDelegate?.didSearch = { [weak self] (searchText) in
            
            let filteredDataSource = !searchText.isEmpty ? self?.searchBarResultDelegate!(searchText) : []
            self?.selectionDataSource?.update(dataSource: filteredDataSource!, inTableView: self!)
        }
    }
    
    // object at indexpath
    func objectAt(indexPath: IndexPath) -> AnyObject {
        return self.selectionDataSource!.objectAt(indexPath: indexPath)
    }
    
    /// dismiss
    func dismissControllerIfRequired() {
        if (selectionMenu?.shouldDismissOnSelect)! {
            selectionMenu?.dismiss()
        }
    }
}
