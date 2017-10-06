//
//  RSSelectionMenuExtensions.swift
//
//  Copyright (c) 2017 Rushi Sangani
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

// MARK: - SelectionType
public enum SelectionType {
    
    case single        // default
    case multiple
}

// MARK: - PresentationStyle
public enum PresentationStyle {
    
    case present       // default
    case push
    case popover
}

// MARK: - CellType
public enum CellType: String {
    
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

//MARK: - RSSelectionMenu
extension RSSelectionMenu {
    
    // check if object is inside the datasource
    class func containsObject(_ object: AnyObject, inDataSource: DataSource) -> Bool {
        return (isSelected(object: object, from: inDataSource) != nil)
    }
    
    // check if object is selected
    class func isSelected(object: AnyObject, from: DataSource) -> Int? {
        
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
    class func hasSameKeyValue(forObject: [String: AnyObject], inArray: [[String: AnyObject]]) -> Int? {
        let value = forObject[RSSelectionMenu.uniqueKey] as? String ?? ""
        
        return inArray.index(where: { (data) -> Bool in
            return value == data[RSSelectionMenu.uniqueKey] as? String
        })
    }
}

//MARK: - UIViewController
extension UIViewController {
    
    open func isPresented() -> Bool {
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
