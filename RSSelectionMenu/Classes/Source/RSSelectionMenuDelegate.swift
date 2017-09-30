//
//  RSSelectionMenuDelegate.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

/// UITableViewCellSelection
typealias UITableViewCellSelection = ((_ cell: UITableViewCell, _ isSelected: Bool, _ indexPath: IndexPath) -> ())

class RSSelectionMenuDelegate: NSObject {

    // MARK: - Properties
    
    /// tableview cell selection delegate
    fileprivate let selectionDelegate: UITableViewCellSelection?
    
    // MARK: - Initialize
    init(delegate: @escaping UITableViewCellSelection) {
        self.selectionDelegate = delegate
    }
}

// MARK:- Private
extension RSSelectionMenuDelegate {
    
    /// did select row at indexpath
    fileprivate func tableView(tableView: UITableView, didSelect row: IndexPath) {
        
        // cell
        let cell = tableView.cellForRow(at: row)
        
        // update row
        let isSelected = cell?.associatedObject() as? Bool ?? false
        cell?.setSelected(!isSelected)
        
        // selection callback
        if let delegate = selectionDelegate {
            delegate(cell!, !isSelected, row)
        }
    }
}

// MARK:- UITableViewDelegate
extension RSSelectionMenuDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView(tableView: tableView, didSelect: indexPath)
    }
}
