//
//  Constants.swift
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


/************ Constants ************/


/// Keys
public let contentViewController       = "contentViewController"

/// Strings
public let defaultPlaceHolder          = "Search"
public let cancelButtonTitle           = "Cancel"
public let doneButtonTitle             = "Done"
public let defaultEmptyDataString      = "No data found"

/// Colors
public let defaultSearchBarTintColor   = UIColor(white: 0.9, alpha: 0.9)

/// Constants
public let defaultHeaderHeight         = CGFloat(50)



/************ typealias ************/



/// UITableViewCellConfiguration
public typealias UITableViewCellConfiguration<T: Equatable> = ((_ cell: UITableViewCell, _ item: T, _ indexPath: IndexPath) -> ())


/// DataSource
public typealias DataSource<T: Equatable> = [T]


/// FilteredDataSource
public typealias FilteredDataSource<T: Equatable> = [T]


/// UITableViewCellSelection
public typealias UITableViewCellSelection<T: Equatable> = ((_ item: T?, _ index: Int, _ selected: Bool, _ selectedItems: DataSource<T>) -> ())


/// UISearchBarResult
public typealias UISearchBarResult<T: Equatable> = ((_ searchText: String) -> (FilteredDataSource<T>))


/// FirstRowSelection
public typealias FirstRowSelection = ((_ value: String, _ selected: Bool) -> ())
