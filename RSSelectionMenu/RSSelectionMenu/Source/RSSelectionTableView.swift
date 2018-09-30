//
//  RSSelectionTableView.swift
//
//  Copyright (c) 2018 Rushi Sangani
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
    var selectionType: SelectionType = .Single
    
    /// cell type of tableview - default is "basic = UITableViewCellStyle.default"
    var cellType: CellType = .Basic
    
    /// first row selection
    var firstRowSelection: RSFirstRowSelection?
    
    // MARK: - Life Cycle
    
    convenience public init(selectionType: SelectionType, cellType: CellType, dataSource: RSSelectionMenuDataSource<T>, delegate: RSSelectionMenuDelegate<T>, from: RSSelectionMenu<T>) {
        self.init()
        
        self.selectionDataSource = dataSource
        self.selectionDelegate = delegate
        self.selectionType = selectionType
        self.selectionMenu = from
        self.cellType = cellType
        
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        
        self.selectionDataSource?.selectionTableView = self
        dataSource = self.selectionDataSource
        delegate = self.selectionDelegate
        tableFooterView = UIView()
        estimatedRowHeight = 50
        rowHeight = UITableView.automaticDimension
        keyboardDismissMode = .interactive
        
        // register cells
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.Basic.value())
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.RightDetail.value())
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.SubTitle.value())
        
        // register nib for custom cell
        if case let CellType.Custom(name, cellIdentifier) = cellType {
            register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: cellIdentifier)
            selectionDataSource?.cellIdentifier = cellIdentifier
        }
    }
}

//MARK: - Public
extension RSSelectionTableView {
    
    /// set selected items and selection event
    public func setSelectedItems(items: DataSource<T>, maxSelected: UInt?, onDidSelectRow delegate: @escaping UITableViewCellSelection<T>) {
        self.selectionDelegate?.selectionDelegate = delegate
        self.selectionDelegate?.selectedObjects = items
        self.selectionDelegate?.maxSelectedLimit = maxSelected
    }
    
    /// Set first row
    public func addFirstRowAs(rowType: FirstRowType, showSelected: Bool, onDidSelectFirstRow completion: @escaping FirstRowSelection) {
        
        self.firstRowSelection = RSFirstRowSelection(selected: showSelected, rowType: rowType, delegate: completion)
        if showSelected { self.selectionDelegate?.removeAllSelected() }
    }
    
    // add search bar
    func addSearchBar(placeHolder: String, tintColor: UIColor, completion: @escaping UISearchBarResult<T>) {
        
        self.searchBarResultDelegate = completion
        self.searchControllerDelegate = RSSelectionMenuSearchDelegate(placeHolder: placeHolder, tintColor: tintColor)
        
        // update result on search event
        self.searchControllerDelegate?.didSearch = { [weak self] (searchText) in
            if searchText.isEmpty {
                self?.selectionDataSource?.update(dataSource: (self?.selectionDataSource?.dataSource)!, inTableView: self!)
            }else {
                let filteredDataSource = self?.searchBarResultDelegate!(searchText) ?? []
                self?.selectionDataSource?.update(dataSource: filteredDataSource, inTableView: self!)
            }
        }
    }
    
    // object at indexpath
    func objectAt(indexPath: IndexPath) -> T {
        return self.selectionDataSource!.objectAt(indexPath: indexPath)
    }
    
    /// dismiss
    func dismissControllerIfRequired() {
        let dismiss = selectionMenu?.dismissAutomatically ?? false
        if selectionType == .Single && dismiss {
            selectionMenu?.dismiss()
        }
    }
}
