//
//  ViewControllerDataSource.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 22/07/18.
//  Copyright © 2019 Rushi Sangani. All rights reserved.
//

import Foundation
import RSSelectionMenu

/// Extension
extension ViewController {
    
    // MARK:- SINGLE SELECTION
    
    // MARK:- Simple Push or Present
    
    func showSingleSelectionMenu(style: PresentationStyle) {
        
        // Show menu with datasource array - Default SelectionStyle = single
        // Here you'll get cell configuration where you'll get array item for each index
        // Cell configuration following parameters.
        // 1. UITableViewCell   2. Item of type T   3. IndexPath
        
        var tableViewStyle: UITableView.Style = .plain
        if #available(iOS 13.0, *) {
            tableViewStyle = UITableView.Style.insetGrouped
        }
        
        let selectionMenu = RSSelectionMenu(dataSource: simpleDataArray, tableViewStyle: tableViewStyle) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        // set default selected items when menu present on screen.
        // here you'll get handler each time you select a row
        // 1. Selected Item  2. Index of Selected Item  3. Selected or Deselected  4. All Selected Items
        
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { [weak self] (text, index, isSelected, selectedItems) in
            
            // update your existing array with updated selected items, so when menu show menu next time, updated items will be default selected.
            self?.simpleSelectedArray = selectedItems
            
            
            /// do some stuff...
            /// setting labels here.
            
            switch style {
            case .push:
                self?.pushDetailLabel.text = text
            case .present:
                self?.presentDetailLabel.text = text
            default:
                break
            }
            
            self?.tableView.reloadData()
        }
        
        
        /// set cell selection style - Default is 'tickmark'
        /// (Optional)
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        
        /// Customization
        /// set navigationBar title, attributes and colors
        
        selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), tintColor: UIColor.white)
        
        // show menu as (push or present)
        selectionMenu.show(style: style, from: self)
    }
    
    
    // MARK:- Formsheet & SearchBar
    
    func showAsFormsheet() {
        
        /// You can also set selection style - while creating menu instance
        
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: dataArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            // cell customization
            // set tint color
            cell.tintColor = UIColor.orange
        }
        
        // provide - selected items and selection delegate
        
        menu.setSelectedItems(items: selectedDataArray) { [weak self] (name, index, selected, selectedItems) in
            self?.selectedDataArray = selectedItems
            
            /// do some stuff...
            
            self?.formsheetDetailLabel.text = name
            self?.tableView.reloadData()
        }
        
        // show with search bar

        menu.showSearchBar { [weak self] (searchText) -> ([String]) in
            
            // Filter your result from data source based on any condition
            // Here data is filtered by name that starts with the search text
            
            return self?.dataArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) }) ?? []
        }
        
        // cell selection style
        menu.cellSelectionStyle = self.cellSelectionStyle
        
        // show empty data label - if needed
        // Note: Default text is 'No data found'
        
        menu.showEmptyDataLabel()
        
        // show as formsheet
        menu.show(style: .formSheet(size: nil), from: self)
    }
    
    
    // MARK:- Popover with cell style - subTitle & get onDismiss Handler
    
    func showAsPopover(sender: UIView) {
        
        /// cell with SubTitle Label
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: dataArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            // cell customization
            cell.tintColor = UIColor.red
        }
        
        // selection delegate
        menu.setSelectedItems(items: selectedDataArray) { [weak self] (name, index, selected, selectedItems) in
            self?.selectedDataArray = selectedItems
        }
        
        // title
        menu.setNavigationBar(title: "Select Player")
        
        // on dissmis handler
        menu.onDismiss = { selectedItems in
            
            /// do some stuff
            
            self.popoverDetailLabel.text = selectedItems.first
            self.tableView.reloadData()
        }

        // selection style
        menu.cellSelectionStyle = self.cellSelectionStyle
        
        // show as Popover
        menu.show(style: .popover(sourceView: sender, size: nil, arrowDirection: .down, hideNavBar: true), from: self)
    }
    
    
    
    // MARK:- Extra Header Row
    
    func showWithFirstRow() {
        
        // create menu
        let selectionMenu = RSSelectionMenu(dataSource: dataArray) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        
        // set navigation bar title and attributes
        selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), tintColor: UIColor.white)
        

        // selected items
        selectionMenu.setSelectedItems(items: selectedDataArray) { (text, index, isSelected, selectedItems) in
        }
        
        
        /// add first row as empty -> Allow empty selection
        let isEmpty = (selectedDataArray.count == 0)
        
        selectionMenu.addFirstRowAs(rowType: .empty, showSelected: isEmpty) { (text, selected) in
            
            /// do some stuff...
            if selected {
                print("Empty Option Selected")
            }
        }
        
        // cell selection style
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        
        // search bar with place holder
        selectionMenu.showSearchBar(withPlaceHolder: "Search Player", barTintColor: UIColor.lightGray.withAlphaComponent(0.2)) { [weak self] (searchText) -> ([String]) in
            
            return self?.dataArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) }) ?? []
        }
        
        // on menu dissmiss
        selectionMenu.onDismiss = { [weak self] selectedItems in
            
            self?.selectedDataArray = selectedItems
            
            /// do some stuff when menu is dismssed
            
            if selectedItems.count == 0 {
                self?.extraRowDetailLabel.text = ""
            }else {
                self?.extraRowDetailLabel.text = selectedItems.first
            }
            self?.tableView.reloadData()
        }
        
        // show menu
        selectionMenu.show(style: .push, from: self)
    }
    
    
    // MARK:- Alert or Actionsheet - You can also provide buttons as needed
    
    func showAsAlertController(style: UIAlertController.Style, title: String?, action: String?, height: Double?) {
        let selectionStyle: SelectionStyle = style == .alert ? .single : .multiple
        
        // create menu
        let selectionMenu =  RSSelectionMenu(selectionStyle: selectionStyle, dataSource: simpleDataArray) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        
        // provide selected items
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, index, isSelected, selectedItems) in
        }
        
        // on dismiss handler
        selectionMenu.onDismiss = { [weak self] items in
            
            self?.simpleSelectedArray = items
            
            if style == .alert {
                self?.alertRowDetailLabel.text = items.first
            }else {
                self?.multiSelectActionSheetLabel.text = items.joined(separator: ", ")
            }
            self?.tableView.reloadData()
        }
        
        // cell selection style
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        
        // show - with action (if provided)
        let menuStyle: PresentationStyle = style == .alert ? .alert(title: title, action: action, height: height) : .actionSheet(title: title, action: action, height: height)
        
        selectionMenu.show(style: menuStyle, from: self)
    }
}

