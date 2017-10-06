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
open class RSSelectionMenu: UIViewController {

    // MARK: - Outlets
    public var tableView: RSSelectionTableView?
    
    // MARK: - Properties
    var parentController: UIViewController?
    
    /// unique key for comparision when datasource is other than String or Int array
    public static var uniqueKey: String = ""
    
    /// controller should dissmiss on selection - default is true for single selection
    public var shouldDismissOnSelect: Bool = true
    
    // MARK: - Life Cycle
    
    convenience public init(dataSource: DataSource, selectedItems: DataSource, uniqueKey: String? = "", cellType: CellType? = .basic, configuration: @escaping UITableViewCellConfiguration) {
        self.init(selectionType: .single, dataSource: dataSource, selectedItems: selectedItems, uniqueKey: uniqueKey!, cellType: cellType!, configuration: configuration)
    }
    
    convenience public init(selectionType: SelectionType, dataSource: DataSource, selectedItems: DataSource, uniqueKey: String? = "", cellType: CellType? = .basic, configuration: @escaping UITableViewCellConfiguration) {
        self.init()
        
        // data source
        let selectionDataSource = RSSelectionMenuDataSource(dataSource: dataSource, forCellType: cellType!, configuration: configuration)
        
        // delegate
        let selectionDelegate = RSSelectionMenuDelegate(selectedItems: selectedItems)
        
        // key
        RSSelectionMenu.uniqueKey = uniqueKey!
        
        // initilize tableview
        self.tableView = RSSelectionTableView(selectionType: selectionType, dataSource: selectionDataSource, delegate: selectionDelegate, from: self)
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
        
        if showDoneButton() {
            setDoneButton()
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView?.frame = self.view.frame
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
    public func didSelectRow(dismissOnSelect: Bool? = true, delegate: @escaping UITableViewCellSelection)  {
        self.shouldDismissOnSelect = (tableView?.selectionType == .single) ? dismissOnSelect! : false
        self.tableView?.setOnDidSelect(delegate: delegate)
    }
    
    /// Searchbar
    public func addSearchBar(withCompletion: @escaping UISearchBarResult) {
        self.tableView?.addSearchBar(withCompletion: withCompletion)
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
    
    /// Done button
    fileprivate func setDoneButton() {
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneButtonTapped() {
        self.dismiss()
    }
    
    // show
    fileprivate func show(with: PresentationStyle, from: UIViewController, source: UIView?, size: CGSize?) {
        
        if with == .push {
            from.navigationController?.pushViewController(self, animated: true)
            return
        }
        
        var tobePresentController: UIViewController = self
        if !shouldDismissOnSelect {
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
}

// MARK: - UIPopoverPresentationControllerDelegate
extension RSSelectionMenu : UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return !showDoneButton()
    }
}

