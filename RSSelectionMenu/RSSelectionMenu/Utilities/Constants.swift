//
//  Constants.swift
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

/// UITableViewCellConfiguration
public typealias UITableViewCellConfiguration<T> = ((_ cell: UITableViewCell, _ dataObject: T, _ indexPath: IndexPath) -> ())

/// DataSource
public typealias DataSource<T> = [T]

/// UITableViewCellSelection
public typealias UITableViewCellSelection<T> = ((_ object: T?, _ isSelected: Bool, _ selectedArray: DataSource<T>) -> ())

/// FirstRowSelection
public typealias FirstRowSelection = ((_ object: String, _ isSelected: Bool) -> ())


/// FilteredDataSource
public typealias FilteredDataSource<T> = [T]

/// UISearchBarResult
public typealias UISearchBarResult<T> = ((_ searchText: String) -> (FilteredDataSource<T>))

/// SearchBar CancelButton
public typealias SearchBarCancelButtonAttributes = (title: String, tintColor: UIColor?)

/// Keys
public let contentViewController       = "contentViewController"

/// Strings
public let defaultPlaceHolder          = "Search"
public let cancelButtonTitle           = "Cancel"
public let doneButtonTitle             = "Done"

/// Colors
public let defaultSearchBarTintColor   = UIColor(white: 0.9, alpha: 0.9)

/// Constants
public let defaultHeaderHeight         = CGFloat(50)
