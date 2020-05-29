//
//  RSSelectionMenuSearchDelegate.swift
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

import UIKit

/// RSSelectionMenuSearchDelegate
open class RSSelectionMenuSearchDelegate: NSObject {
    
    // MARK: - Properties
    public var searchBar: UISearchBar?
    
    /// to execute on search event
    public var didSearch: ((String) -> ())?
    
    // MARK: - Initialize
    init(placeHolder: String, barTintColor: UIColor) {
        super.init()
        
        searchBar = UISearchBar()
        searchBar?.placeholder = placeHolder
        searchBar?.barTintColor = barTintColor
        searchBar?.sizeToFit()
        searchBar?.delegate = self
        searchBar?.enablesReturnKeyAutomatically = false
    }
    
    /// Search for the text
    func searchForText(text: String?) {
        guard let searchHandler = didSearch else {
            return
        }
        searchHandler(text ?? "")
    }
}

// MARK:- UISearchBarDelegate
extension RSSelectionMenuSearchDelegate : UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForText(text: searchText)
    }
}
