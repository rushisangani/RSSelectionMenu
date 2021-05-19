//
//  RSSelectionMenuController.swift
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

/// RSSelectionMenuController
open class RSSelectionMenu<T: Equatable>: UIViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {

    // MARK: - Views
    public var tableView: RSSelectionTableView<T>?
    
    /// SearchBar
    public var searchBar: UISearchBar? {
        return tableView?.searchControllerDelegate?.searchBar
    }
    
    /// NavigationBar
    public var navigationBar: UINavigationBar? {
        return self.navigationController?.navigationBar
    }
    
    // MARK: - Properties
    
    /// dismiss: for Single selection only
    public var dismissAutomatically: Bool = true
    
    /// Barbuttons titles
    public var leftBarButtonTitle: String?
    public var rightBarButtonTitle: String?
    
    /// cell selection style
    public var cellSelectionStyle: CellSelectionStyle = .tickmark {
        didSet {
            self.tableView?.setCellSelectionStyle(cellSelectionStyle)
        }
    }
    
    /// maximum selection limit
    public var maxSelectionLimit: UInt? = nil {
        didSet {
            self.tableView?.selectionDelegate?.maxSelectedLimit = maxSelectionLimit
        }
    }
    
    /// Selection menu willAppear handler
    public var onWillAppear:(() -> ())?
    
    /// Selection menu dismissal handler
    public var onDismiss:((_ selectedItems: DataSource<T>) -> ())?
    
    /// RightBarButton Tap handler - Only for Multiple Selection & Push, Present - Styles
    /// Note: This is override the default dismiss behaviour of the menu.
    /// onDismiss will not be called if this is implemeted. (dismiss manually in this completion block)
    public var onRightBarButtonTapped:((_ selectedItems: DataSource<T>) -> ())?
    
    // MARK: - Private
    
    /// store reference view controller
    fileprivate weak var parentController: UIViewController?
    
    /// presentation style
    fileprivate var menuPresentationStyle: PresentationStyle = .present
    
    /// navigationbar theme
    fileprivate var navigationBarTheme: NavigationBarTheme?
    
    /// backgroundView
    fileprivate var backgroundView = UIView()
    
    
    // MARK: - Init
    
