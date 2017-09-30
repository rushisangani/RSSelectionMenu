//
//  RSSelectionMenuExtensions.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SelectionType
enum SelectionType {
    
    case single        // default
    case multiple
}

// MARK: - PresentationStyle
enum PresentationStyle {
    
    case `default`
    case popOver
    case dropDown
}

// MARK: - CellType
enum CellType: String {
    
    case basic          // default
    case rightDetail
    case subTitle
    case custom
}

/************************************/

//MARK: - UIStoryBoard
extension UIStoryboard {
    
    class func instantiateRSSelectionMenu() -> RSSelectionMenu {
        return UIStoryboard(name: String(describing: RSSelectionMenu.self), bundle: Bundle.main).instantiateInitialViewController() as! RSSelectionMenu
    }
}

//MARK: - UITableViewCell
extension UITableViewCell {
    
    func setSelected(_ value: Bool) {
        self.accessoryType = value ? .checkmark : .none
        self.setAssociated(object: value)
    }
}
