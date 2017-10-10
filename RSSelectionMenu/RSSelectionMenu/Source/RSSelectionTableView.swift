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
open class RSSelectionTableView<T>: UITableView {

    // MARK: - Properties
    
    /// parent view
    weak var selectionMenu: RSSelectionMenu<T>?
    
    /// datasource for tableView
    var selectionDataSource: RSSelectionMenuDataSource<T>?
    
    /// delegate for tableView
    var selectionDelegate: RSSelectionMenuDelegate<T>?
    
    /// delegate for search controller
    var searchControllerDelegate: RSSelectionMenuSearchDelegate?
    
    /// delegate for search bar search result
    var searchBarResultDelegate: UISearchBarResult<T>?
    
    /// selection type - default is single selection
    var selectionType: SelectionType = .single
    
    /// first row selection
    var firstRowSelection: RSFirstRowSelection?
    
    // MARK: - Life Cycle
    
    convenience public init(selectionType: SelectionType, dataSource: RSSelectionMenuDataSource<T>, delegate: RSSelectionMenuDelegate<T>, from: RSSelectionMenu<T>) {
        self.init()
        
        self.selectionDataSource = dataSource
        self.selectionDelegate = delegate
        self.selectionType = selectionType
        self.selectionMenu = from
        
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        
        self.selectionDataSource?.selectionTableView = self
        dataSource = self.selectionDataSource
        delegate = self.selectionDelegate
        tableFooterView = UIView()
        estimatedRowHeight = 50
        rowHeight = UITableViewAutomaticDimension
        
        // register cells
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.basic.rawValue)
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.rightDetail.rawValue)
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.subTitle.rawValue)
    }
}

//MARK: - Public
extension RSSelectionTableView {
    
    // selection delegate event
    func setOnDidSelect(delegate: @escaping UITableViewCellSelection<T>) {
        self.selectionDelegate?.selectionDelegate = delegate
    }
    
    // add search bar
    func addSearchBar(placeHolder: String, tintColor: UIColor, completion: @escaping UISearchBarResult<T>) {
        
        self.searchBarResultDelegate = completion
        self.searchControllerDelegate = RSSelectionMenuSearchDelegate(tableView: self, placeHolder: placeHolder, tintColor: tintColor)
        
        // update result on search event
        self.searchControllerDelegate?.didSearch = { [weak self] (searchText) in
            
            let filteredDataSource = !searchText.isEmpty ? self?.searchBarResultDelegate!(searchText) : []
            self?.selectionDataSource?.update(dataSource: filteredDataSource!, inTableView: self!)
        }
    }
    
    /// first row type and selection
    public func showFirstRowAs(type: FirstRowType, selected: Bool, completion: @escaping FirstRowSelection) {
        
        self.firstRowSelection = RSFirstRowSelection(selected: selected, rowType: type, delegate: completion)
        if selected { self.selectionDelegate?.removeAllSelected() }
        
    }
    
    // object at indexpath
    func objectAt(indexPath: IndexPath) -> T {
        return self.selectionDataSource!.objectAt(indexPath: indexPath)
    }
    
    /// dismiss
    func dismissControllerIfRequired() {
        if selectionType == .single {
            selectionMenu?.dismiss()
        }
    }
}