    convenience public init(
        dataSource: DataSource<T>,
        tableViewStyle: UITableView.Style = .plain,
        cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {
        
        self.init(
            selectionStyle: .single,
            dataSource: dataSource,
            tableViewStyle: tableViewStyle,
            cellConfiguration: configuration
        )
    }
    
    convenience public init(
        selectionStyle: SelectionStyle,
        dataSource: DataSource<T>,
        tableViewStyle: UITableView.Style = .plain,
        cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {
        
        self.init(
            selectionStyle: selectionStyle,
            dataSource: dataSource,
            tableViewStyle: tableViewStyle,
            cellType: .basic,
            cellConfiguration: configuration
        )
    }
    
    convenience public init(
        selectionStyle: SelectionStyle,
        dataSource: DataSource<T>,
        tableViewStyle: UITableView.Style = .plain,
        cellType: CellType,
        cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {
        
        self.init()
        
        // data source
        let selectionDataSource = RSSelectionMenuDataSource<T>(
            dataSource: dataSource,
            forCellType: cellType,
            cellConfiguration: configuration
        )
        
        // delegate
        let selectionDelegate = RSSelectionMenuDelegate<T>(selectedItems: [])
     
        // initilize tableview
        self.tableView = RSSelectionTableView<T>(
            selectionStyle: selectionStyle,
            tableViewStyle: tableViewStyle,
            cellType: cellType,
            dataSource: selectionDataSource,
            delegate: selectionDelegate,
            from: self
        )
    }
    
    // MARK: - Life Cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reload()
        if let handler = onWillAppear { handler() }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
        
        /// on dimiss not called in iPad for multi select popover
        if tableView?.selectionStyle == .multiple, popoverPresentationController != nil {
            self.menuWillDismiss()
        }
    }
    
    // MARK: - Setup Views
    fileprivate func setupViews() {
        backgroundView.backgroundColor = UIColor.clear
        
        if case .formSheet = menuPresentationStyle {
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            addTapGesture()
        }
        
        backgroundView.addSubview(tableView!)
        view.addSubview(backgroundView)
        
        // rightBarButton
        if showRightBarButton() {
            setRightBarButton()
        }
        
        // leftBarButton
        if showLeftBarButton() {
            setLeftBarButton()
        }
    }
    
    // MARK: - Setup Layout
    
    fileprivate func setupLayout() {
        if let frame = parentController?.view.bounds {
            self.view.frame = frame
        }
        
        // navigation bar theme
        setNavigationBarTheme()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        setTableViewFrame()
    }
    
    /// tableView frame
    fileprivate func setTableViewFrame() {
        
        let window =  UIApplication.shared.delegate?.window
        
        // change border style for formsheet
        if case let .formSheet(size) = menuPresentationStyle {
            
            tableView?.layer.cornerRadius = 8
            self.backgroundView.frame = (window??.bounds)!
            var tableViewSize = CGSize.zero
            
            // set size directly if provided
            if let size = size {
                tableViewSize = size
            }
            else {
                
                // set size according to device and orientation
                if UIDevice.current.userInterfaceIdiom == .phone {
                
                    if UIApplication.shared.statusBarOrientation == .portrait {
                        tableViewSize = CGSize(width: backgroundView.frame.size.width - 80, height: backgroundView.frame.size.height - 260)
                    }else {
                        tableViewSize = CGSize(width: backgroundView.frame.size.width - 200, height: backgroundView.frame.size.height - 100)
                    }
                }else {
                    tableViewSize = CGSize(width: backgroundView.frame.size.width - 300, height: backgroundView.frame.size.height - 400)
                }
            }
            
            self.tableView?.frame.size = tableViewSize
            self.tableView?.center = self.backgroundView.center
            
        }else {
            self.backgroundView.frame = self.view.bounds
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
    
    // MARK: - Bar Buttons
    
    /// left bar button
    fileprivate func setLeftBarButton() {
        let title = (self.leftBarButtonTitle != nil) ? self.leftBarButtonTitle! : cancelButtonTitle
        let leftBarButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    /// Right bar button
    fileprivate func setRightBarButton() {
        let title = (self.rightBarButtonTitle != nil) ? self.rightBarButtonTitle! : doneButtonTitle
        let rightBarButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func leftBarButtonTapped() {
        self.dismiss()
    }
    
    @objc func rightBarButtonTapped() {
        if let rightButtonHandler = onRightBarButtonTapped {
            rightButtonHandler(self.tableView?.selectionDelegate?.selectedItems ?? [])
            return
        }
        self.dismiss()
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
	let shouldDismiss = !showRightBarButton()
	if shouldDismiss {
	    self.menuWillDismiss()
	}
        return shouldDismiss
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
    public func setSelectedItems(items: DataSource<T>, maxSelected: UInt? = nil, onDidSelectRow delegate: @escaping UITableViewCellSelection<T>) {
        let maxLimit = maxSelected ?? maxSelectionLimit
        self.tableView?.setSelectedItems(items: items, maxSelected: maxLimit, onDidSelectRow: delegate)
    }
    
    /// First row type and selection
    public func addFirstRowAs(rowType: FirstRowType, showSelected: Bool, onDidSelectFirstRow completion: @escaping FirstRowSelection) {
        self.tableView?.addFirstRowAs(rowType: rowType, showSelected: showSelected, onDidSelectFirstRow: completion)
    }
    
    /// Searchbar
    public func showSearchBar(onTextDidSearch completion: @escaping UISearchBarResult<T>) {
        self.showSearchBar(withPlaceHolder: defaultPlaceHolder, barTintColor: defaultSearchBarTintColor, onTextDidSearch: completion)
    }
    
    public func showSearchBar(withPlaceHolder: String, barTintColor: UIColor, onTextDidSearch completion: @escaping UISearchBarResult<T>) {
        self.tableView?.addSearchBar(placeHolder: withPlaceHolder, barTintColor: barTintColor, completion: completion)
    }
    
    /// Navigationbar title and color
    public func setNavigationBar(title: String, attributes:[NSAttributedString.Key: Any]? = nil, barTintColor: UIColor? = nil, tintColor: UIColor? = nil) {
        self.navigationBarTheme = NavigationBarTheme(title: title, titleAttributes: attributes, tintColor: tintColor, barTintColor: barTintColor)
    }
    
    /// Right Barbutton title and action handler
    public func setRightBarButton(title: String, handler: @escaping (DataSource<T>) -> ()) {
        self.rightBarButtonTitle = title
        self.onRightBarButtonTapped = handler
    }
    
    /// Empty Data Label
    public func showEmptyDataLabel(text: String = defaultEmptyDataString, attributes: [NSAttributedString.Key: Any]? = nil) {
        self.tableView?.showEmptyDataLabel(text: text, attributes: attributes)
    }
    
    /// Show
    public func show(from: UIViewController) {
        self.show(style: .present, from: from)
    }
    
    public func show(style: PresentationStyle, from: UIViewController) {
        self.showMenu(with: style, from: from)
    }
    
    /// dismiss
    public func dismiss(animated: Bool? = true) {
        
        DispatchQueue.main.async { [weak self] in
            
            // perform on dimiss operations
            self?.menuWillDismiss()
            
            switch self?.menuPresentationStyle {
            case .push?:
                self?.navigationController?.popViewController(animated: animated!)
            case .present?, .popover?, .formSheet?, .alert?, .actionSheet?, .bottomSheet?:
               self?.dismiss(animated: animated!, completion: nil)
            case .none:
                break
            }
        }
    }
}

//MARK:- Private
extension RSSelectionMenu {

    // check if show rightBarButton
    fileprivate func showRightBarButton() -> Bool {
        switch menuPresentationStyle {
        case .present, .push:
            return (tableView?.selectionStyle == .multiple || !self.dismissAutomatically)
        default:
            return false
        }
    }
    
    // check if show leftBarButton
    fileprivate func showLeftBarButton() -> Bool {
        if case .present = menuPresentationStyle {
            return tableView?.selectionStyle == .single && self.dismissAutomatically
        }
        return false
    }
    
    // perform operation on dismiss
    fileprivate func menuWillDismiss() {
        
        // dismiss search
        if let searchBar = self.tableView?.searchControllerDelegate?.searchBar {
            if searchBar.isFirstResponder { searchBar.resignFirstResponder() }
        }
        
        // on menu dismiss
        if let dismissHandler = self.onDismiss {
            dismissHandler(self.tableView?.selectionDelegate?.selectedItems ?? [])
        }
    }
    
    // show
    fileprivate func showMenu(with: PresentationStyle, from: UIViewController) {
        parentController = from
        menuPresentationStyle = with
        
        if case .push = with {
            from.navigationController?.pushViewController(self, animated: true)
            return
        }
        
        var tobePresentController: UIViewController = self
        if case .present = with {
            tobePresentController = UINavigationController(rootViewController: self)
        }
        else if case let .popover(sourceView, size, arrowDirection, hideNavBar) = with {
            tobePresentController = UINavigationController(rootViewController: self)
			(tobePresentController as! UINavigationController).setNavigationBarHidden(hideNavBar, animated: false)
            tobePresentController.modalPresentationStyle = .popover
            if size != nil { tobePresentController.preferredContentSize = size! }
            
            let popover = tobePresentController.popoverPresentationController!
            popover.delegate = self
            popover.permittedArrowDirections = arrowDirection
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
        }
        else if case .formSheet = with {
            tobePresentController.modalPresentationStyle = .overCurrentContext
            tobePresentController.modalTransitionStyle = .crossDissolve
        }
        else if case let .alert(title, action, height) = with {
            tobePresentController = getAlertViewController(style: .alert, title: title, action: action, height: height)
            tobePresentController.setValue(self, forKey: contentViewController)
        }
        else if case let .actionSheet(title, action, height) = with {
            tobePresentController = getAlertViewController(style: .actionSheet, title: title, action: action, height: height)
            tobePresentController.setValue(self, forKey: contentViewController)
            
            // present as popover for iPad
            if let popoverController = tobePresentController.popoverPresentationController {
                popoverController.sourceView = from.view
                popoverController.permittedArrowDirections = []
                popoverController.sourceRect = CGRect(x: from.view.bounds.midX, y: from.view.bounds.midY, width: 0, height: 0)
            }
        }
        else if case let .bottomSheet(barButton, height) = with {
            tobePresentController = getAlertViewController(style: .actionSheet, title: nil, action: nil, height: height)
            tobePresentController.setValue(self, forKey: contentViewController)
            
            // present as popover for iPad
            if let popoverController = tobePresentController.popoverPresentationController {
                popoverController.barButtonItem = barButton
                popoverController.permittedArrowDirections = .any
            }
        }
        from.present(tobePresentController, animated: true, completion: nil)
    }
    
    // get alert controller
    fileprivate func getAlertViewController(style: UIAlertController.Style, title: String?, action: String?, height: Double?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: style)
        
        let actionTitle = action ?? doneButtonTitle
        let doneAction = UIAlertAction(title: actionTitle, style: .default) { [weak self] (doneButton) in
            self?.menuWillDismiss()
        }
        
        // add done action
        if (tableView?.selectionStyle == .multiple || !self.dismissAutomatically)  {
            alertController.addAction(doneAction)
        }
        
        let viewHeight = height ?? 350
        alertController.preferredContentSize.height = CGFloat(viewHeight)
        self.preferredContentSize.height = alertController.preferredContentSize.height
        return alertController
    }
    
    // navigation bar
    fileprivate func setNavigationBarTheme() {
        guard let navigationBar = self.navigationBar else { return }
        
        guard let theme = self.navigationBarTheme else {
            
            // hide navigationbar for popover, if no title present
            if case .popover = self.menuPresentationStyle {
                navigationBar.isHidden = true
            }
            
            // check for present style
            else if case .present = self.menuPresentationStyle, let parentNavigationBar = self.parentController?.navigationController?.navigationBar {
                
                navigationBar.titleTextAttributes = parentNavigationBar.titleTextAttributes
                navigationBar.barTintColor = parentNavigationBar.barTintColor
                navigationBar.tintColor = parentNavigationBar.tintColor
            }
            return
        }
        
        navigationItem.title = theme.title
        navigationBar.titleTextAttributes = theme.titleAttributes
        navigationBar.barTintColor = theme.barTintColor
        navigationBar.tintColor = theme.tintColor
    }
}
