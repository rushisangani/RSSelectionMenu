# RSSelectionMenu

An elegant selection list or dropdown menu for iOS with single or multiple selections.


![Alt text](/Images/image1.png?raw=true "Home")
![Alt text](/Images/image2.png?raw=true "Simple push")
![Alt text](/Images/image3.png?raw=true "FormSheet")
![Alt text](/Images/image4.png?raw=true "Popover")
![Alt text](/Images/image5.png?raw=true "Multiple selection")
![Alt text](/Images/image6.png?raw=true "Custom cells")
## Features

- Show selection menu as List, Popover or FormSheet with single or multiple selection.
- Use different cell types. (Basic, RightDetail, SubTitle)
- Works with Swift premitive types as well as custom NSObject classes.
- Show selection menu with your custom cells.
- Search from the list with inbuilt SearchBar.

## Requirements

- iOS 10.0+ 
- Xcode 8.3+
- Swift 3.2+


## Installation

### CocoaPods

```ruby
pod 'RSSelectionMenu'
```

## Usage

### Selection Type
- Single
- Multiple

### PresentationStyle
- Present
- Push
- Formsheet
- Popover

### UITableViewCell Type
- Basic
- RightDetail
- SubTitle
- Custom

### FirstRow Type
- Empty
- None
- All


### Simple Selection List

```swift
let simpleDataArray = ["Sachin", "Rahul", "Saurav", "Virat", "Suresh", "Ravindra", "Chris"]
var simpleSelectedArray = [String]()

// Show menu with datasource array - Default SelectionType = Single
// Here you'll get cell configuration where you can set any text based on condition
// Cell configuration following parameters.
// 1. UITableViewCell   2. Object of type T   3. IndexPath

let selectionMenu =  RSSelectionMenu(dataSource: simpleDataArray) { (cell, object, indexPath) in
cell.textLabel?.text = object
}

// set navigation title
selectionMenu.setNavigationBar(title: "Select Player")

// set default selected items when menu present on screen.
// Here you'll get onDidSelectRow

selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, isSelected, selectedItems) in

    // update your existing array with updated selected items, so when menu presents second time updated items will be default selected.
    self.simpleSelectedArray = selectedItems
}

// show as PresentationStyle = Push
selectionMenu.show(style: .Push, from: self)
```

### Present Modally with Right Detail and first row as Empty

```swift
let dataArray = ["Sachin Tendulkar", "Rahul Dravid", "Saurav Ganguli", "Virat Kohli", "Suresh Raina", "Ravindra Jadeja", "Chris Gyle", "Steve Smith", "Anil Kumble"]
var selectedDataArray = [String]()
var firstRowSelected = true

// Show menu with datasource array - SelectionType = Single & CellType = RightDetail

let selectionMenu =  RSSelectionMenu(selectionType: .Single, dataSource: dataArray, cellType: .RightDetail) { (cell, object, indexPath) in

    // here you can set any text from object
    // let's set firstname in title and lastname as right detail

    let firstName = object.components(separatedBy: " ").first
    let lastName = object.components(separatedBy: " ").last

    cell.textLabel?.text = firstName
    cell.detailTextLabel?.text = lastName
}

selectionMenu.setSelectedItems(items: selectedDataArray) { (text, selected, selectedItems) in
    self.selectedDataArray = selectedItems
}

// To show first row as Empty, when dropdown as no value selected by default
// Here you'll get Text and isSelected when user selects first row

selectionMenu.addFirstRowAs(rowType: .Empty, showSelected: self.firstRowSelected) { (text, isSelected) in
    self.firstRowSelected = isSelected
}

// show as default
selectionMenu.show(from: self)
```

### Formsheet with SearchBar

```swift
// Show menu with datasource array - PresentationStyle = Formsheet & SearchBar

let selectionMenu = RSSelectionMenu(dataSource: dataArray) { (cell, object, indexPath) in
    cell.textLabel?.text = object
}

// show selected items
selectionMenu.setSelectedItems(items: selectedDataArray) { (text, selected, selectedItems) in
    self.selectedDataArray = selectedItems
}

// show searchbar with placeholder text and barTintColor
// Here you'll get search text - when user types in seachbar

selectionMenu.showSearchBar(withPlaceHolder: "Search Player", tintColor: UIColor.white.withAlphaComponent(0.3)) { (searchText) -> ([String]) in

    // return filtered array based on any condition
    // here let's return array where firstname starts with specified search text

    return self.dataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
}

// show as formsheet
selectionMenu.show(style: .Formsheet, from: self)
```

### Multi Selection, SearchBar and Custom NavigationBar

```swift
let selectionMenu = RSSelectionMenu(selectionType: .multiple, dataSource: simpleDataArray, selectedItems: simpleSelectedArray) { (cell, object, indexPath) in
            
    cell.textLabel?.text = object
}

// set navigation title and color
selectionMenu.setNavigationBar(title: "Select Player", attributes: [NSForegroundColorAttributeName: UIColor.white], barTintColor: UIColor.orange.withAlphaComponent(0.5))


// add first row as 'All'
selectionMenu.showFirstRowAs(type: .All, selected: firstRowSelected) { (text, selected) in
    self.firstRowSelected = selected
}

selectionMenu.didSelectRow { (object, isSelected, selectedData) in
    self.simpleSelectedArray = selectedData
}

// add searchbar
selectionMenu.addSearchBar { (searchText) -> ([String]) in
    return self.simpleDataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
}

selectionMenu.show(from: self)
```

### Custom Cells with Models

```swift
// Implement UniqueProperty protocol and return property name which has unique value.
// You can also specify this later by - selectionMenu.uniquePropertyName = "id"

class Person: NSObject, UniqueProperty {

    let id: Int
    let firstName: String
    let lastName: String

    init(id: Int, firstName: String, lastName: String) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    }

    // Here id has the unique value for each person
    func uniquePropertyName() -> String {
        return "id"
    }
}

var customDataArray = [Person]()
var customselectedDataArray = [Person]()

// prepare data array with models
customDataArray.append(Person(id: 1, firstName: "Sachin", lastName: "Tendulkar"))
customDataArray.append(Person(id: 2, firstName: "Rahul", lastName: "Dravid"))
customDataArray.append(Person(id: 3, firstName: "Virat", lastName: "Kohli"))


// Show menu with datasource array with Models - SelectionType = Multiple, CellType = Custom
// For Custom cells - You need to specify NibName and CellIdentifier
// For Custom Models - You need to specify UniquePropertyName

let selectionMenu =  RSSelectionMenu(selectionType: .Multiple, dataSource: customDataArray, cellType: .Custom(nibName: "CustomTableViewCell", cellIdentifier: "cell")) { (cell, person, indexPath) in

    // cast cell to your custom cell type
    let customCell = cell as! CustomTableViewCell

    // here you'll get specified model object
    // set data based on your need
    customCell.setData(person)
}

// show with default selected items and update when user selects any row
selectionMenu.setSelectedItems(items: customselectedDataArray) { (text, selected, selectedItems) in
    self.customselectedDataArray = selectedItems
}

// show searchbar
selectionMenu.showSearchBar { (searchtext) -> ([Person]) in
    return self.customDataArray.filter({ $0.firstName.lowercased().hasPrefix(searchtext.lowercased()) })
}

selectionMenu.show(style: .Push, from: self)
```

## License

RSSelectionMenu is released under the MIT license. [See LICENSE](https://github.com/rushisangani/RSSelectionMenu/blob/master/LICENSE) for details.
