# RSSelectionMenu

An elegant selection list or dropdown menu for iOS with single or multiple selections.

### What's New in version 5.3.2
- New presentation styles added: **Alert** & **Actionsheet**
- Show title with Popover
- Auto Dismiss flag added (True or False)
- Support for Swift 4.2
- Carthage support

![Alt text](https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/Alert.png "Alert")
![Alt text](https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/Actionsheet.png "Actionsheet")
![Alt text](https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/Popover.jpg "Popover")

![Alt text](https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/01.gif "Single Selection")
![Alt text](https://raw.githubusercontent.com/rushisangani/RSSelectionMenu/master/Images/03.gif "Custom")

## Features

### Selection
```swift
Single | Multiple
```

### Presentation Style
```swift
Present | Push | Formsheet | Popover | Alert | Actionsheet
```

### Cell Style
```swift
Basic | RightDetail | SubTitle | Custom
```

### Data Types
```swift
Premitive Types (String, Int,..) | Codable Objects | NSObject Subclasses | Dictionary Array
```

### Customization
```swift
SearchBar | NavigationBar | Max Selection Limit | Header Row
```

## Requirements
```swift
iOS 9.0+ | Xcode 8.3+ | Swift 3.0+
```

## Installation

### CocoaPods

```ruby
pod 'RSSelectionMenu' or pod 'RSSelectionMenu', '~> 5.3.2'
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
github "rushisangani/RSSelectionMenu" ~> 5.3.2
```
Then follow below steps:
- Run `carthage update` to build the framework.
- Set Framework search path in target build settings : Build Settings  -> Framework Search Paths  :  `$(PROJECT_DIR)/Carthage/Build/iOS` 
- Add  RSSelectionMenu.framework in `Embedded Binaries`.
- Add  RSSelectionMenu.framework in `Linked Frameworks and Libraries`.

<!--### Swift 4 project with RSSelectionMenu-->
<!--RSSelectionMenu is developed in swift 3.2. So if you're using Swift 4.0 then put following script in your end of pod file.-->
<!---->
<!--```ruby-->
<!--post_install do |installer|-->
<!--    installer.pods_project.targets.each do |target|-->
<!--        target.build_configurations.each do |config|-->
<!--            config.build_settings['SWIFT_VERSION'] = '3.2'-->
<!--        end-->
<!--    end-->
<!--end-->
<!--```-->
<!--- Alternatively you can follow below steps.-->
<!---->
<!--1. Go to pods projects in your workspace.-->
<!--2. Select RSSelectionMenu target.-->
<!--3. Go to Build Settings and set Swift Language Version to 3.2-->

## Usage

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
    
    // Change tint color (if needed)
    cell.tintColor = .orange
}

// set default selected items when menu present on screen.
// Here you'll get onDidSelectRow

selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, isSelected, selectedItems) in

    // update your existing array with updated selected items, so when menu presents second time updated items will be default selected.
    self.simpleSelectedArray = selectedItems
}

// auto dismiss
selectionMenu.dismissAutomatically = false      // default is true

// show as PresentationStyle = Push
selectionMenu.show(style: .Push, from: self)
```
### Multiple Selection List
```swift
let selectionMenu = RSSelectionMenu(selectionType: .Multiple, dataSource: dataArray, cellType: .Basic) { (cell, object, indexPath) in
    cell.textLabel?.text = object
}
```
- Set Maximum selection limit (Optional)
```swift
selectionMenu.setSelectedItems(items: selectedDataArray, maxSelected: 3) { (text, selected, selectedItems) in
}
```

### Presentation Style - Formsheet, Popover, Alert, Actionsheet
```swift
// show as Formsheet
selectionMenu.show(style: .Formsheet, from: self)

// show as Popover
selectionMenu.show(style: .Popover(sourceView: sourceView, size: nil), from: self)

// show as Alert
selectionMenu.show(style: .Alert(title: "Select", action: nil, height: nil), from: self)

// Show as Actionsheet
selectionMenu.show(style: .Actionsheet(title: nil, action: "Done", height: nil), from: self)
```

### Event Handlers

#### On Dismiss
```swift
selectionMenu.onDismiss = { selectedItems in
    self.selectedDataArray = selectedItems
    
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
selectionMenu.showSearchBar { (searchtext) -> ([String]) in

  // return filtered array based on any condition
  // here let's return array where name starts with specified search text

  return self.dataArray.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
}
```

#### Cell Style - Right Detail or Sub Title
```swift
let selectionMenu = RSSelectionMenu(selectionType: .Single, dataSource: dataArray, cellType: .RightDetail) { (cell, object, indexPath) in

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

// show as default
selectionMenu.show(from: self)
```

#### Custom Cells
- Provide custom cell with xib file name and cell identifier.
```swift
let selectionMenu =  RSSelectionMenu(selectionType: .Multiple, dataSource: customDataArray, cellType: .Custom(nibName: "CustomTableViewCell", cellIdentifier: "cell")) { (cell, person, indexPath) in

// cast cell to your custom cell type
let customCell = cell as! CustomTableViewCell

// set cell data here
}
```

#### Header Row - Empty, None, All, or Custom
```swift
// To show first row as Empty, when dropdown as no value selected by default
// Here you'll get Text and isSelected when user selects first row

selectionMenu.addFirstRowAs(rowType: .Empty, showSelected: self.firstRowSelected) { (text, isSelected) in
    
    // update your flag here to maintain consistency. -  This is required to be update when presenting for the second time.
    self.firstRowSelected = isSelected
}
```

### DataSource - Codable Objects, NSObject Subclasses or Dictionary Array
- Implement **UniqueProperty** protocol to model class or structure.
```swift
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
```
or
```swift
struct Employee: Codable, UniqueProperty {
    
    let empId: Int?
    let name: String?
    
    func uniquePropertyName() -> String {
        return "empId"
    }
}
```
or
```swift
selectionMenu.uniquePropertyName = "empId" or "keyname of unique value in dictionary"
```

### UI Customization

#### NavigationBar
- Set Title, BarButton Titles, TintColor, and Title Color
```swift
// set navigation title and color
selectionMenu.setNavigationBar(title: "Select Player", attributes: nil, barTintColor: UIColor.orange.withAlphaComponent(0.5), tintColor: UIColor.white)

// right barbutton title - Default is 'Done'
selectionMenu.rightBarButtonTitle = "Submit"

// left barbutton title - Default is 'Cancel'
selectionMenu.leftBarButtonTitle = "Close"
```

#### SearchBar
- Set Placeholder, Tint Color
```swift
// show searchbar with placeholder and tint color
selectionMenu.showSearchBar(withPlaceHolder: "Search Player", tintColor: UIColor.withAlphaComponent(0.5)) { (searchtext) -> ([String]) in
    return self.dataArray.filter({ $0.lowercased().hasPrefix(searchtext.lowercased()) })
}
```

### Example
See [Example](https://github.com/rushisangani/RSSelectionMenu/tree/master/RSSelectionMenuExample) for more details.

## License

RSSelectionMenu is released under the MIT license. [See LICENSE](https://github.com/rushisangani/RSSelectionMenu/blob/master/LICENSE) for details.
