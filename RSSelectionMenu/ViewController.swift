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
        
        let selectionMenu = RSSelectionMenu(selectionType: .multiple, dataSource: dataArray as DataSource) { (cell, object, indexPath) -> (Bool) in
            cell.textLabel?.text = object as? String
            return self.selectedArray.contains((cell.textLabel?.text)!)
        }
        
        selectionMenu.didSelectRow { (object, selected, selectedArray) in
            self.selectedArray = selectedArray as! [String]
        }
        
//        selectionMenu.addSearchBar { (searchText) -> (FilteredDataSource) in
//            return self.dataArray.filter({ $0.hasPrefix(searchText) }) as FilteredDataSource
//        }
        
        //selectionMenu.show(from: self)
        selectionMenu.showAsPopover(from: (sender as! UIButton), inViewController: self)
    }
}

