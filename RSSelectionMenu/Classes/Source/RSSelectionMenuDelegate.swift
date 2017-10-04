//
//  RSSelectionMenuDelegate.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

/// UITableViewCellSelection
typealias UITableViewCellSelection = ((_ object: Any, _ isSelected: Bool, _ selectedArray: DataSource) -> ())

class RSSelectionMenuDelegate: NSObject {

    // MARK: - Properties
    
    /// tableview selection type - default is single
    fileprivate var selectionType: SelectionType
    
    /// tableview cell selection delegate
    fileprivate let selectionDelegate: UITableViewCellSelection?
    
    /// selected objects
    fileprivate var selectedObjects: DataSource = []
    
    // MARK: - Initialize
    init(type: SelectionType? = .single, delegate: @escaping UITableViewCellSelection) {
        self.selectionType = type!
        self.selectionDelegate = delegate
    }
}

// MARK:- Private
extension RSSelectionMenuDelegate {
    
    /// action handler for single selection tableview
    fileprivate func handleActionForSingleSelectionAt(indexPath: IndexPath, tableView: UITableView) {
        
        // remove all
        selectedObjects.removeAll()
        
        // object
        let dataObject = (tableView.dataSource as! RSSelectionMenuDataSource).objectAt(indexPath: indexPath)
        
        // add to selected list
        selectedObjects.append(dataObject)
        
        // reload tableview
        tableView.reloadData()
        
        // selection callback
        if let delegate = selectionDelegate {
            delegate(dataObject, true, selectedObjects)
        }
    }
}

// MARK:- Public
extension RSSelectionMenuDelegate {
    
}

// MARK:- UITableViewDelegate
extension RSSelectionMenuDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectionType == .single {
            handleActionForSingleSelectionAt(indexPath: indexPath, tableView: tableView)
        }
    }
}
