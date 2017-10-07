//
//  RSSelectionMenuController.swift
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

/// RSSelectionMenuController
open class RSSelectionMenu<T>: UIViewController, UIPopoverPresentationControllerDelegate {

    // MARK: - Outlets
    public var tableView: RSSelectionTableView<T>?
    
    // MARK: - Properties
    var parentController: UIViewController?
    
    /// controller should dissmiss on selection - default is true for single selection
    public var shouldDismissOnSelect: Bool = true
    
    /// navigationbar theme
    fileprivate var navigationBarTheme: NavigationBarTheme?
    
    // MARK: - Life Cycle
    
    convenience public init(dataSource: DataSource<T>, selectedItems: DataSource<T>, uniqueKey: String? = "", cellType: CellType? = .basic, configuration: @escaping UITableViewCellConfiguration<T>) {
        self.init(selectionType: .single, dataSource: dataSource, selectedItems: selectedItems, uniqueKey: uniqueKey!, cellType: cellType!, configuration: configuration)
    }
    
    convenience public init(selectionType: SelectionType, dataSource: DataSource<T>, selectedItems: DataSource<T>, uniqueKey: String? = "", cellType: CellType? = .basic, configuration: @escaping UITableViewCellConfiguration<T>) {
        self.init()
        
        // data source
        let selectionDataSource = RSSelectionMenuDataSource<T>(dataSource: dataSource, forCellType: cellType!, configuration: configuration)
        
        // delegate
        let selectionDelegate = RSSelectionMenuDelegate<T>(selectedItems: selectedItems)
        
        // initilize tableview
        self.tableView = RSSelectionTableView<T>(selectionType: selectionType, dataSource: selectionDataSource, delegate: selectionDelegate, from: self)
        
        // key
        self.setAssociated(object: uniqueKey!)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    // MARK: - Setup Layout
    
    fileprivate func setupLayout() {
        self.view.frame = (parentController?.view.frame)!
        self.view.addSubview(tableView!)
        
        // navigation bar theme
        if let theme = navigationBarTheme {
            setNavigationBarTheme(theme)
        }
        
        // done button
        if showDoneButton() {
            setDoneButton()
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView?.frame = self.view.frame
    }
    
    /// Done button
    fileprivate func setDoneButton() {
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneButtonTapped() {
        self.dismiss()
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return !showDoneButton()
    }
}

// MARK:- Public
extension RSSelectionMenu {
    
    /// custom cell
    public func registerNib(nibName:String, forCellReuseIdentifier: String) {
        self.tableView?.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: forCellReuseIdentifier)
        self.tableView?.selectionDataSource?.setCellType(type: .custom, withReuseIdentifier: forCellReuseIdentifier)
    }
    
    /// Selection event
    public func didSelectRow(dismissOnSelect: Bool? = true, delegate: @escaping UITableViewCellSelection<T>)  {
        self.shouldDismissOnSelect = (tableView?.selectionType == .single) ? dismissOnSelect! : false
        self.tableView?.setOnDidSelect(delegate: delegate)
    }
    
    /// First row type and selection
    public func showFirstRowAs(type: FirstRowType, selected: Bool, completion: @escaping FirstRowSelection) {
        self.tableView?.showFirstRowAs(type: type, selected: selected, completion: completion)
    }
    
    /// Searchbar
    public func addSearchBar(placeHolder: String? = defaultPlaceHolder, tintColor: UIColor? = defaultSearchBarTintColor, completion: @escaping UISearchBarResult<T>) {
        self.tableView?.addSearchBar(placeHolder: placeHolder!, tintColor: tintColor!, completion: completion)
    }
    
    /// Navigationbar title and color
    public func setNavigationBar(title: String, attributes:[String: Any]? = nil, barTintColor: UIColor? = nil) {
        self.navigationBarTheme = NavigationBarTheme(title: title, attributes: attributes, color: barTintColor)
    }
    
    /// Show
    public func show(with: PresentationStyle? = .present, from: UIViewController) {
        parentController = from
        show(with: with!, from: from, source: nil, size: nil)
    }
    
    /// show as popover
    public func showAsPopover(from: UIView, inViewController: UIViewController, with contentSize: CGSize? = nil) {
        parentController = inViewController
        show(with: .popover, from: inViewController, source: from, size: contentSize)
    }
    
    /// dismiss
    public func dismiss(animated: Bool? = true) {
        
        DispatchQueue.main.async {
            
            // dismiss searchcontroller
            if let searchController = self.tableView?.searchControllerDelegate?.searchController {
                if searchController.isActive { searchController.dismiss(animated: false, completion: nil) }
            }
            
            if self.isPresented() {
                self.dismiss(animated: animated!, completion: nil)
            }
            else {
                self.navigationController?.popViewController(animated: animated!)
            }
        }
    }
}

//MARK:- Private
extension RSSelectionMenu {

    // check if show done button
    fileprivate func showDoneButton() -> Bool {
        return !shouldDismissOnSelect || tableView?.selectionType == .multiple
    }
    
    // show
    fileprivate func show(with: PresentationStyle, from: UIViewController, source: UIView?, size: CGSize?) {
        
        if with == .push {
            from.navigationController?.pushViewController(self, animated: true)
            return
        }
        
        var tobePresentController: UIViewController = self
        if with != .popover || tableView?.selectionType == .multiple {
            tobePresentController = UINavigationController(rootViewController: self)
        }
        
        if with == .popover {
            tobePresentController.modalPresentationStyle = .popover
            if size != nil { tobePresentController.preferredContentSize = size! }
            
            let popover = tobePresentController.popoverPresentationController!
            popover.delegate = self
            popover.permittedArrowDirections = .any
            popover.sourceView = source!
            popover.sourceRect = (source?.superview?.convert((source?.bounds)!, to: nil))!
        }
        
        from.present(tobePresentController, animated: true, completion: nil)
    }
    
    // navigation bar
    fileprivate func setNavigationBarTheme(_ theme: NavigationBarTheme) {
        if let navigationBar = self.navigationController?.navigationBar {
            
            navigationBar.barTintColor = theme.color
            if theme.color != nil {
                navigationBar.tintColor = UIColor.white
            }
            
            navigationItem.title = theme.title
            navigationBar.titleTextAttributes = theme.attributes
        }
    }
}
