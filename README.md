# RSSelectionMenu

An elegant selection list or dropdown menu for iOS with single or multiple selections.

[![https://github.com/rushisangani/RSSelectionMenu/blob/master/Images/multi1.gif](http://img.youtube.com/vi/9Br-3GnxDSo/0.jpg)](http://www.youtube.com/watch?v=9Br-3GnxDSo "RSSelectionMenu Demo")

[Demo Video](http://www.youtube.com/watch?v=9Br-3GnxDSo)

## Features

- **Single** and **Multiple** selection.
- Show menu with presentation styles like **Present**, **Push**, **Popover**, **Formsheet**, **Alert**, **Actionsheet**
- Set UITableViewCell types like **Basic**, **Subtitle**, **Right Detail**
- Set UITableViewCell selection style **Tickmark** or **Checkbox**
- Search Items from the list
- Works with Custom UITableViewCells
- Works with Custom model classes and structs
- Set Maximum selection limit
- Provide Empty data set text
- Provide header row as **Empty**, **All**, **None** or **Custom Text**
- Customizable design for UINavigationBar and UISearchBar

## What's new in 7.1.3
- Popover Style Improvements
- Now you can specify UITableView.Style while initializing

## Already using? Migrate to 7.1.3
- Remove all references of `UniquePropertyDelegate`,  `uniquePropertyName`, and `getUniquePropertyName()`
- Conform to `Equatable` in your model classes (if required)

## Requirements
```swift
iOS 9.0+ | Xcode 8.3+ | Swift 3.0+
```

## Installation

### CocoaPods

```ruby
pod 'RSSelectionMenu' or pod 'RSSelectionMenu', '~> 7.1.3'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate RSSelectionMenu into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "rushisangani/RSSelectionMenu" ~> 7.1
```
Then follow below steps:
- Run `carthage update` to build the framework.
- Set Framework search path in target build settings : Build Settings  -> Framework Search Paths  :  `$(PROJECT_DIR)/Carthage/Build/iOS` 
- Add  RSSelectionMenu.framework in `Embedded Binaries`.
- Add  RSSelectionMenu.framework in `Linked Frameworks and Libraries`.


## Usage

### Simple Selection List
```swift
let simpleDataArray = ["Sachin", "Rahul", "Saurav", "Virat", "Suresh", "Ravindra", "Chris"]
var simpleSelectedArray = [String]()

// Show menu with datasource array - Default SelectionStyle = single
// Here you'll get cell configuration where you'll get array item for each index
// Cell configuration following parameters.
// 1. UITableViewCell   2. Item of type T   3. IndexPath

let selectionMenu = RSSelectionMenu(dataSource: simpleDataArray) { (cell, item, indexPath) in
    cell.textLabel?.text = item
}

// set default selected items when menu present on screen.
// here you'll get handler each time you select a row
// 1. Selected Item  2. Index of Selected Item  3. Selected or Deselected  4. All Selected Items

selectionMenu.setSelectedItems(items: simpleSelectedArray) { [weak self] (item, index, isSelected, selectedItems) in

    // update your existing array with updated selected items, so when menu show menu next time, updated items will be default selected.
    self?.simpleSelectedArray = selectedItems
}

// show as PresentationStyle = push
selectionMenu.show(style: .push, from: self)
```

### Multiple Selection List
```swift
let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: simpleDataArray) { (cell, name, indexPath) in

    cell.textLabel?.text = name

    // customization
    // set image
    cell.imageView?.image = #imageLiteral(resourceName: "profile")
    cell.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
}
```

- Set Maximum selection limit (Optional)
```swift
selectionMenu.setSelectedItems(items: selectedDataArray, maxSelected: 3) { (item, selected, selectedItems) in
}
// or 
selectionMenu.maxSelectionLimit = 3
```

### Cell Selection Style
```swift
selectionMenu.cellSelectionStyle = .tickmark
// or
selectionMenu.cellSelectionStyle = .checkbox
```

### Presentation Style - Formsheet, Popover, Alert, Actionsheet
```swift
// show as formSheet
selectionMenu.show(style: .formSheet, from: self)


// show as popover
selectionMenu.show(style: .popover(sourceView: sourceView, size: nil), from: self) 

// or specify popover size
selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: 200, height: 300)), from: self)


// show as alert
selectionMenu.show(style: .alert(title: "Select", action: nil, height: nil), from: self)

// or specify alert button title
selectionMenu.show(style: .alert(title: "Select", action: "Done", height: nil), from: self)


// show as actionsheet
selectionMenu.show(style: .actionSheet(title: nil, action: "Done", height: nil), from: self)
```

### Auto Dismissal
Prevent auto dismissal for single selection
```swift
selectionMenu.dismissAutomatically = false
```

### Event Handlers

#### On Dismiss
```swift
selectionMenu.onDismiss = { [weak self] selectedItems in
    self?.selectedDataArray = selectedItems
    
    // perform any operation once you get selected items
}
```

#### On WillAppear
```swift
selectionMenu.onWillAppear = {
    /// do something..
}
```

### Customization

#### SearchBar
- You'll get notified via handler, when user starts typing in searchbar.
```swift
// show searchbar
selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in

  // return filtered array based on any condition
  // here let's return array where name starts with specified search text

  return self?.dataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) }) ?? []
}
```

#### Cell Style - Right Detail or Sub Title
```swift
let selectionMenu = RSSelectionMenu(selectionType: .single, dataSource: dataArray, cellType: .rightDetail) { (cell, item, indexPath) in

    // here you can set any text from object
    // let's set firstname in title and lastname as right detail

    let firstName = item(separatedBy: " ").first
    let lastName = item.components(separatedBy: " ").last

    cell.textLabel?.text = firstName
    cell.detailTextLabel?.text = lastName
}

selectionMenu.setSelectedItems(items: selectedDataArray) { [weak self] (item, selected, selectedItems) in
    self?.selectedDataArray = selectedItems
}

// show as default
selectionMenu.show(from: self)
```

#### Custom Cells
- Provide custom cell with xib file name and cell identifier.
```swift
let cellNibName = "CustomTableViewCell"
let cellIdentifier = "cell"

// create menu with multi selection and custom cell

let selectionMenu =  RSSelectionMenu(selectionStyle: .multiple, dataSource: customDataArray, cellType: .custom(nibName: cellNibName, cellIdentifier: cellIdentifier)) { (cell, person, indexPath) in

    // cast cell to your custom cell type
    let customCell = cell as! CustomTableViewCell

    // here you'll get specified model object
    // set data based on your need
    customCell.setData(person)
}
```

#### Header Row - Empty, None, All, or Custom
```swift
// To show first row as Empty, when dropdown as no value selected by default
// add first row as empty -> Allow empty selection

let isEmpty = (selectedDataArray.count == 0)
selectionMenu.addFirstRowAs(rowType: .empty, showSelected: isEmpty) { (text, selected) in

    /// do some stuff...
    if selected {
        print("Empty Option Selected")
    }
}
```

#### Empty Data String
```swift
// show message 'No data found'
menu.showEmptyDataLabel()

// or
menu.showEmptyDataLabel(text: "No players found")
```

### DataSource - Equatable conformance
```swift
struct Employee: Equatable {
    
    let empId: Int?
    let name: String?
}
```
or
```swift
class Person: NSObject {

    let id: Int
    let firstName: String
    let lastName: String

    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
```

### UI Customization

#### NavigationBar
- Set Title, BarButton Titles, TintColor, and Title Color
```swift
// set navigation bar title and attributes
selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), tintColor: UIColor.white)

// right barbutton title - Default is 'Done'
selectionMenu.rightBarButtonTitle = "Submit"

// left barbutton title - Default is 'Cancel'
selectionMenu.leftBarButtonTitle = "Close"
```

#### SearchBar
- Set Placeholder, Tint Color
```swift
// show searchbar with placeholder and barTintColor
selectionMenu.showSearchBar(withPlaceHolder: "Search Player", barTintColor: UIColor.lightGray.withAlphaComponent(0.2)) { [weak self] (searchText) -> ([String]) in

    return self?.dataArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) }) ?? []
}
```

### Example
See [Example](https://github.com/rushisangani/RSSelectionMenu/tree/master/RSSelectionMenuExample) for more details.

## License

RSSelectionMenu is released under the MIT license. [See LICENSE](https://github.com/rushisangani/RSSelectionMenu/blob/master/LICENSE) for details.
