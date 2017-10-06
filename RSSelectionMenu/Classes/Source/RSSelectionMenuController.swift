//
//  RSSelectionMenuController.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

/// RSSelectionMenuController
class RSSelectionMenu: UIViewController {

    // MARK: - Outlets
    var tableView: RSSelectionTableView?
    
    // MARK: - Properties
    fileprivate var parentController: UIViewController?
    
    /// controller should dissmiss on selection - default is true for single selection
    var shouldDismissOnSelect: Bool = true
    
    // MARK: - Life Cycle
    
    convenience init(dataSource: DataSource, uniqueKey: String? = "", cellType: CellType? = .basic, configuration: @escaping UITableViewCellConfiguration) {
        self.init(selectionType: .single, dataSource: dataSource, uniqueKey: uniqueKey!, cellType: cellType!, configuration: configuration)
    }
    
    convenience init(selectionType: SelectionType, dataSource: DataSource, uniqueKey: String? = "", cellType: CellType? = .basic, configuration: @escaping UITableViewCellConfiguration) {
        self.init()
        
        // data source
        let selectionDataSource = RSSelectionMenuDataSource(dataSource: dataSource, forCellType: cellType!, configuration: configuration)
        
        // initilize tableview
        self.tableView = RSSelectionTableView(selectionType: selectionType, dataSource: selectionDataSource, delegate: RSSelectionMenuDelegate(), uniqueKey: uniqueKey!, from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView?.frame = self.view.frame
    }
}

// MARK:- Public
extension RSSelectionMenu {
    
    /// custom cell
    func registerNib(nibName:String, forCellReuseIdentifier: String) {
        self.tableView?.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: forCellReuseIdentifier)
        self.tableView?.selectionDataSource?.setCellType(type: .custom, withReuseIdentifier: forCellReuseIdentifier)
    }
    
    /// Selection event
    func didSelectRow(dismissOnSelect: Bool? = true, delegate: @escaping UITableViewCellSelection)  {
        self.shouldDismissOnSelect = (tableView?.selectionType == .single) ? dismissOnSelect! : false
        self.tableView?.setOnDidSelect(delegate: delegate)
    }
    
    /// Searchbar
    func addSearchBar(withCompletion: @escaping UISearchBarResult) {
        self.tableView?.addSearchBar(withCompletion: withCompletion)
    }
    
    /// Show
    func show(with: PresentationStyle? = .present, from: UIViewController) {
        parentController = from
        show(with: with!, from: from, source: nil, size: nil)
    }
    
    /// show as popover
    func showAsPopover(from: UIView, inViewController: UIViewController, with contentSize: CGSize? = nil) {
        parentController = inViewController
        show(with: .popover, from: inViewController, source: from, size: contentSize)
    }
    
    /// dismiss
    func dismiss(animated: Bool? = true) {
        
        // dismiss searchcontroller
        if let searchController = tableView?.searchControllerDelegate?.searchController {
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
            self.navigationController?.pushViewController(self, animated: true)
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return !showDoneButton()
    }
}

