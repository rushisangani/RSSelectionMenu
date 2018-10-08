//
//  ViewControllerDataSource.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 22/07/18.
//  Copyright © 2018 Rushi Sangani. All rights reserved.
//

import Foundation
import RSSelectionMenu

/// Extension
extension ViewController {
    
    // MARK:- SINGLE SELECTION
    func showSingleSelectionMenu(style: PresentationStyle) {
        
        // Show menu with datasource array - Default SelectionType = Single
        // Here you'll get cell configuration where you can set any text based on condition
        // Cell configuration following parameters.
        // 1. UITableViewCell   2. Object of type T   3. IndexPath
        
        let selectionMenu =  RSSelectionMenu(dataSource: simpleDataArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
        }
        
        // set navigation bar
        selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), tintColor: UIColor.white)
        
        
        // set default selected items when menu present on screen.
        // Here you'll get handler with selected items, each time you select a row
        
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, isSelected, selectedItems) in
            
            // update your existing array with updated selected items, so when menu presents second time updated items will be default selected.
            self.simpleSelectedArray = selectedItems
            
            /// do some stuff...
            
            switch style {
            case .Push:
                self.pushDetailLabel.text = text
            case .Present:
                self.presentDetailLabel.text = text
            default:
                break
            }
            self.tableView.reloadData()
        }
        
        // show menu
        selectionMenu.show(style: style, from: self)
    }
    
    // Formsheet
    func showAsFormsheet() {
        
        let menu = RSSelectionMenu(selectionType: .Single, dataSource: dataArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            cell.tintColor = UIColor.orange
        }
        
        // selection
        menu.setSelectedItems(items: selectedDataArray) { (name, selected, selectedItems) in
            self.selectedDataArray = selectedItems
            
            /// do some stuff...
            
            self.formsheetDetailLabel.text = name
            self.tableView.reloadData()
        }
        
        // search bar
        menu.showSearchBar { (searchText) -> ([String]) in
            
            // Filter your result from data source based on any condition
            // Here data is filtered by name that starts with the search text
            
            return self.dataArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) })
        }
        
        // show as formsheet
        menu.show(style: .Formsheet, from: self)
    }
    
    // Popover
    func showAsPopover(sender: UIView) {
        
        /// cell with SubTitle Label
        let menu = RSSelectionMenu(selectionType: .Single, dataSource: dataArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            // cell customization
            cell.tintColor = UIColor.red
        }
        
        // selection
        menu.setSelectedItems(items: selectedDataArray) { (name, selected, selectedItems) in
            self.selectedDataArray = selectedItems
        }
        
        // title
        menu.setNavigationBar(title: "Select Player")
        
        // on dissmis
        menu.onDismiss = { selectedItems in
            
            /// do some stuff
            
            self.popoverDetailLabel.text = selectedItems.first
            self.tableView.reloadData()
        }

        
        // show as Popover
        menu.show(style: .Popover(sourceView: sender, size: nil), from: self)
    }
    
    func showWithFirstRow() {
        
        // data source array
        let selectionMenu =  RSSelectionMenu(dataSource: dataArray) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        
        // set navigation bar
        selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), tintColor: UIColor.white)
        
        // selected items
        selectionMenu.setSelectedItems(items: selectedDataArray) { (text, isSelected, selectedItems) in
        }
        
        // add first row as empty -> Allow empty selection
        
        let isEmpty = (selectedDataArray.count == 0)
        selectionMenu.addFirstRowAs(rowType: .Empty, showSelected: isEmpty) { (text, selected) in
            
            /// do some stuff...
            if selected {
                print("Empty Option Selected")
            }
        }
        
        // search bar with place holder
        selectionMenu.showSearchBar(withPlaceHolder: "Search Player", tintColor: UIColor.lightGray.withAlphaComponent(0.2)) { (searchText) -> ([String]) in
            
            return self.dataArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) })
        }
        
        // on menu dissmiss
        selectionMenu.onDismiss = { selectedItems in
            self.selectedDataArray = selectedItems
            
            /// do some stuff when menu is dismssed
            
            if selectedItems.count == 0 {
                self.extraRowDetailLabel.text = ""
            }else {
                self.extraRowDetailLabel.text = selectedItems.first
            }
            self.tableView.reloadData()
        }
        
        // show menu
        selectionMenu.show(style: .Push, from: self)
    }
    
    // Alert or Actionsheet
    func showAsAlertController(style: UIAlertController.Style, title: String?, action: String?, height: Double?) {
        let selectionType: SelectionType = style == .alert ? .Single : .Multiple
        
        let selectionMenu =  RSSelectionMenu(selectionType: selectionType, dataSource: simpleDataArray) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, isSelected, selectedItems) in
        }
        
        selectionMenu.onDismiss = { items in
            self.simpleSelectedArray = items
            
            if style == .alert {
                self.alertRowDetailLabel.text = items.first
            }else {
                self.multiSelectActionSheetLabel.text = items.joined(separator: ", ")
            }
            self.tableView.reloadData()
        }
        
        // show
        let menuStyle: PresentationStyle = style == .alert ? .Alert(title: title, action: action, height: height) : .Actionsheet(title: title, action: action, height: height)
        selectionMenu.show(style: menuStyle, from: self)
    }
}

