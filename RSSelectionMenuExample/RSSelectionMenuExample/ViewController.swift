//
//  ViewController.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 16/10/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit
import RSSelectionMenu

/// ViewController
class ViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var cellStyleSegment: UISegmentedControl!
    @IBOutlet weak var pushDetailLabel: UILabel!
    @IBOutlet weak var presentDetailLabel: UILabel!
    @IBOutlet weak var formsheetDetailLabel: UILabel!
    @IBOutlet weak var popoverDetailLabel: UILabel!
    @IBOutlet weak var extraRowDetailLabel: UILabel!
    @IBOutlet weak var alertRowDetailLabel: UILabel!
    
    @IBOutlet weak var multiSelectPushLabel: UILabel!
    @IBOutlet weak var multiSelectPopoverLabel: UILabel!
    @IBOutlet weak var multiSelectCustomRowLabel: UILabel!
    @IBOutlet weak var multiSelectActionSheetLabel: UILabel!
    
    // MARK: - Properties
    
    /// Simple Data Array
    let simpleDataArray = ["Sachin", "Rahul", "Saurav", "Virat", "Suresh", "Ravindra", "Chris", "Steve", "Anil"]
    var simpleSelectedArray = [String]()
    
    /// Data Array
    let dataArray = ["Sachin Tendulkar", "Rahul Dravid", "Saurav Ganguli", "Virat Kohli", "Suresh Raina", "Ravindra Jadeja", "Chris Gyle", "Steve Smith", "Anil Kumble"]
    var selectedDataArray = [String]()
    
    /// Custom Data Array
    var customDataArray = [Person]()
    var customselectedDataArray = [Person]()
    
    /// Custom models (Swift structs)
    var users = [User]()
    var selectedUsers = [User]()
    
    /// Bottom sheet actions
    var bottomSheetActions = [BottomSheetAction]()
    
    /// First Row as selected
    var firstRowSelected = true
    
    /// Cell Selection Style
    var cellSelectionStyle: CellSelectionStyle = .tickmark
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCustomData()
        prepareBottomSheetData()
    }
    
    // MARK: - Actions
    
    @IBAction func cellStyleChanged(_ sender: Any) {
        cellSelectionStyle = cellStyleSegment.selectedSegmentIndex == 0 ? .tickmark : .checkbox
    }
    
    @IBAction func menuButtonClicked(_ sender: UIBarButtonItem) {
        showBottomSheet(fromBarButton: sender)
    }
}

// MARK:- UITableViewDelegate
extension ViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        
        // single selection
        
        if indexPath.section == 1 {
            
            switch indexPath.row {
            case 0:
                self.showSingleSelectionMenu(style: .push)
            case 1:
                self.showSingleSelectionMenu(style: .present)
            case 2:
                self.showAsFormsheet()
            case 3:
                self.showAsPopover(sender: cell!)
            case 4:
                self.showWithFirstRow()
            case 5:
                self.showAsAlertController(style: .alert, title: "Select Player", action: nil, height: nil)
            default:
                break
            }
        }
        
        // multi selection
        else if indexPath.section == 2 {

            switch indexPath.row {
            case 0:
                self.showWithMultiSelect(style: .push)
            case 1:
                self.showAsMultiSelectPopover(sender: cell!)
            case 2:
                self.showWithMultiSelect(style: .present)
            case 3:
                self.showAsAlertController(style: .actionSheet, title: "Select Player", action: "Done", height: nil)
            default:
                break
            }
        }
        else if indexPath.section == 3 {
            
            // custom cell
            if indexPath.row == 0 {
                self.showWithCustomCell()
            }else {
                self.showWithCustomModels()
            }
        }
    }
}

// MARK: - Data Preparation
extension ViewController {
    
    func prepareCustomData() {
        
        // models
        customDataArray.append(Person(id: 1, firstName: "Sachin", lastName: "Tendulkar"))
        customDataArray.append(Person(id: 2, firstName: "Rahul", lastName: "Dravid"))
        customDataArray.append(Person(id: 3, firstName: "Virat", lastName: "Kohli"))
        customDataArray.append(Person(id: 4, firstName: "Suresh", lastName: "Raina"))
        customDataArray.append(Person(id: 5, firstName: "Chris", lastName: "Gyle"))
        customDataArray.append(Person(id: 6, firstName: "Ravindra", lastName: "Jadeja"))
        
        // struct
        users.append(User(id: 1, name: "AB", organization: "Google"))
        users.append(User(id: 2, name: "Chris", organization: "Amazon"))
        users.append(User(id: 3, name: "John", organization: "Facebook"))
        users.append(User(id: 4, name: "Camila", organization: "AirBnb"))
        users.append(User(id: 6, name: "Denial", organization: "Microsoft"))
    }
    
    func prepareBottomSheetData() {
        let camera = BottomSheetAction(iconName: "camera", title: "Camera")
        let photoLibrary = BottomSheetAction(iconName: "media", title: "Photo Library")
        let attachment = BottomSheetAction(iconName: "attachment", title: "Attachment")
        let cancel = BottomSheetAction(iconName: nil, title: "Cancel")
        
        bottomSheetActions.append(contentsOf: [camera, photoLibrary, attachment, cancel])
    }
}
