//
//  CustomCells.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 24/07/18.
//  Copyright © 2019 Rushi Sangani. All rights reserved.
//

import Foundation
import RSSelectionMenu

extension ViewController {
    
    // MARK: - Custom
    
    // MARK: - Custom Cells
    
    func showWithCustomCell() {
        
        // Show menu with CellType = custom
        // For Custom cells - specify NibName and CellIdentifier
        // For Custom Models - specify UniquePropertyName
        
        let cellNibName = "CustomTableViewCell"
        let cellIdentifier = "cell"
        
        // create menu with multi selection and custom cell
        
        let selectionMenu =  RSSelectionMenu(selectionStyle: .multiple, dataSource: customDataArray, cellType: .customNib(nibName: cellNibName, cellIdentifier: cellIdentifier)) { (cell, person, indexPath) in
            
            // cast cell to your custom cell type
            let customCell = cell as! CustomTableViewCell
            
            // here you'll get specified model object
            // set data based on your need
            customCell.setData(person)
        }
        
        // show with default selected items
        selectionMenu.setSelectedItems(items: customselectedDataArray) { (text, index, selected, selectedItems) in
        }
        
        // show searchbar
        selectionMenu.showSearchBar { [weak self] (searchtext) -> ([Person]) in
            return self?.customDataArray.filter({ $0.firstName.lowercased().hasPrefix(searchtext.lowercased()) }) ?? []
        }
        
        // cell selection style
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        // on dismiss handler - get selected items
        selectionMenu.onDismiss = { [weak self] selectedItems in
            
            // update selected items
            self?.customselectedDataArray = selectedItems
        }
        
        // show menu
        selectionMenu.show(style: .push, from: self)
    }
    
    
    // MARK: - Custom Models
    
    func showWithCustomModels() {
        
        // create menu with custom cells and custom models
        
        // custom cell details
        let cellNibName = "CustomTableViewCell"
        let cellIdentifier = "cell"
        
        let selectionMenu =  RSSelectionMenu(selectionStyle: .multiple, dataSource: users, cellType: .customNib(nibName: cellNibName, cellIdentifier: cellIdentifier)) { (cell, user, indexPath) in
            
            let customCell = cell as! CustomTableViewCell
            
            // set custom details
            customCell.idLabel.text = "\(user.id ?? 0)"
            customCell.firstNameLabel.text = user.name
            customCell.lastNameLabel.text = user.organization
            
            customCell.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
        // provide selected items and selection delegate
        selectionMenu.setSelectedItems(items: selectedUsers) { [weak self] (user, index, selected, items) in
            self?.selectedUsers = items
        }
        
        // navigationbar
        selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), tintColor: UIColor.white)
        
        // cell selection style
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        // present menu
        selectionMenu.show(style: .present, from: self)
    }
}
