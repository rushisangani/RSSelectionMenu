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
    
    //MARK: - Outlets
    @IBOutlet weak var pushDetailLabel: UILabel!
    @IBOutlet weak var presentDetailLabel: UILabel!
    @IBOutlet weak var formsheetDetailLabel: UILabel!
    @IBOutlet weak var popoverDetailLabel: UILabel!
    @IBOutlet weak var extraRowDetailLabel: UILabel!
    
    @IBOutlet weak var multiSelectPushLabel: UILabel!
    @IBOutlet weak var multiSelectPopoverLabel: UILabel!
    @IBOutlet weak var multiSelectCustomRowLabel: UILabel!
    
    // MARK: - Properties
    
    /// Simple Data Array
    let simpleDataArray = ["Sachin", "Rahul", "Saurav", "Virat", "Suresh", "Ravindra", "Chris", "Steve", "Anil"]
    var simpleSelectedArray = [String]()
    
    /// First Row as selected
    var firstRowSelected = true
    
    /// Data Array
    let dataArray = ["Sachin Tendulkar", "Rahul Dravid", "Saurav Ganguli", "Virat Kohli", "Suresh Raina", "Ravindra Jadeja", "Chris Gyle", "Steve Smith", "Anil Kumble"]
    var selectedDataArray = [String]()
    
    /// Custom Data Array
    var customDataArray = [Person]()
    var customselectedDataArray = [Person]()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCustomData()
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
                self.showSingleSelectionMenu(style: .Push)
            case 1:
                self.showSingleSelectionMenu(style: .Present)
            case 2:
                self.showAsFormsheet()
            case 3:
                self.showAsPopover(sender: cell!)
            case 4:
                self.showWithFirstRow()
            default:
                break
            }
        }
        
        // multi selection
        else if indexPath.section == 1 {

            switch indexPath.row {
            case 0:
                self.showWithMultiSelect(style: .Push)
            case 1:
                self.showAsMultiSelectPopover(sender: cell!)
            case 2:
                self.showWithMultiSelect(style: .Present)
            default:
                break
            }
        }
        else {
            
            // custom cell
            showWithCustomCell()
        }
    }
}

// MARK: - Data Preparation
extension ViewController {
    
    func prepareCustomData() {
        
        customDataArray.append(Person(id: 1, firstName: "Sachin", lastName: "Tendulkar"))
        customDataArray.append(Person(id: 2, firstName: "Rahul", lastName: "Dravid"))
        customDataArray.append(Person(id: 3, firstName: "Virat", lastName: "Kohli"))
        customDataArray.append(Person(id: 4, firstName: "Suresh", lastName: "Raina"))
        customDataArray.append(Person(id: 5, firstName: "Chris", lastName: "Gyle"))
        customDataArray.append(Person(id: 6, firstName: "Ravindra", lastName: "Jadeja"))
    }
}
