//
//  Enums.swift
//  RSSelectionMenu
//
//  Copyright (c) 2019 Rushi Sangani
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

/// SelectionStyle
public enum SelectionStyle {
    
    case single        // default
    case multiple
}


/// PresentationStyle
public enum PresentationStyle {
    
    case present       // default
    case push
    case formSheet(size: CGSize?)
	case popover(sourceView: UIView, size: CGSize?, arrowDirection: UIPopoverArrowDirection = .any, hideNavBar: Bool = false)
    case alert(title: String?, action: String?, height: Double?)
    case actionSheet(title: String?, action: String?, height: Double?)
    case bottomSheet(barButton: UIBarButtonItem, height: Double?)
}


/// CellType
public enum CellType {
    
    case basic          // default
    case rightDetail
    case subTitle
    case customNib(nibName: String, cellIdentifier: String)
    case customClass(type: AnyClass, cellIdentifier: String)
    
    /// Get Value
    func value() -> String {
        switch self {
        case .basic:
            return "basic"
        case .rightDetail:
            return "rightDetail"
        case .subTitle:
            return "subTitle"
        default:
            return "basic"
        }
    }
}


/// Cell Selection Style
public enum CellSelectionStyle {
    
    case tickmark
    case checkbox
}


/// FirstRowType
public enum FirstRowType {
    
    case empty
    case none
    case all
    case custom(value: String)
    
    // display value
    var value: String {
        switch self {
        case .empty:
            return ""
        case .none:
            return "None"
        case .all:
            return "All"
        case .custom(let value):
            return value
        }
    }
}
