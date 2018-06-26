//
//  ViewController.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 16/10/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit
import RSSelectionMenu

class ViewController: UITableViewController {
    
    // MARK: - Properties
    
    let simpleDataArray = ["Sachin", "Rahul", "Saurav", "Virat", "Suresh", "Ravindra", "Chris", "Steve", "Anil"]
    var simpleSelectedArray = [String]()
    
    var firstRowSelected = true
    
    let dataArray = ["Sachin Tendulkar", "Rahul Dravid", "Saurav Ganguli", "Virat Kohli", "Suresh Raina", "Ravindra Jadeja", "Chris Gyle", "Steve Smith", "Anil Kumble"]
    var selectedDataArray = [String]()
    
    var customDataArray = [Person]()
    var customselectedDataArray = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customDataArray.append(Person(id: 1, firstName: "Sachin", lastName: "Tendulkar"))
        customDataArray.append(Person(id: 2, firstName: "Rahul", lastName: "Dravid"))
        customDataArray.append(Person(id: 3, firstName: "Virat", lastName: "Kohli"))
        customDataArray.append(Person(id: 4, firstName: "Suresh", lastName: "Raina"))
        customDataArray.append(Person(id: 5, firstName: "Chris", lastName: "Gyle"))
        customDataArray.append(Person(id: 6, firstName: "Ravindra", lastName: "Jadeja"))
    }
    
    // MARK: - Actions
    
    func showAsPush() {
        
        // Show menu with datasource array - Default SelectionType = Single
        // Here you'll get cell configuration where you can set any text based on condition
        // Cell configuration following parameters.
        // 1. UITableViewCell   2. Object of type T   3. IndexPath
        
        let selectionMenu =  RSSelectionMenu(dataSource: simpleDataArray) { (cell, object, indexPath) in
            cell.textLabel?.text = object
            
            // Change tint color (if needed)
            cell.tintColor = .orange
        }
        
        // set navigation title
        selectionMenu.setNavigationBar(title: "Select Player")
        
        // set default selected items when menu present on screen.
        // Here you'll get onDidSelectRow
        
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, isSelected, selectedItems) in
            
            // update your existing array with updated selected items, so when menu presents second time updated items will be default selected.
            self.simpleSelectedArray = selectedItems
        }
        
        // show as PresentationStyle = Push
        selectionMenu.show(style: .Push, from: self)
    }
    
    func presentModallyWithRightDetail() {
        
        // Show menu with datasource array - SelectionType = Single & CellType = RightDetail
        
        let selectionMenu =  RSSelectionMenu(selectionType: .Single, dataSource: dataArray, cellType: .RightDetail) { (cell, object, indexPath) in
            
            // here you can set any text from object
            // let's set firstname in title and lastname as right detail
            
            let firstName = object.components(separatedBy: " ").first
            let lastName = object.components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
            cell.detailTextLabel?.text = lastName
        }
        
        selectionMenu.setSelectedItems(items: selectedDataArray) { (text, selected, selectedItems) in
            self.selectedDataArray = selectedItems
        }
        
        // To show first row as Empty, when dropdown as no value selected by default
        // Here you'll get Text and isSelected when user selects first row
        
        selectionMenu.addFirstRowAs(rowType: .Empty, showSelected: self.firstRowSelected) { (text, isSelected) in
            self.firstRowSelected = isSelected
        }
        
        // show as default
        selectionMenu.show(from: self)
    }
    
    func showAsFormSheetWithSearch() {
        
        // Show menu with datasource array - PresentationStyle = Formsheet & SearchBar
        
        let selectionMenu = RSSelectionMenu(dataSource: dataArray) { (cell, object, indexPath) in
            cell.textLabel?.text = object
        }
        
        // show selected items
        selectionMenu.setSelectedItems(items: selectedDataArray) { (text, selected, selectedItems) in
            
        }
        
        // show searchbar with placeholder text and barTintColor
        // Here you'll get search text - when user types in seachbar
        
        selectionMenu.showSearchBar(withPlaceHolder: "Search Player", tintColor: UIColor.white.withAlphaComponent(0.3)) { (searchText) -> ([String]) in
            
            // return filtered array based on any condition
            // here let's return array where firstname starts with specified search text
            
            return self.dataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
        }
        
        // get on dismiss event with selected items
        selectionMenu.onDismiss = { selectedItems in
            self.selectedDataArray = selectedItems
        }
        
        // show as formsheet
        selectionMenu.show(style: .Formsheet, from: self)
    }
    
    func showAsPopover(_ sender: UIView) {
        
        // Show as Popover with datasource
        
        let selectionMenu = RSSelectionMenu(dataSource: simpleDataArray) { (cell, object, indexPath) in
            cell.textLabel?.text = object
        }
        
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, isSelected, selectedItems) in
            
            // update your existing array with updated selected items, so when menu presents second time updated items will be default selected.
            self.simpleSelectedArray = selectedItems
        }
        
        // show as popover
        // Here specify popover sourceView and size of popover
        // specifying nil will present with default size
        
        selectionMenu.show(style: .Popover(sourceView: sender, size: nil), from: self)
    }
    
    func presentWithMultiSelectionAndSearch() {
        
        // Show menu with datasource array - SelectionType = Multiple, CellType = SubTitle & SearchBar
        
        let selectionMenu =  RSSelectionMenu(selectionType: .Multiple, dataSource: dataArray, cellType: .SubTitle) { (cell, object, indexPath) in
            
            // set firstname in title and lastname as subTitle
            
            let firstName = object.components(separatedBy: " ").first
            let lastName = object.components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
            cell.detailTextLabel?.text = lastName
        }
        
        selectionMenu.setSelectedItems(items: selectedDataArray) { (text, selected, selectedItems) in
            self.selectedDataArray = selectedItems
        }
        
        // To show first row as All, when dropdown as All selected by default
        // Here you'll get Text and isSelected when user selects first row
        
        selectionMenu.addFirstRowAs(rowType: .All, showSelected: self.firstRowSelected) { (text, isSelected) in
            self.firstRowSelected = isSelected
        }
        
        // show searchbar
        // Here you'll get search text - when user types in seachbar
        selectionMenu.showSearchBar { (searchtext) -> ([String]) in
            return self.dataArray.filter({ $0.lowercased().hasPrefix(searchtext.lowercased()) })
        }
        
        // set navigationbar theme
        selectionMenu.setNavigationBar(title: "Select Player", attributes: nil, barTintColor: UIColor.orange.withAlphaComponent(0.5), tintColor: UIColor.white)
        
        // right barbutton title
        selectionMenu.rightBarButtonTitle = "Submit"
        
        // show as default
        selectionMenu.show(from: self)
    }
    
    func showWithCustomCell() {
        
        // Show menu with datasource array with Models - SelectionType = Multiple, CellType = Custom
        // For Custom cells - You need to specify NibName and CellIdentifier
        // For Custom Models - You need to specify UniquePropertyName
        
        let selectionMenu =  RSSelectionMenu(selectionType: .Multiple, dataSource: customDataArray, cellType: .Custom(nibName: "CustomTableViewCell", cellIdentifier: "cell")) { (cell, person, indexPath) in
            
            // cast cell to your custom cell type
            let customCell = cell as! CustomTableViewCell
            
            // here you'll get specified model object
            // set data based on your need
            customCell.setData(person)
        }
        
        // show with default selected items and update when user selects any row
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
}

// MARK:- UITableViewDelegate
extension ViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        
        // single selection
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                showAsPush()
                break
            case 1:
                presentModallyWithRightDetail()
                break
            case 2:
                showAsFormSheetWithSearch()
                break
            case 3:
                showAsPopover(cell!)
                break
                
            default:
                break
            }
            
            return
        }
        
        // multi selection
        
        if indexPath.section == 1 {
            presentWithMultiSelectionAndSearch()
            return
        }
        
        // custom cell
        showWithCustomCell()
    }
}
