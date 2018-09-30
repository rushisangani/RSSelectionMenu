//
//  CustomCells.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 24/07/18.
//  Copyright © 2018 Rushi Sangani. All rights reserved.
//

import Foundation
import RSSelectionMenu

extension ViewController {
    
    // show with custom cells
    func showWithCustomCell() {
        
        // Show menu with CellType = Custom
        // For Custom cells - specify NibName and CellIdentifier
        // For Custom Models - specify UniquePropertyName
        
        let selectionMenu =  RSSelectionMenu(selectionType: .Multiple, dataSource: customDataArray, cellType: .Custom(nibName: "CustomTableViewCell", cellIdentifier: "cell")) { (cell, person, indexPath) in
            
            // cast cell to your custom cell type
            let customCell = cell as! CustomTableViewCell
            
            // here you'll get specified model object
            // set data based on your need
            customCell.setData(person)
        }
        
        // show with default selected items
        selectionMenu.setSelectedItems(items: customselectedDataArray) { (text, selected, selectedItems) in
        }
        
        // show searchbar
        selectionMenu.showSearchBar { (searchtext) -> ([Person]) in
            return self.customDataArray.filter({ $0.firstName.lowercased().hasPrefix(searchtext.lowercased()) })
        }
        
        // on dismiss handler - get selected items
        selectionMenu.onDismiss = { selectedItems in
            self.customselectedDataArray = selectedItems
        }
        
        selectionMenu.show(style: .Push, from: self)
    }
    
    /// show with custom models
    func showWithCustomModels() {
        
        // menu with custom cells and custom models
        let selectionMenu =  RSSelectionMenu(selectionType: .Multiple, dataSource: users, cellType: .Custom(nibName: "CustomTableViewCell", cellIdentifier: "cell")) { (cell, user, indexPath) in
            
            let customCell = cell as! CustomTableViewCell
            
            customCell.idLabel.text = "\(user.id ?? 0)"
            customCell.firstNameLabel.text = user.name
            customCell.lastNameLabel.text = user.organization
        }
        
        // selected items
        selectionMenu.setSelectedItems(items: selectedUsers) { (user, selected, items) in
            self.selectedUsers = items
        }
        
        // navigationbar
        selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), tintColor: UIColor.white)
        
        
        // unique property
        selectionMenu.uniquePropertyName = "id"
        
        selectionMenu.show(style: .Present, from: self)
    }
}
