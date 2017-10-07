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
    case formSheet
}

// MARK: - CellType
public enum CellType: String {
    
    case basic          // default
    case rightDetail
    case subTitle
    case custom
}

/************************************/

//MARK: - UITableViewCell
extension UITableViewCell {
    
    func showSelected(_ value: Bool) {
        self.accessoryType = value ? .checkmark : .none
    }
}

// MARK: - NavigationBar
public struct NavigationBarTheme {
    
    var title: String?
    var attributes: [String: Any]?
    var color: UIColor?
}

//MARK: - RSSelectionMenu
extension RSSelectionMenu {
    
    // returns unique key
    public func uniqueKeyId() -> String {
        return self.associatedObject() as? String ?? ""
    }
    
    // check if object is inside the datasource
    public func containsObject<T>(_ object: T, inDataSource: DataSource<T>) -> Bool {
        return (isSelected(object: object, from: inDataSource) != nil)
    }
    
    // check if object is selected
    public func isSelected<T>(object: T, from: DataSource<T>) -> Int? {
        
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
            return hasSameKeyValue(forObject: (object as! Dictionary), inArray: from)
        }
    
        // custom type
        else {
            
            let classType = T.self as! NSObject.Type
            let dictionary = (object as! NSObject).toDictionary(from: classType)
            return hasSameKeyValue(forObject: dictionary, inArray: from)
        }
    }
    
    /// dictionary key value comparision
    public func hasSameKeyValue<T>(forObject: [String: AnyObject], inArray: DataSource<T>) -> Int? {
        let key = uniqueKeyId()
        let classType = T.self as! NSObject.Type
        
        let value = String(describing: forObject[key]!)
        
        return inArray.index(where: { (data) -> Bool in
            let dictionary = (data as! NSObject).toDictionary(from: classType)
            return value == String(describing: dictionary[key]!)
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
