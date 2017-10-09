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
- Swift 3.0+


## Installation

### CocoaPods

```ruby
pod 'RSSelectionMenu'
or
pod 'RSSelectionMenu', '~> 1.0.6'
```

## Usage

### Selection Type
- Single
- Multiple

### PresentationStyle
- Present
- Push
- FormSheet
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

let selectionMenu = RSSelectionMenu(dataSource: simpleDataArray, selectedItems:simpleSelectedArray) { (cell, object, indexPath) in
    cell.textLabel?.text = object
}
        
// title
selectionMenu.setNavigationBar(title: "Select Player")

// did select handler
selectionMenu.didSelectRow { (object, isSelected, selectedData) in
    
    // update existing array on select
    self.simpleSelectedArray = selectedData
}
selectionMenu.show(with: .push, from: self)
```

### Present Modally with Right Detail and first row as None

```swift
let dataArray = ["Sachin Tendulkar", "Rahul Dravid", "Saurav Ganguli", "Virat Kohli", "Suresh Raina", "Ravindra Jadeja", "Chris Gyle", "Steve Smith", "Anil Kumble"]
var selectedDataArray = [String]()
var firstRowSelected = true

let selectionMenu = RSSelectionMenu(dataSource: dataArray, selectedItems: selectedDataArray, cellType: .rightDetail) { (cell, object, indexPath) in
            
	let firstName = object.components(separatedBy: " ").first
	let lastName = object.components(separatedBy: " ").last

	cell.textLabel?.text = firstName
	cell.detailTextLabel?.text = lastName
}
        
// add first row as 'None'
selectionMenu.showFirstRowAs(type: .None, selected: firstRowSelected) { (text, selected) in
    self.firstRowSelected = selected
}

selectionMenu.didSelectRow { (object, isSelected, selectedArray) in
    self.selectedDataArray = selectedArray
}

selectionMenu.show(from: self)
```

### Formsheet with SearchBar

```swift
let selectionMenu = RSSelectionMenu(dataSource: dataArray, selectedItems: selectedDataArray) { (cell, object, indexPath) in
            
    let firstName = object.components(separatedBy: " ").first
    let lastName = object.components(separatedBy: " ").last
    
    cell.textLabel?.text = firstName
    cell.detailTextLabel?.text = lastName
}

selectionMenu.didSelectRow { (object, isSelected, selectedArray) in
    self.selectedDataArray = selectedArray
}

// add searchbar
selectionMenu.addSearchBar { (searchText) -> ([String]) in
    return self.dataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
}

selectionMenu.show(style: .formSheet, from: self)
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

var customDataArray = [Person]()
var customselectedDataArray = [Person]()

// prepare data array with models
customDataArray.append(Person(id: 1, firstName: "Sachin", lastName: "Tendulkar"))
customDataArray.append(Person(id: 2, firstName: "Rahul", lastName: "Dravid"))
customDataArray.append(Person(id: 3, firstName: "Virat", lastName: "Kohli"))


// specify unique key for your model or dictionary that contains an unique value.
// This is required to identify each row uniquely. (Here, the unique key is "id" that identifies the person uniquely.)

let selectionMenu = RSSelectionMenu(selectionType: .multiple, dataSource: customDataArray, selectedItems: customselectedDataArray, uniqueKey: "id") { (cell, person, indexPath) in
            
    let customCell = cell as! CustomTableViewCell
    customCell.setData(person: person)
}


// register your xib for tableviewcell        
selectionMenu.registerNib(nibName: "CustomTableViewCell", forCellReuseIdentifier: "cell")

selectionMenu.didSelectRow { (object, isSelected, selectedData) in
    self.customselectedDataArray = selectedData
}

selectionMenu.addSearchBar { (text) -> ([Person]) in
    return self.customDataArray.filter({ $0.firstName.lowercased().hasPrefix(text.lowercased()) })
}
selectionMenu.show(with: .push, from: self)
```

## License

RSSelectionMenu is released under the MIT license. [See LICENSE](https://github.com/rushisangani/RSSelectionMenu/blob/master/LICENSE) for details.
