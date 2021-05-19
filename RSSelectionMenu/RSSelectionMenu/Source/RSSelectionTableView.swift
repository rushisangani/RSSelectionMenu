//
//  RSSelectionTableView.swift
//  RSSelectionMenu
//
//  Copyright (c) 2019 Rushi Sangani
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
open class RSSelectionTableView<T: Equatable>: UITableView {

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
    
    /// selection style - default is single selection
    var selectionStyle: SelectionStyle = .single
    
    /// cell type of tableview - default is "basic = UITableViewCellStyle.default"
    var cellType: CellType = .basic
    
    /// cell selection style - default is 'tickmark'
    var cellSelectionStyle: CellSelectionStyle = .tickmark
    
    /// first row selection
    var firstRowSelection: RSFirstRowSelection?
    
    /// empty data view
    lazy var emptyDataView: UILabel = {
        let label = UILabel()
        label.center = self.center
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Life Cycle
    
    convenience public init(
        selectionStyle: SelectionStyle,
        tableViewStyle: UITableView.Style,
        cellType: CellType,
        dataSource: RSSelectionMenuDataSource<T>,
        delegate: RSSelectionMenuDelegate<T>,
        from: RSSelectionMenu<T>) {
        
        if #available(iOS 13.0, *) {
            self.init(frame: .zero, style: tableViewStyle)
        } else {
            self.init()
        }
        
        self.selectionDataSource = dataSource
        self.selectionDelegate = delegate
        self.selectionStyle = selectionStyle
        self.selectionMenu = from
        self.cellType = cellType
        
        setup()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let _ = self.backgroundView {
            self.emptyDataView.center = self.center
        }
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
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.basic.value())
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.rightDetail.value())
        register(UITableViewCell.self, forCellReuseIdentifier: CellType.subTitle.value())
        
        // register nib for custom cell
        if case let CellType.customNib(name, cellIdentifier) = cellType {
            register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        if case let CellType.customClass(className, cellIdentifier) = cellType {
            register(className, forCellReuseIdentifier: cellIdentifier)
        }
    }
}

// MARK: - Private
extension RSSelectionTableView {
    
    /// Set selected items and selection event
    func setSelectedItems(items: DataSource<T>, maxSelected: UInt?, onDidSelectRow delegate: @escaping UITableViewCellSelection<T>) {
        self.selectionDelegate?.selectionDelegate = delegate
        self.selectionDelegate?.selectedItems = items
        self.selectionDelegate?.maxSelectedLimit = maxSelected
    }
    
    /// Set cell selection style
    func setCellSelectionStyle(_ style: CellSelectionStyle) {
        self.cellSelectionStyle = style
        if style == .checkbox {
            isEditing = true
            allowsMultipleSelectionDuringEditing = true
        }
    }
    
    /// Add first row
    func addFirstRowAs(rowType: FirstRowType, showSelected: Bool, onDidSelectFirstRow completion: @escaping FirstRowSelection) {
        
        self.firstRowSelection = RSFirstRowSelection(rowType: rowType, selected: showSelected, delegate: completion)
        if showSelected {
            self.selectionDelegate?.removeAllSelectedItems()
        }
    }
    
    // Add search bar
    func addSearchBar(placeHolder: String, barTintColor: UIColor, completion: @escaping UISearchBarResult<T>) {
        
        self.searchBarResultDelegate = completion
        self.searchControllerDelegate = RSSelectionMenuSearchDelegate(placeHolder: placeHolder, barTintColor: barTintColor)
        
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
    
    // empty data view
    func showEmptyDataLabel(text: String, attributes: [NSAttributedString.Key: Any]?) {
        let label = self.emptyDataView
        if let textAttributes = attributes {
            label.attributedText = NSAttributedString(string: text, attributes: textAttributes)
        }else {
            label.text = text
        }
        self.backgroundView = label
    }
    
    // reloadData
    func reload() {
        self.reloadData()
        self.backgroundView?.isHidden = ((self.selectionDataSource?.count ?? 0) > 0)
    }
    
    // object at indexpath
    func objectAt(indexPath: IndexPath) -> T {
        return self.selectionDataSource!.objectAt(indexPath: indexPath)
    }
    
    /// dismiss
    func dismissMenuIfRequired() {
        let dismiss = selectionMenu?.dismissAutomatically ?? false
        if selectionStyle == .single && dismiss {
            selectionMenu?.dismiss()
        }
    }
}
