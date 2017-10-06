//
//  ViewController.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dataArray: [String] = ["Rushi", "Rahul", "Mitesh", "Nirav", "Vishal", "Neha", "Hiral", "Swati", "Namita", "Deepali", "Zeel"]
    var selectedArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showButtonClicked(_ sender: Any) {
        
        let selectionMenu = RSSelectionMenu(dataSource: dataArray as DataSource, cellType: .rightDetail) { (cell, object, indexPath) -> (Bool) in
            
            cell.textLabel?.text = object as? String
            cell.detailTextLabel?.text = "details"
            return self.selectedArray.contains(object as! String)
        }
        
        selectionMenu.didSelectRow(dismissOnSelect: false) { (object, isSelected, array) in
            self.selectedArray = array as! [String]
            
        }
        
//        selectionMenu.addSearchBar { (text) -> (FilteredDataSource) in
//            return self.dataArray.filter({ $0.hasPrefix(text) }) as FilteredDataSource
//        }
        
        selectionMenu.showAsPopover(from: (sender as! UIButton), inViewController: self)
        //selectionMenu.showAsPopover(from: (sender as! UIButton), inViewController: self)
    }
}

