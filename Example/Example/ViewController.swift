//
//  ViewController.swift
//  Example
//
//  Created by Rushi on 06/10/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit
import RSSelectionMenu

class ViewController: UITableViewController {

    // MARK: - Properties
    
    let simpleDataArray = ["Sachin", "Rahul", "Saurav", "Virat", "Suresh", "Ravindra", "Chris", "Steve", "Anil"]
    var simpleSelectedArray = ["Rahul"]
    
    let dataArray = ["Sachin Tendulkar", "Rahul Dravid", "Saurav Ganguli", "Virat Kohli", "Suresh Raina", "Ravindra Jadeja", "Chris Gyle", "Steve Smith", "Anil Kumble"]
    var selectedDataArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    func showAsPush() {
        
        // show with datasource and selected items
        let selectionMenu = RSSelectionMenu(dataSource: simpleDataArray as DataSource, selectedItems: simpleSelectedArray as DataSource) { (cell, object, indexPath) in
            cell.textLabel?.text = object as? String
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedData) in
            self.simpleSelectedArray = selectedData as! [String]
        }
        selectionMenu.show(with: .push, from: self)
    }
    
    func presentModallyWithRightDetail() {
        
        // show with datasource, selected items with cellType = rightDetail
        let selectionMenu = RSSelectionMenu(dataSource: dataArray as DataSource, selectedItems: selectedDataArray as DataSource, cellType: .rightDetail) { (cell, object, indexPath) in
            
            let firstName = (object as! String).components(separatedBy: " ").first
            let lastName = (object as! String).components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
            cell.detailTextLabel?.text = lastName
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedArray) in
            self.selectedDataArray = selectedArray as! [String]
        }
        
        selectionMenu.show(from: self)
    }
    
    func showAsPopoverWithSubTitle(sender: UIView) {
        
        // show as popover with datasource, selected items with cellType = subTitle
        
        let selectionMenu = RSSelectionMenu(dataSource: dataArray as DataSource, selectedItems: selectedDataArray as DataSource, cellType: .subTitle) { (cell, object, indexPath) in
            
            let firstName = (object as! String).components(separatedBy: " ").first
            let lastName = (object as! String).components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
            cell.detailTextLabel?.text = lastName
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedArray) in
            self.selectedDataArray = selectedArray as! [String]
        }
        selectionMenu.showAsPopover(from: sender, inViewController: self)
    }
    
    func presentModallyWithMultiSelectionAndSearch() {
     
        // show with datasource, selected items, multiple selection and search
        let selectionMenu = RSSelectionMenu(selectionType: .multiple, dataSource: simpleDataArray as DataSource, selectedItems: simpleSelectedArray as DataSource) { (cell, object, indexPath) in
            
            cell.textLabel?.text = object as? String
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedData) in
            self.simpleSelectedArray = selectedData as! [String]
        }
        
        // add searchbar
        selectionMenu.addSearchBar { (searchText) -> (FilteredDataSource) in
            
            // return filtered array based on condition
            return self.simpleDataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) }) as FilteredDataSource
        }
        
        selectionMenu.show(from: self)
    }
    
    func showAsPopoverWithMultiSelect(sender: UIView) {
        
        // show as popover with datasource, selected items, multiple selection
        let selectionMenu = RSSelectionMenu(selectionType: .multiple, dataSource: simpleDataArray as DataSource, selectedItems: simpleSelectedArray as DataSource) { (cell, object, indexPath) in
            
            cell.textLabel?.text = object as? String
        }
        
        selectionMenu.didSelectRow { (object, isSelected, selectedData) in
            self.simpleSelectedArray = selectedData as! [String]
        }
        
        // specify size
        selectionMenu.showAsPopover(from: sender, inViewController: self, with: CGSize(width: 300, height: 220))
    }
    
    func showWithCustomCell() {
        
        // show with datasource and selected items with custom cells and models
        // specify unique key in your models or dictionary to identify the object
        
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
                showAsPopoverWithSubTitle(sender: cell!)
                break
            default:
                break
            }
            
            return
        }
        
        // multi selection
        
        if indexPath.section == 1 {
            
            switch indexPath.row {
            case 0:
                presentModallyWithMultiSelectionAndSearch()
                break
            case 1:
                showAsPopoverWithMultiSelect(sender: cell!)
                break
            default:
                break
            }
            
            return
        }
        
        // custom cell
        showWithCustomCell()
    }
}

