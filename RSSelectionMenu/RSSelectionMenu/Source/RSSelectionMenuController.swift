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
open class RSSelectionMenu<T>: UIViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {

    // MARK: - Outlets
    public var tableView: RSSelectionTableView<T>?
    
    // MARK: - Properties
    
    /// property name or unique key is required when using custom models array or dictionary array as datasource
    public var uniquePropertyName: String?
    
    /// Barbuttons titles
    public var leftBarButtonTitle: String?
    public var rightBarButtonTitle: String?
    
    /// Searchbar cancel button
    public var searchBarCancelButtonAttributes: SearchBarCancelButtonAttributes? = nil {
        didSet {
            self.tableView?.searchControllerDelegate?.cancelButtonAttributes = searchBarCancelButtonAttributes
        }
    }
    
    /// store reference view controller
    fileprivate weak var parentController: UIViewController?
    
    /// presentation stype
    fileprivate var menuPresentationStyle: PresentationStyle = .Present
    
    /// navigationbar theme
    fileprivate var navigationBarTheme: NavigationBarTheme?
    
    /// backgroundView
    fileprivate var backgroundView = UIView()
    
    // MARK: - Life Cycle
    
    convenience public init(dataSource: DataSource<T>, cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {
        self.init(selectionType: .Single, dataSource: dataSource, cellConfiguration: configuration)
    }
    
    convenience public init(selectionType: SelectionType, dataSource: DataSource<T>, cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {
        self.init(selectionType: selectionType, dataSource: dataSource, cellType: .Basic, cellConfiguration: configuration)
    }
    
    convenience public init(selectionType: SelectionType, dataSource: DataSource<T>, cellType: CellType, cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {
        self.init()
        
        // data source
        let selectionDataSource = RSSelectionMenuDataSource<T>(dataSource: dataSource, forCellType: cellType, cellConfiguration: configuration)
        
        // delegate
        let selectionDelegate = RSSelectionMenuDelegate<T>(selectedItems: [])
     
        // initilize tableview
        self.tableView = RSSelectionTableView<T>(selectionType: selectionType, cellType: cellType, dataSource: selectionDataSource, delegate: selectionDelegate, from: self)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    // MARK: - Setup Views
    fileprivate func setupViews() {
        backgroundView.backgroundColor = UIColor.clear
        
        if case .Formsheet = menuPresentationStyle {
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            addTapGesture()
        }
        
        backgroundView.addSubview(tableView!)
        view.addSubview(backgroundView)
        
        // done button
        if showDoneButton() {
            setDoneButton()
        }
        
        // cancel button
        if showCancelButton() {
            setCancelButton()
        }
    }
    
    // MARK: - Setup Layout
    
    fileprivate func setupLayout() {
        self.view.frame = (parentController?.view.frame)!
        
        // navigation bar theme
        if let theme = navigationBarTheme {
            setNavigationBarTheme(theme)
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        setTableViewFrame()
    }
    
    /// tableView frame
    fileprivate func setTableViewFrame() {
        
        let window =  UIApplication.shared.delegate?.window
        
        // change border style for formsheet
        if case .Formsheet = menuPresentationStyle {
            
            tableView?.layer.cornerRadius = 9
            self.backgroundView.frame = (window??.frame)!
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.tableView?.frame.size = CGSize(width: backgroundView.frame.size.width - 80, height: backgroundView.frame.size.height - 260)
            }else {
                self.tableView?.frame.size = CGSize(width: backgroundView.frame.size.width - 300, height: backgroundView.frame.size.height - 400)
            }
            self.tableView?.center = self.backgroundView.center
            
        }else {
            self.backgroundView.frame = self.view.frame
            self.tableView?.frame = backgroundView.frame
        }
    }
    
    /// Tap gesture
    fileprivate func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc func onBackgroundTapped(sender: UITapGestureRecognizer){
        self.dismiss()
    }
    
    /// Done button
    func setDoneButton() {
        let doneTitle = (self.rightBarButtonTitle != nil) ? self.rightBarButtonTitle! : doneButtonTitle
        let doneButton = UIBarButtonItem(title: doneTitle, style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneButtonTapped() {
        self.dismiss()
    }
    
    /// cancel button
    fileprivate func setCancelButton() {
        let cancelTitle = (self.leftBarButtonTitle != nil) ? self.leftBarButtonTitle! : cancelButtonTitle
        let cancelButton = UIBarButtonItem(title: cancelTitle, style: .plain, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return !showDoneButton()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: tableView!))! { return false }
        return true
    }
    
}

// MARK:- Public
extension RSSelectionMenu {
    
    /// Set selected items and selection event
    public func setSelectedItems(items: DataSource<T>, onDidSelectRow delegate: @escaping UITableViewCellSelection<T>) {
        self.tableView?.setSelectedItems(items: items, onDidSelectRow: delegate)
    }
    
    /// First row type and selection
    public func addFirstRowAs(rowType: FirstRowType, showSelected: Bool, onDidSelectFirstRow completion: @escaping FirstRowSelection) {
        self.tableView?.addFirstRowAs(rowType: rowType, showSelected: showSelected, onDidSelectFirstRow: completion)
    }
    
    /// Searchbar
    public func showSearchBar(onTextDidSearch completion: @escaping UISearchBarResult<T>) {
        self.showSearchBar(withPlaceHolder: defaultPlaceHolder, tintColor: defaultSearchBarTintColor, onTextDidSearch: completion)
    }
    
    public func showSearchBar(withPlaceHolder: String, tintColor: UIColor, onTextDidSearch completion: @escaping UISearchBarResult<T>) {
        self.tableView?.addSearchBar(placeHolder: withPlaceHolder, tintColor: tintColor, completion: completion)
    }
    
    /// Navigationbar title and color
    public func setNavigationBar(title: String, attributes:[NSAttributedStringKey: Any]? = nil, barTintColor: UIColor? = nil) {
        self.navigationBarTheme = NavigationBarTheme(title: title, attributes: attributes, color: barTintColor)
    }
    
    /// Show
    public func show(from: UIViewController) {
        self.show(style: .Present, from: from)
    }
    
    public func show(style: PresentationStyle, from: UIViewController) {
        self.showMenu(with: style, from: from)
    }
    
    /// dismiss
    public func dismiss(animated: Bool? = true) {
        
        DispatchQueue.main.async {
            
            // dismiss search
            if let searchBar = self.tableView?.searchControllerDelegate?.searchBar {
                if searchBar.isFirstResponder { searchBar.resignFirstResponder() }
            }
            
            if case .Push = self.menuPresentationStyle {
                 self.navigationController?.popViewController(animated: animated!)
            }
            else {
               self.dismiss(animated: animated!, completion: nil)
            }
        }
    }
}

//MARK:- Private
extension RSSelectionMenu {

    // check if show done button
    fileprivate func showDoneButton() -> Bool {
        switch menuPresentationStyle {
        case .Present, .Push:
            return tableView?.selectionType == .Multiple
        default:
            return false
        }
    }
    
    // check if show cancel button
    fileprivate func showCancelButton() -> Bool {
        if case .Present = menuPresentationStyle {
            return tableView?.selectionType == .Single
        }
        return false
    }
    
    // show
    fileprivate func showMenu(with: PresentationStyle, from: UIViewController) {
        parentController = from
        menuPresentationStyle = with
        
        if case .Push = with {
            from.navigationController?.pushViewController(self, animated: true)
            return
        }
        
        var tobePresentController: UIViewController = self
        if case .Present = with {
            tobePresentController = UINavigationController(rootViewController: self)
        }
        else if case let .Popover(sourceView, size) = with {
            tobePresentController.modalPresentationStyle = .popover
            if size != nil { tobePresentController.preferredContentSize = size! }
            
            let popover = tobePresentController.popoverPresentationController!
            popover.delegate = self
            popover.permittedArrowDirections = .any
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
        }
        else if case .Formsheet = with {
            tobePresentController.modalPresentationStyle = .overCurrentContext
            tobePresentController.modalTransitionStyle = .crossDissolve
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
