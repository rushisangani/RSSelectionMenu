//
//  MultipleSelectionHandler.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 23/07/18.
//  Copyright © 2019 Rushi Sangani. All rights reserved.
//

import Foundation
import RSSelectionMenu

extension ViewController {
    
    // MARK: - Multi-Selection
    
    // MARK: - Push or Present
    
    func showWithMultiSelect(style: PresentationStyle) {
        
        // set selection type - multiple
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: simpleDataArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            // customization
            // set image
            cell.imageView?.image = #imageLiteral(resourceName: "profile")
            cell.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        
        
        // add first row as 'All'
        let allSelected = (simpleSelectedArray.count == 0)
        
        selectionMenu.addFirstRowAs(rowType: .all, showSelected: allSelected) { (text, selected) in
            
            if selected {
                
                /// do some stuff...
                print("All option selected")
            }
        }
        
        // cell selection style
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        // selected items and delegate
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (name, index, selected, selectedItems) in
        }
        
        /// provide - maximum selection limit (optional)
        // max selection item 3
        
        if case .present = style {
            selectionMenu.maxSelectionLimit = 3
        }
        
        // on dismiss handler
        selectionMenu.onDismiss = { [weak self] items in
            
            self?.simpleSelectedArray = items
            
            /// do some stuff on menu dismiss
            
            let displayText = items.joined(separator: ", ")
            
            if case .push = style {
                self?.multiSelectPushLabel.text = displayText.isEmpty ? "All" : displayText
            }else {
                self?.multiSelectCustomRowLabel.text = displayText.isEmpty ? "All" : displayText
            }

            self?.tableView.reloadData()
        }
        
        // show menu
        selectionMenu.show(style: style, from: self)
    }
    
    
    // MARK: - Popover - Multi Select & Search with subTitle cell
    
    func showAsMultiSelectPopover(sender: UIView) {
        
        // selection type as multiple with subTitle Cell
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: dataArray, cellType: .subTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name.components(separatedBy: " ").first
            cell.detailTextLabel?.text = name.components(separatedBy: " ").last
        }
        
        // selected items
        
        selectionMenu.setSelectedItems(items: selectedDataArray) { [weak self] (text, index, selected, selectedList) in
            
            // update list
            self?.selectedDataArray = selectedList
            
            /// do some stuff...
            
            // update value label
            self?.multiSelectPopoverLabel.text = selectedList.joined(separator: ", ")
            self?.tableView.reloadData()
        }
        
        // search bar
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in
            return self?.dataArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) }) ?? []
        }
        
        // show empty data label - provide custom text (if needed)
        selectionMenu.showEmptyDataLabel(text: "No Player Found")
        
        // cell selection style
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        // show as popover
        // specify popover size if needed
        // size = nil (auto adjust size)
        selectionMenu.show(style: .popover(sourceView: sender, size: nil), from: self)
    }
}
