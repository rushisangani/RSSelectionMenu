//
//  BarButtonHandler.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 22/12/19.
//  Copyright © 2019 Rushi Sangani. All rights reserved.
//

import Foundation
import UIKit
import RSSelectionMenu

// MARK: - UIBarButtonHandler

extension ViewController {

    func showBottomSheet(fromBarButton barButton: UIBarButtonItem) {
        
        /// Register custom cell class
        let identifier = "IconTitleTableViewCell"
        
        let menu = RSSelectionMenu(
            selectionStyle: .single,
            dataSource: bottomSheetActions,
            cellType: .customClass(type: IconTitleTableViewCell.self, cellIdentifier: identifier)) { (cell, action, indexPath) in
            
            // cell setup
            let iconTitleCell = cell as! IconTitleTableViewCell
            iconTitleCell.setImage(action.image, title: action.title)
            
            if action.title == "Cancel" {
                iconTitleCell.titleLabel.textColor = UIColor.blue
                iconTitleCell.titleLabel.textAlignment = .center
            }

            iconTitleCell.tintColor = .clear
                
            // Note:
            // Can also customise cell backgroundColor, titleColor, iconColor based on the theme
        }
        
        // on selection
        menu.onDismiss = { items in
            guard let selectedTitle = items.first?.title else { return }  // since there is single selection
            switch selectedTitle {
            case "Camera":
                print("Open Camera")
            case "Photo Library":
                print("Open Photo Library")
            case "Attachment":
                print("Open Files")
            default:
                break
            }
        }
        
        // customization
        menu.tableView?.rowHeight = 50
        menu.tableView?.isScrollEnabled = false
        
        // height
        let height = Double(bottomSheetActions.count * 50)
        menu.show(style: .bottomSheet(barButton: barButton, height: height), from: self)
    }
    
}
