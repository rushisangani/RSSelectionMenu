//
//  RSSelectionMenuDataSource.swift
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

/// RSSelectionMenuDataSource
open class RSSelectionMenuDataSource<T: Equatable>: NSObject, UITableViewDataSource {

    // MARK: - Properties
    
    /// tableView
    weak var selectionTableView: RSSelectionTableView<T>?
    
    /// data source for tableview
    var dataSource: DataSource<T> = []
    
    /// cell type of tableview
    var cellType: CellType {
        return selectionTableView?.cellType ?? .basic
    }
    
    /// cell identifier for tableview - default is "basic"
    var cellIdentifier: String {
        
        switch cellType {
        case .customNib(_, let identifier):
            return identifier
        case .customClass(_, let cellIdentifier):
            return cellIdentifier
        default:
            return cellType.value()
        }
    }
    
    /// filtered data source for tableView
    fileprivate var filteredDataSource: FilteredDataSource<T> = []
    
    /// cell configuration - (cell, item, indexPath)
    fileprivate var cellConfiguration: UITableViewCellConfiguration<T>?
    
    /// data source count
    var count: Int {
        return filteredDataSource.count
    }
    
    // MARK: - Initialize
    
    init(dataSource: DataSource<T>, forCellType type: CellType, cellConfiguration: @escaping UITableViewCellConfiguration<T>) {
        
        self.dataSource = dataSource
        self.filteredDataSource = self.dataSource
        self.cellConfiguration = cellConfiguration
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.filteredDataSource.count
        return self.isFirstRowAdded() ? count+1 : count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // check if first row added
        if indexPath.row == 0 && isFirstRowAdded() {
            return setupFirstRow()
        }
        
        // get reusable cell
        let cell = self.getReusableCell(forTableView: tableView, indexPath: indexPath)
        
        guard let configuration = cellConfiguration else {
            return cell
        }
        
        let item = self.objectAt(indexPath: indexPath)
        configuration(cell, item, indexPath)
        
        // selection
        let delegate = tableView.delegate as! RSSelectionMenuDelegate<T>
        let selected = delegate.showSelected(item: item, inTableView: tableView as! RSSelectionTableView<T>)
        self.updateStatus(selected, forCell: cell, atIndexPath: indexPath)
        
        return cell
    }
}

// MARK: - Public
extension RSSelectionMenuDataSource {
    
    /// returns the object present in dataSourceArray at specified indexPath
    func objectAt(indexPath: IndexPath) -> T {
        let index = !isFirstRowAdded() ? indexPath.row : indexPath.row-1
        return self.filteredDataSource[index]
    }
    
    /// to update data source for tableview
    func update(dataSource: DataSource<T>, inTableView tableView: RSSelectionTableView<T>) {
        filteredDataSource = dataSource
        tableView.reload()
    }
    
    /// checks if first row is added
    func isFirstRowAdded() -> Bool {
        return (selectionTableView?.firstRowSelection != nil && filteredDataSource.count == dataSource.count)
    }
}

// MARK: - Private
extension RSSelectionMenuDataSource {
    
    /// returns UITableViewCellStyle based on defined cellType
    fileprivate func tableViewCellStyle() -> UITableViewCell.CellStyle {
        
        switch self.cellType {
        case .basic:
            return UITableViewCell.CellStyle.default
        case .rightDetail:
            return UITableViewCell.CellStyle.value1
        case .subTitle:
            return UITableViewCell.CellStyle.subtitle
        default:
            return UITableViewCell.CellStyle.default
        }
    }
    
    /// update cell status
    fileprivate func updateStatus(_ status: Bool, forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        
        guard selectionTableView?.cellSelectionStyle == .checkbox else {
            cell.accessoryType = status ? .checkmark : .none
            return
        }
            
        switch cellType {
        case .customNib, .customClass:
            break
        default:
            cell.setSelected(status, animated: true)
            return
        }
        
        if isFirstRowAdded(), indexPath.row == 0 {
            cell.setSelected(status, animated: true)
            return
        }
        
        if status {
            selectionTableView?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }else {
            selectionTableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
    /// setup first row
    fileprivate func setupFirstRow() -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellType.basic.value())
        cell.selectionStyle = .none
        cell.textLabel?.text = selectionTableView?.firstRowSelection?.rowType.value
        
        if #available(iOS 13.0, *) {
            cell.textLabel?.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
            cell.textLabel?.textColor = UIColor.darkText
        }
        
        // update status
        let selected = selectionTableView?.firstRowSelection?.selected ?? false
        self.updateStatus(selected, forCell: cell, atIndexPath: IndexPath(row: 0, section: 0))
        
        return cell
    }
    
    /// get tableview cell for cell type
    fileprivate func getReusableCell(forTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {

        // create reusable cell
        switch cellType {
        case .customNib(_, _), .customClass(_,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            return cell
        default:
            let cell = UITableViewCell(style: self.tableViewCellStyle(), reuseIdentifier: cellIdentifier)
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        }
    }
}
