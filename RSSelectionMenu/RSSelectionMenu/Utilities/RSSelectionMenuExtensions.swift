//
//  RSSelectionMenuExtensions.swift
//
//  Copyright (c) 2018 Rushi Sangani
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
    
    case Single        // default
    case Multiple
}

// MARK: - PresentationStyle
public enum PresentationStyle {
    
    case Present       // default
    case Push
    case Popover(sourceView: UIView, size: CGSize?)
    case Formsheet
    case Alert(title: String?, action: String?, height: Double?)
    case Actionsheet(title: String?, action: String?, height: Double?)
}

// MARK: - CellType
public enum CellType {
    
    case Basic          // default
    case RightDetail
    case SubTitle
    case Custom(nibName: String, cellIdentifier: String)
    
    func value() -> String {
        switch self {
        case .Basic:
            return "basic"
        case .RightDetail:
            return "rightDetail"
        case .SubTitle:
            return "subTitle"
        default:
            return "basic"
        }
    }
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
    var attributes: [NSAttributedString.Key: Any]?
    var color: UIColor?
    var tintColor: UIColor?
}

//MARK: - RSSelectionMenu
public protocol UniqueProperty {
    func uniquePropertyName() -> String
}

extension RSSelectionMenu {
    
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
            guard let key = uniquePropertyName else {
                fatalError("unique key is required to identify each dictionary uniquely.")
            }
            return hasSameValue(forKey: key, object: (object as! Dictionary), inArray: from)
        }
    
        // custom type
        else {
            
            if (uniquePropertyName == nil) && !(T.self is UniqueProperty.Type) {
                fatalError("NSObject subclass must implement UniqueProperty protocol or specify an uniquePropertyName to identify each object uniquely.")
            }
            
            let key = (T.self is UniqueProperty.Type) ? (object as! UniqueProperty).uniquePropertyName() : uniquePropertyName!
            let dictionary: [String: Any] = (object is Decodable) ? (object as! Decodable).toDictionary() : (object as! NSObject).toDictionary()

            return hasSameValue(forKey: key, object: dictionary, inArray: from)
        }
    }
    
    /// dictionary key value comparision
    public func hasSameValue<T>(forKey key: String, object: [String: Any], inArray: DataSource<T>) -> Int? {
        let value = String(describing: object[key])
        
        return inArray.index(where: { (data) -> Bool in
            let dictionary = (data is Decodable) ? (data as! Decodable).toDictionary() : (data as! NSObject).toDictionary()
            return value == String(describing: dictionary[key])
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
