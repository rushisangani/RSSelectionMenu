//
//  RSSelectionMenuSearchDelegate.swift
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

import UIKit

/// RSSelectionMenuSearchDelegate
open class RSSelectionMenuSearchDelegate: NSObject {
    
    // MARK: - Properties
    public var searchBar: UISearchBar?
    
    /// to execute on search event
    public var didSearch: ((String) -> ())?
    
    /// cancel button
    public var cancelButtonAttributes: SearchBarCancelButtonAttributes?
    
    // MARK: - Initialize
    init(tableView: UITableView, placeHolder: String, tintColor: UIColor) {
        super.init()
        
        searchBar = UISearchBar()
        searchBar?.delegate = self
        searchBar?.sizeToFit()
        searchBar?.barTintColor = tintColor
        searchBar?.placeholder = placeHolder
        
        // add as tableHeaderView
        tableView.tableHeaderView = searchBar
    }
    
    func searchForText(text: String?) {
        if let search = didSearch {
            search(text ?? "")
        }
    }
    
    // cancel button
    func setCancelButtonAttributes(attributes: SearchBarCancelButtonAttributes) {
        guard let firstSubView = searchBar?.subviews.first else { return }
        for view in firstSubView.subviews {
            if let cancelButton = view as? UIButton {
                cancelButton.setTitle(attributes.title, for: .normal)
                if let color = attributes.tintColor {
                    cancelButton.tintColor = color
                }
            }
        }
    }
}

// MARK:- UISearchBarDelegate
extension RSSelectionMenuSearchDelegate : UISearchBarDelegate {
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        guard let attributes = cancelButtonAttributes else { return }
        setCancelButtonAttributes(attributes: attributes)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchBar.text = ""
        searchForText(text: "")
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForText(text: searchText)
    }
}
