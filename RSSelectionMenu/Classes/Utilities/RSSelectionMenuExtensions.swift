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
    
    case present       // default
    case push
    case popover
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
    }
}

//MARK: - RSSelectionTableView
extension RSSelectionTableView {
    
    // check if object is selected
    func isSelected(object: AnyObject, from: DataSource) -> Int? {
        
        // object type is string
        if object is NSString {
            let hashValue = (object as! NSString).hashValue
        
            return from.index(where: { (data) -> Bool in
                return hashValue == (data as! NSString).hashValue
            })
        }
            
        // number type objects
        else if object is NSNumber {
            let hashValue = (object as! NSNumber).hashValue
            
            return from.index(where: { (data) -> Bool in
                return hashValue == (data as! NSNumber).hashValue
            })
        }
        
        // dictionary type
        else if object is NSDictionary {
            return hasSameKeyValue(forObject: (object as! Dictionary), inArray: from as! [[String : AnyObject]])
        }
    
        // custom type
        else {
            let dictionary = (object as! NSObject).toDictionary()
            return hasSameKeyValue(forObject: dictionary as [String : AnyObject], inArray: from as! [[String : AnyObject]])
        }
    }
    
    /// dictionary key value comparision
    func hasSameKeyValue(forObject: [String: AnyObject], inArray: [[String: AnyObject]]) -> Int? {
        let value = forObject[uniqueKey] as? String ?? ""
        
        return inArray.index(where: { (data) -> Bool in
            return value == data[uniqueKey] as? String
        })
    }
}

//MARK: - UIViewController
extension UIViewController {
    
    func isPresented() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
}
