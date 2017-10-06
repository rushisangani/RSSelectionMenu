//
//  ViewController.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //let dataArray: [String] = ["Rushi", "Rahul", "Mitesh", "Nirav", "Vishal", "Neha", "Hiral", "Swati", "Namita", "Deepali", "Zeel"]
    var selectedArray = [[String: String]]()
    
    let dictArray: [[String:String]] = [
        
        ["id": "1", "name": "Rushi"], ["id": "2", "name": "Rahul"], ["id": "3", "name": "Mitesh"], ["id": "4", "name": "Nirav"], ["id": "5", "name": "Hiral"], ["id": "6", "name": "Swati"], ["id": "7", "name": "Deepali"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showButtonClicked(_ sender: Any) {
        
        let selectionMenu = RSSelectionMenu(dataSource: dictArray as DataSource, selectedItems: selectedArray as DataSource) { (cell, object, indexPath) in
            
            let customCell = cell as! CustomTableViewCell
            let dict = object as! [String: String]
            
            customCell.setTitle(title: dict["name"]!, subTitle: dict["id"]!)
        }
        
        RSSelectionMenu.uniqueKey = "id"
        selectionMenu.registerNib(nibName: "CustomTableViewCell", forCellReuseIdentifier: "cell")
        
        selectionMenu.didSelectRow { (object, isSelected, array) in
            
        }
        
        selectionMenu.didSelectRow { (object, isSelected, array) in
            self.selectedArray = array as! [[String: String]]
        }
        
//        selectionMenu.addSearchBar { (text) -> (FilteredDataSource) in
//            return self.dataArray.filter({ $0.hasPrefix(text) }) as FilteredDataSource
//        }
        
        selectionMenu.showAsPopover(from: (sender as! UIButton), inViewController: self)
        //selectionMenu.showAsPopover(from: (sender as! UIButton), inViewController: self)
    }
}

