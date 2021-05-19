//
//  RSSelectionMenuDelegate.swift
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

/// RSSelectionMenuDelegate
open class RSSelectionMenuDelegate<T: Equatable>: NSObject, UITableViewDelegate {

    // MARK: - Properties

    /// tableview cell selection delegate
    var selectionDelegate: UITableViewCellSelection<T>? = nil
    
    /// selected items
    var selectedItems = DataSource<T>()
    
    /// maximum selection limit
    var maxSelectedLimit: UInt?
    
    
    // MARK: - Initialize
    convenience init(selectedItems: DataSource<T>) {
        self.init()
        self.selectedItems = selectedItems
    }
    
    
    // MARK:- UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.isSearchBarAdded(tableView).1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectionTableView = tableView as! RSSelectionTableView<T>
        
        // first row selected
        if indexPath.row == 0 && isFirstRowAdded(inTableView: selectionTableView) {
            handleActionForFirstRow(tableView: selectionTableView)
            return
        }
        
        // update first row
        updateFirstRowSelection(tableView: selectionTableView)
        
        // selected item
        let item = selectionTableView.objectAt(indexPath: indexPath)
        
        // single selection
        if selectionTableView.selectionStyle == .single {
            self.handleActionForSingleSelection(item: item, index: indexPath.row, tableView: selectionTableView)
        }
        // multiple selection
        else {
            self.handleActionForMultiSelection(item: item, index: indexPath.row, tableView: selectionTableView)
        }
        
        // dismiss if required
        selectionTableView.dismissMenuIfRequired()
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectionTableView = tableView as! RSSelectionTableView<T>
        let item = selectionTableView.objectAt(indexPath: indexPath)
        handleActionForMultiSelection(item: item, index: indexPath.row, tableView: selectionTableView)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = [UITableView.Style.plain, .grouped].contains(tableView.style) ? 1.0 : 24.0
        return self.isSearchBarAdded(tableView).0 ? defaultHeaderHeight : height
    }
}

// MARK:- Public
extension RSSelectionMenuDelegate {
    
    /// Check for selection status
    public func showSelected(item: T, inTableView tableView: RSSelectionTableView<T>) -> Bool {
        selectedItems.contains(item)
    }
    
    /// Remove all selected items
    public func removeAllSelectedItems() {
        selectedItems.removeAll()
    }
}


// MARK:- Private
extension RSSelectionMenuDelegate {
    
    /// Action handler for single selection
    fileprivate func handleActionForSingleSelection(item: T, index: Int, tableView: RSSelectionTableView<T>) {
        self.removeAllSelectedItems()
        
        // add to selected list
        selectedItems.append(item)
        
        // reload tableview
        tableView.reload()
        
        // call selection callback
        if let delegate = selectionDelegate {
            delegate(item, index, true, selectedItems)
        }
    }
    
    /// Action handler for multiple selection tableview
    fileprivate func handleActionForMultiSelection(item: T, index: Int, tableView: RSSelectionTableView<T>) {
        
        // is selected
        var selected = false
        
        // remove if already selected
        if let selectedIndex = selectedItems.firstIndex(where: { $0 == item }) {
            selectedItems.remove(at: selectedIndex)
        }
        
        // check if selected items reached to max limit, if specified
        else if maxSelectedLimit == nil || selectedItems.count < maxSelectedLimit! {
            selectedItems.append(item)
            selected = true
        }
        
        // reload tableview
        tableView.reload()
        
        // call selection callback
        if let delegate = selectionDelegate {
            delegate(item, index, selected, selectedItems)
        }
    }
    
    /// First row selection handler
    fileprivate func handleActionForFirstRow(tableView: RSSelectionTableView<T>) {
        
        // remove all selected when first row select
        self.removeAllSelectedItems()
        
        // update first row selection
        let selected = !(tableView.firstRowSelection?.selected ?? false)
        updateFirstRowSelection(selected: selected, tableView: tableView)
        
        // reload tableview
        tableView.reload()
        
        // selection callback
        if let rowSelection = selectionDelegate {
            rowSelection(nil, 0, false, selectedItems)
        }
        
        // dismiss if required
        tableView.dismissMenuIfRequired()
    }
    
    /// Checks if first row is added
    fileprivate func isFirstRowAdded(inTableView tableView: RSSelectionTableView<T>) -> Bool {
        return tableView.selectionDataSource?.isFirstRowAdded() ?? false
    }
    
    /// Update first row selection
    fileprivate func updateFirstRowSelection(selected: Bool = false, tableView: RSSelectionTableView<T>) {
        tableView.firstRowSelection?.selected = selected
        
        guard let rowSelection = tableView.firstRowSelection,
            let delegate = rowSelection.delegate else {
                return
        }
        
        // calling delegate
        delegate(rowSelection.rowType.value, selected)
    }
    
    /// Checks if searchbar is added
    fileprivate func isSearchBarAdded(_ tableView: UITableView) -> (Bool, UISearchBar?) {
        let selectionTableView = tableView as! RSSelectionTableView<T>
        if let searchBar = selectionTableView.searchControllerDelegate?.searchBar {
            return (true, searchBar)
        }
        return (false, nil)
    }
}

