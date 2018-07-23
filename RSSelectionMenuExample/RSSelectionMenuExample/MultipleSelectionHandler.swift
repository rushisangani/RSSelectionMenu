//
//  MultipleSelectionHandler.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 23/07/18.
//  Copyright © 2018 Rushi Sangani. All rights reserved.
//

import Foundation
import RSSelectionMenu

extension ViewController {
    
    // MARK: - Multi-Selection
    func showWithMultiSelect(style: PresentationStyle) {
        
        // Set selection type - Multiple
        let selectionMenu = RSSelectionMenu(selectionType: .Multiple, dataSource: simpleDataArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            // set image
            cell.imageView?.image = #imageLiteral(resourceName: "profile")
        }
        
        // add first row as All
        
        let allSelected = (simpleSelectedArray.count == 0)
        selectionMenu.addFirstRowAs(rowType: .All, showSelected: allSelected) { (text, selected) in
            
            if selected {
                
                /// do some stuff...
                print("All option selected")
            }
        }
        
        // selected items
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (name, selected, selectedItems) in
        }
        
        // max selection item 3
        if case .Present = style {
            selectionMenu.maxSelectionLimit = 3
        }
        
        // on dismiss
        selectionMenu.onDismiss = { items in
            self.simpleSelectedArray = items
            
            /// do some stuff on menu dismiss
            let displayText = items.joined(separator: ", ")
            
            if case .Push = style {
                self.multiSelectPushLabel.text = displayText.isEmpty ? "All" : displayText
            }else {
                self.multiSelectCustomRowLabel.text = displayText.isEmpty ? "All" : displayText
            }

            self.tableView.reloadData()
        }
        
        // show menu
        selectionMenu.show(style: .Push, from: self)
    }
    
    // Popover - Multi Select
    func showAsMultiSelectPopover(sender: UIView) {
        
        // selection type as multiple
        
        let selectionMenu = RSSelectionMenu(selectionType: .Multiple, dataSource: dataArray, cellType: .SubTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name.components(separatedBy: " ").first
            cell.detailTextLabel?.text = name.components(separatedBy: " ").last
        }
        
        // selected items

        selectionMenu.setSelectedItems(items: selectedDataArray) { (text, selected, selectedList) in
            
            // update list
            self.selectedDataArray = selectedList
            
            /// do some stuff...
            
            // update value label
            self.multiSelectPopoverLabel.text = selectedList.joined(separator: ", ")
            self.tableView.reloadData()
        }
        
        // search bar
        selectionMenu.showSearchBar { (searchText) -> ([String]) in
            return self.dataArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) })
        }
        
        // show as popover
        selectionMenu.show(style: .Popover(sourceView: sender, size: nil), from: self)
    }
}
