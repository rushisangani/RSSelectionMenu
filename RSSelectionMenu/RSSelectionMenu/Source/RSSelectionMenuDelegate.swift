//
//  RSSelectionMenuDelegate.swift
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

open class RSSelectionMenuDelegate<T>: NSObject, UITableViewDelegate {

    // MARK: - Properties

    /// tableview cell selection delegate
    var selectionDelegate: UITableViewCellSelection<T>? = nil
    
    /// selected objects
    var selectedObjects = DataSource<T>()
    
    // MARK: - Initialize
    convenience init(selectedItems: DataSource<T>) {
        self.init()
        selectedObjects = selectedItems
    }
    
    // MARK:- UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let selectionTableView = tableView as! RSSelectionTableView<T>
        
        // first row selected
        if indexPath.row == 0 && isFirstRowAdded(inTableView: selectionTableView) {
            
            handleActionForFirstRow(tableView: selectionTableView)
            return
        }
        
        // update first row
        updateFirstRowSelection(tableView: selectionTableView)
        
        // selected object
        let dataObject = selectionTableView.objectAt(indexPath: indexPath)
        
        // single selection
        if selectionTableView.selectionType == .Single {
            handleActionForSingleSelection(object: dataObject, tableView: selectionTableView)
        }
        else {
            // multiple selection
            handleActionForMultiSelection(object: dataObject, tableView: selectionTableView)
        }
        
        // dismiss if required
        selectionTableView.dismissControllerIfRequired()
    }
}

// MARK:- Private
extension RSSelectionMenuDelegate {
    
    /// action handler for single selection tableview
    fileprivate func handleActionForSingleSelection(object: T, tableView: RSSelectionTableView<T>) {
        removeAllSelected()
        
        // add to selected list
        selectedObjects.append(object)
        
        // reload tableview
        tableView.reloadData()
        
        // selection callback
        if let delegate = selectionDelegate {
            delegate(object, true, selectedObjects)
        }
    }
    
    /// action handler for multiple selection tableview
    fileprivate func handleActionForMultiSelection(object: T, tableView: RSSelectionTableView<T>) {
        
        // is selected
        var isSelected = false
        
        // remove if already selected
        if let selectedIndex = tableView.selectionMenu?.isSelected(object: object, from: selectedObjects) {
            selectedObjects.remove(at: selectedIndex)
        }
        else {
            selectedObjects.append(object)
            isSelected = true
        }
        
        // reload tableview
        tableView.reloadData()
        
        // selection callback
        if let delegate = selectionDelegate {
            delegate(object, isSelected, selectedObjects)
        }
    }
    
    /// first row selection handler
    fileprivate func handleActionForFirstRow(tableView: RSSelectionTableView<T>) {
        
        // remove all selected when first row select
        removeAllSelected()
        
        // update first row selection
        updateFirstRowSelection(selected: !(tableView.firstRowSelection?.selected)!, tableView: tableView)
        
        // reload tableview
        tableView.reloadData()
        
        // selection callback
        if let rowSelection = selectionDelegate {
            rowSelection(nil, false, selectedObjects)
        }
        
        // dismiss if required
        tableView.dismissControllerIfRequired()
    }
    
    /// checks if first row is added
    fileprivate func isFirstRowAdded(inTableView: RSSelectionTableView<T>) -> Bool {
        return (inTableView.selectionDataSource?.isFirstRowAdded())!
    }
    
    /// update first row selection
    fileprivate func updateFirstRowSelection(selected: Bool? = false, tableView: RSSelectionTableView<T>) {
        if let rowSelection = tableView.firstRowSelection {
            
            rowSelection.selected = selected!
            rowSelection.delegate!((rowSelection.rowType?.value)!, selected!)
        }
    }
}

// MARK:- Public
extension RSSelectionMenuDelegate {
    
    /// check for selection status
    public func showSelected(object: T, inTableView: RSSelectionTableView<T>) -> Bool {
        return inTableView.selectionMenu!.containsObject(object, inDataSource: selectedObjects)
    }
    
    /// remove selected objects
    public func removeAllSelected() {
        selectedObjects.removeAll()
    }
}
