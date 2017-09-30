//
//  ViewController.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dataArray = ["Rushi", "Rahul", "Mitesh", "Nirav", "Vishal", "Neha", "Hiral", "Swati", "Namita", "Deepali", "Zeel"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showButtonClicked(_ sender: Any) {
                
        let selectionMenu = RSSelectionMenu.default.initWith(dataSource: dataArray, cellType: .basic) { (cell, object, indexPath) in
            
            cell.textLabel?.text = object as? String
        }
        
        selectionMenu.didSelectRow { (cell, selected, indexPath) in
            print("row selected at \(indexPath.row)")
        }
        
        selectionMenu.addSearchBar { (searchText) -> (FilteredDataSource) in
            return self.dataArray.filter({ $0.hasPrefix(searchText) })
        }
        
        selectionMenu.show(from: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

