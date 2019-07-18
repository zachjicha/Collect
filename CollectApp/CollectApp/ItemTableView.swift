//
//  ItemTableView.swift
//  CollectApp
//
//  Created by Brian Thyfault on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class ItemTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var receiptItems:[ReceiptItem] = []
    var groupOfNames:[String] = ["Brian","Zach","Harsh"]
    var filteredItems = [ReceiptItem]()
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Items"
        //navigationItem.searchController = searchController
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        //receiptItems = createItemArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    
    func createItemArray() -> [ReceiptItem] {
        var tempItemArray: [ReceiptItem] = []
        for _ in 0...5 {
            tempItemArray.append(ReceiptItem(itemName: "Hello", itemCost: 25))
        }
        return tempItemArray
    }


    
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = receiptItems.filter({( receiptItem : ReceiptItem) -> Bool in
            return receiptItem.itemName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    @IBAction func calculateSplit(_ sender: Any) {
        
        let cells = self.tableView.visibleCells as! Array<ItemTableCell>
        
        for (index, cell) in cells.enumerated() {
            receiptItems[index].itemSplitters? = []
            //print(cell.nameSegment)
            //print(cell.nameSegment.)
            //let selectedIndices: IndexSet = (cell.nameSegment.selectedSegmentIndexes)
            let currSegment:MultiSelectSegmentedControl = cell.nameSegment
            //print(currSegment.selectedSegmentIndexes)
            for nameIndex in 0...groupOfNames.count-1 {
        
                if(cell.nameSegment.isEnabledForSegment(at: nameIndex)) {
                    print(currSegment.titleForSegment(at: nameIndex))
                    
                    receiptItems[index].itemSplitters?.append(groupOfNames[nameIndex])
                }
            }
        }
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "DebtsView") as? DebtsView else {return}
        destinationVC.receiptItems = self.receiptItems
        destinationVC.groupOfNames = self.groupOfNames
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
        
    }
    
    
    func multiSelect(multiSelectSegmendedControl: MultiSelectSegmentedControl, didChangeValue value: Bool, atIndex index: Int) {
        
        print("multiSelect delegate selected: \(value) atIndex: \(index)")
    }
    
    
    //Delagates and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiptItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let receiptItem = receiptItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell") as! ItemTableCell
        
        cell.setItemName(recepitItem: receiptItem)
        cell.setItemGroup(splittingGroup: groupOfNames)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ItemTableView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
