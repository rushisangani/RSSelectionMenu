//
//  RSSelectionMenuDataSource.swift
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

/// RSSelectionMenuDataSource
open class RSSelectionMenuDataSource<T>: NSObject, UITableViewDataSource {

    // MARK: - Properties
    
    /// cell type of tableview - default is "basic = UITableViewCellStyle.default"
    fileprivate var cellType: CellType = .basic
    
    /// cell identifier for tableview - default is "basic"
    fileprivate var cellIdentifier: String = CellType.basic.rawValue
    
    /// data source for tableview
    fileprivate var dataSource: DataSource<T> = []
    
    /// filtered data source for tableView
    fileprivate var filteredDataSource: FilteredDataSource<T> = []
    
    /// cell configuration - (cell, dataObject, indexPath)
    fileprivate var cellConfiguration: UITableViewCellConfiguration<T>?
    
    // MARK: - Initialize
    
    init(dataSource: DataSource<T>, forCellType type: CellType, configuration: @escaping UITableViewCellConfiguration<T>) {
        
        self.dataSource = dataSource
        self.filteredDataSource = self.dataSource
        self.cellType = type
        self.cellConfiguration = configuration
    }
    
    convenience init(dataSource: DataSource<T>, configuration: @escaping UITableViewCellConfiguration<T>) {
        self.init(dataSource: dataSource, forCellType: CellType.basic, configuration: configuration)
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create new reusable cell
        let cellStyle = self.tableViewCellStyle()
        var cell: UITableViewCell?
        
        if cellType == .custom {
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        }
        else {
            cell = UITableViewCell(style: cellStyle, reuseIdentifier: self.cellIdentifier)
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
    
    /// set cell type and identifier
    func setCellType(type: CellType, withReuseIdentifier: String) {
        self.cellType = type
        self.cellIdentifier = withReuseIdentifier
    }
    
    /// returns the object present in dataSourceArray at specified indexPath
    func objectAt(indexPath: IndexPath) -> T {
        return self.filteredDataSource[indexPath.row]
    }
    
    /// to update data source for tableview
    func update(dataSource: DataSource<T>, inTableView tableView: RSSelectionTableView<T>) {
        
        if dataSource.count == 0 { filteredDataSource = self.dataSource }
        else { filteredDataSource = dataSource }
        
        tableView.reloadData()
    }
}

// MARK: - Private
extension RSSelectionMenuDataSource {
    
    /// returns UITableViewCellStyle based on defined cellType
    fileprivate func tableViewCellStyle() -> UITableViewCellStyle {
        
        switch self.cellType {
        case .basic:
            return UITableViewCellStyle.default
        case .rightDetail:
            return UITableViewCellStyle.value1
        case .subTitle:
            return UITableViewCellStyle.subtitle
        default:
            return UITableViewCellStyle.default
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
}
