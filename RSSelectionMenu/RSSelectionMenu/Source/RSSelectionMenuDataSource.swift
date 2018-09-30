//
//  RSSelectionMenuDataSource.swift
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

/// RSSelectionMenuDataSource
open class RSSelectionMenuDataSource<T>: NSObject, UITableViewDataSource {

    // MARK: - Properties
    
    /// tableView
    weak var selectionTableView: RSSelectionTableView<T>?
    
    /// cell type of tableview
    var cellType: CellType {
        return selectionTableView?.cellType ?? .Basic
    }
    
    /// cell identifier for tableview - default is "basic"
    var cellIdentifier: String = CellType.Basic.value()
    
    /// data source for tableview
    var dataSource: DataSource<T> = []
    
    /// filtered data source for tableView
    fileprivate var filteredDataSource: FilteredDataSource<T> = []
    
    /// cell configuration - (cell, dataObject, indexPath)
    fileprivate var cellConfiguration: UITableViewCellConfiguration<T>?
    
    // MARK: - Initialize
    
    init(dataSource: DataSource<T>, forCellType type: CellType, cellConfiguration: @escaping UITableViewCellConfiguration<T>) {
        
        self.dataSource = dataSource
        self.filteredDataSource = self.dataSource
        self.cellConfiguration = cellConfiguration
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = self.filteredDataSource.count
        if isFirstRowAdded() { count += 1 }
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // check if first row added
        if indexPath.row == 0 && isFirstRowAdded() {
            return setupFirstRow()
        }
        
        // create new reusable cell
        let cellStyle = self.tableViewCellStyle()
        var cell: UITableViewCell?
        
        switch cellType {
        case .Custom:
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            break
        default:
            cell = UITableViewCell(style: cellStyle, reuseIdentifier: cellType.value())
            cell?.textLabel?.numberOfLines = 0
            cell?.detailTextLabel?.numberOfLines = 0
            break
        }
        
        // cell configuration
        if let config = cellConfiguration {
            
            let dataObject = self.objectAt(indexPath: indexPath)
            config(cell!, dataObject, indexPath)
            
            // selection
            let delegate = tableView.delegate as! RSSelectionMenuDelegate<T>
            updateStatus(status: delegate.showSelected(object: dataObject, inTableView: tableView as! RSSelectionTableView<T>), for: cell!)
        }
        
        return cell!
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
        tableView.reloadData()
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
        case .Basic:
            return UITableViewCell.CellStyle.default
        case .RightDetail:
            return UITableViewCell.CellStyle.value1
        case .SubTitle:
            return UITableViewCell.CellStyle.subtitle
        default:
            return UITableViewCell.CellStyle.default
        }
    }
    
    /// checks if data source is empty
    fileprivate func isDataSourceEmpty() -> Bool {
        return (self.filteredDataSource.count == 0)
    }
    
    /// update cell status
    fileprivate func updateStatus(status: Bool, for cell: UITableViewCell) {
        cell.showSelected(status)
    }
    
    /// setup first row
    fileprivate func setupFirstRow() -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellType.Basic.value())
        cell.textLabel?.text = selectionTableView?.firstRowSelection?.rowType?.value
        cell.textLabel?.textColor = UIColor.darkGray
        
        // update status
        updateStatus(status: (selectionTableView?.firstRowSelection?.selected)!, for: cell)
        
        return cell
    }
}
