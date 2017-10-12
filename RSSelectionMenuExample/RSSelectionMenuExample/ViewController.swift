//
//  ViewController.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 06/10/17.
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
        
        // show with datasource and selected items
        
        let selectionMenu = RSSelectionMenu(dataSource: simpleDataArray, selectedItems: simpleSelectedArray) { (cell, object, indexPath) in
            cell.textLabel?.text = object
        }
        
        // title
        selectionMenu.setNavigationBar(title: "Select Player")
        
        selectionMenu.didSelectRow { (object, isSelected, selectedData) in
            
            // update existing array on select
            self.simpleSelectedArray = selectedData
        }
        selectionMenu.show(style: .push, from: self)
    }
    
    func presentModallyWithRightDetail() {
        
        // show with datasource, selected items with cellType = rightDetail
        // show first row as None
        
        let selectionMenu = RSSelectionMenu(dataSource: dataArray, selectedItems: selectedDataArray, cellType: .rightDetail) { (cell, object, indexPath) in
            
            let firstName = object.components(separatedBy: " ").first
            let lastName = object.components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
            cell.detailTextLabel?.text = lastName
        }
        
        // add first row
        selectionMenu.showFirstRowAs(type: .None, selected: firstRowSelected) { (text, selected) in
            self.firstRowSelected = selected
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedArray) in
            self.selectedDataArray = selectedArray
        }
        
        selectionMenu.show(from: self)
    }
    
    func showAsFormSheetWithSearch() {
        
        let selectionMenu = RSSelectionMenu(dataSource: dataArray, selectedItems: selectedDataArray) { (cell, object, indexPath) in
            
            let firstName = object.components(separatedBy: " ").first
            let lastName = object.components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
            cell.detailTextLabel?.text = lastName
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedArray) in
            self.selectedDataArray = selectedArray
        }
        
        // add searchbar
        selectionMenu.addSearchBar { (searchText) -> ([String]) in
            return self.dataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
        }
        
        selectionMenu.show(style: .formSheet, from: self)
    }
    
    func showAsPopover(sender: UIView) {
        
        // show as popover with datasource, selected items
        let selectionMenu = RSSelectionMenu(dataSource: dataArray, selectedItems: selectedDataArray) { (cell, object, indexPath) in
            
            let firstName = object.components(separatedBy: " ").first
            let lastName = object.components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
            cell.detailTextLabel?.text = lastName
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedArray) in
            self.selectedDataArray = selectedArray
        }
        selectionMenu.showAsPopover(from: sender, inViewController: self)
    }
    
    func presentWithMultiSelectionAndSearch() {
        
        // show with datasource, selected items, multiple selection and search
        let selectionMenu = RSSelectionMenu(selectionType: .multiple, dataSource: simpleDataArray, selectedItems: simpleSelectedArray) { (cell, object, indexPath) in
            
            cell.textLabel?.text = object
        }
        
        // title and color
        selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSForegroundColorAttributeName : UIColor.white], barTintColor: UIColor.orange.withAlphaComponent(0.5))
        
        
        // add first row
        selectionMenu.showFirstRowAs(type: .All, selected: firstRowSelected) { (text, selected) in
            self.firstRowSelected = selected
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedData) in
            self.simpleSelectedArray = selectedData
        }
        
        // add searchbar
        selectionMenu.addSearchBar { (searchText) -> ([String]) in
            return self.simpleDataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
        }
        
        selectionMenu.show(from: self)
    }
    
    func showWithCustomCell() {
        
        // show with datasource and selected items with custom cells and models
        // specify unique key in your models or dictionary to identify the object
        
        let selectionMenu = RSSelectionMenu(selectionType: .multiple, dataSource: customDataArray, selectedItems: customselectedDataArray, uniqueKey: "id") { (cell, person, indexPath) in
            
            let customCell = cell as! CustomTableViewCell
            customCell.setData(person: person)
        }
        
        selectionMenu.registerNib(nibName: "CustomTableViewCell", forCellReuseIdentifier: "cell")
        
        selectionMenu.didSelectRow { (object, isSelected, selectedData) in
            self.customselectedDataArray = selectedData
        }
        
        selectionMenu.addSearchBar { (text) -> ([Person]) in
            return self.customDataArray.filter({ $0.firstName.lowercased().hasPrefix(text.lowercased()) })
        }
        selectionMenu.show(style: .push, from: self)
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
                showAsPopover(sender: cell!)
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
