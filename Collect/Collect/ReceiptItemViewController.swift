//
//  ReceiptItemViewController.swift
//  Collect
//
//  Created by Brian Thyfault on 7/17/19.
//  Copyright © 2019 The Collective. All rights reserved.
//  YOOOOOOOOO

import UIKit
import SCLAlertView

class ReceiptItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var peopleArray:[PeopleList] = []
    var receiptName:String = ""
    var AllItems:[ReceiptItems] = []
    
    @IBOutlet weak var receiptImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up table view
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Receipt Items"
        
        //Fetches the necessary data based on the receipt name passed from the previous storyboard/viewController
        self.FetchData(receiptName: receiptName)
        self.tableView.reloadData()
        receiptImage.image = fetchImageData(receiptName: receiptName)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    
    //Sets number of sections of the table
    func SecNum (in tableView: UITableView) -> Int {
        return 1
    }
    
    //Sets the number of rows for the table view
    //In this case, the table view will constantly expend, thereby using the array size of the Receipt entity
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllItems.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            
            //Show an alert that asks for a new name and price
            let alert = SCLAlertView()
            let getNewName = alert.addTextField("Enter a new Item name")
            let getNewPrice = alert.addTextField("Enter new item price")
            
            //Auto fill the name field as most will just want to edit price
            getNewName.text = self.AllItems[indexPath.row].itemName
            //Uncomment to add autofill for price as well
            //getNewPrice.text = String(self.AllItems[indexPath.row].itemPrice)
            
            alert.addButton("Finish Editing") {
                // If field is empty, alert the user
                if (getNewName.text == "" || getNewPrice.text == "") {
                    SCLAlertView().showError("Edit Error", subTitle: "You must enter a new name and price", colorStyle:0xFF002A)
                    return
                }
                //If price is not a double or is negative, alert the user
                else if (Double(getNewPrice.text!) == nil || Double(getNewPrice.text!)! < 0) {
                    SCLAlertView().showError("Edit Error", subTitle: "You must enter a valid price", colorStyle:0xFF002A)
                    return
                }
                //If all conditions met
                else {
                    //Update cost and name with text field entries
                    self.AllItems[indexPath.row].updateItemData(newItemName: getNewName.text!, newItemPrice: Double(getNewPrice.text!)!)
                    //Reload the view
                    self.viewDidLoad()
                }
            }
            //Show the alert
            alert.showEdit("Edit item", subTitle: "Change item name and price", colorStyle:0xFF002A)
            
        }
        
        //Delete action
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.AllItems[indexPath.row].deleteItem()
            self.viewDidLoad()
        }
        
        return [delete, edit]
        
    }
    /*
    //Function that adds the swipe to delete function to the receipt view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Deletes the item from the list
            AllItems[indexPath.row].deleteItem()
        }
        //reloads the view
        viewDidLoad()
        
    }*/
    
    //Uses identifier of table view cell (can be set in properties of the cell) to retrieve the data that will be displayed within each row of the table (in this case, its the item names of within the receipt entity)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
        let receiptItem = AllItems[indexPath.row]
        cell.textLabel!.text = receiptItem.itemName! + String(format: " - $%.2f", receiptItem.itemPrice)
        
        //Predefined strings for detailedTextLabel
        let prependText = "Payers:  "
        var listOfPayers = ""
        
        //For loop that searches for names based on the item to identify if they're a payer or not
        for person in peopleArray {
            //If statement to check and see if the person is associated with the item
            if (AllItems[indexPath.row].CheckItemPeopleList(nameOfPerson: person.nameOfPerson!) == true) {
                listOfPayers.append("\(person.nameOfPerson!), ")
            }
        }
        //Removes the space and comma at the end
        listOfPayers = String(listOfPayers.dropLast())
        listOfPayers = String(listOfPayers.dropLast())
        
        //Sets who will pay for that item instead of the item price
        if (listOfPayers == "") {
            cell.detailTextLabel!.text = (prependText + "None")
        }
        else {
            cell.detailTextLabel!.text = (prependText + listOfPayers)
        }
        
        //Sets the color of the payers
        cell.detailTextLabel!.textColor = UIColor(named: "CollectRed")
        
        // Accessory View
        // Image containing red arrow
        let image = UIImage(named: "arrow.png")
        // Image View (0,0) because it will attach to accessoryView.
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!/2, height:(image?.size.height)!/2));
        // Set the image view's image to the arrow
        checkmark.image = image
        // Add it to the cell's accessory view
        cell.accessoryView = checkmark
        
        return cell
    }
    
    //Fetches item data based on the receipt name selected
    //The receiptName is the data passed through the segue
    func FetchData(receiptName: String) {
        
        //Fetches the specific data
        guard let receiptItemsObj = ReceiptItems.FetchReceiptItems(with: receiptName)
            //If data is not found, returns no data found
            else {
                print("Data Not Found")
                return
        }
        print("SUCCESS")
        AllItems = receiptItemsObj
    }
    
    //Segue data transfer for data dependancies within SelectNamesViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNameSwitches" {
            
            let controller = segue.destination as! SelectNamesViewController
            controller.receiptName = receiptName
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //In Storyboard ItemListViewController, there is a global variable titled "receiptname".  This sends the receipt name to the ItemListViewController so it can load the items of that specific receipt
                let controller = segue.destination as! SelectNamesViewController
                controller.itemName = AllItems[indexPath.row].itemName!
                print("Item Name Being passed: " + controller.itemName)
            }
        }
    }
    
    
    
    //Called whenever the view appears, used for refreshing when popping off view controller stack
    override func viewDidAppear(_ animated: Bool) {
        //Refresh the view
        self.viewDidLoad()
    }
    

}
