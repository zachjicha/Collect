//
//  ReceiptsViewController.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/10/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView
import Alamofire
import SwiftyJSON

class ReceiptsViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    var selectedPhoto:UIImage!
    var Items : [Item] = []
    // Global Receipt Name
    var recName : String = ""
    var numberOfUnknowns:Int = 1
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //Function that is called when a newReceiptButton is pressed
    @objc func newReceiptButton()
    {
        
        if let viewWithTag = self.view.viewWithTag(69) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag2 = self.view.viewWithTag(420) {
            viewWithTag2.removeFromSuperview()
        }
        
        
        
        //Re-initializes Items array back to having nothing (previous items stay if you scan 2 or more receipts in 1 session)
        Items = []
        
        // Custom alert view
        let alert = SCLAlertView()
        let GetInfo = alert.addTextField("Enter receipt name")
        alert.addButton("Add Receipt") {
            // If field is empty
            if (GetInfo.text == "") {
                print("Please Enter a receipt Name")
                SCLAlertView().showError("Add Error", subTitle: "You must enter a receipt name", closeButtonTitle: "OK", colorStyle:0xFF002A)
                return
            }
            if (CheckDuplicity(receiptName: GetInfo.text!) == true) {
                print("Data already exists")
                SCLAlertView().showError("Add Error", subTitle: "This receipt name already exists.", closeButtonTitle: "OK", colorStyle:0xFF002A)
                return
            }
            else
            {
                self.recName = GetInfo.text!

                //Image picker controller picks an image from either the
                //camera or camera roll based on user selection
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                
                //Action sheet to pick photo source
                let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
                
                //Add source slections to action sheet
                actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
                    
                    //Check if camera is available before accessing it
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        imagePickerController.sourceType = .camera
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
                    else {
                        
                        //Alert the user that the camera is not available
                        //This will probably never happen
                        let noCameraAlert = UIAlertController(title: "Camera Not Available", message: "The device's camera cannot be accessed by Collect", preferredStyle: .alert)
                        noCameraAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(noCameraAlert, animated: true, completion: nil)
                        
                    }
                    
                } ))
                
                actionSheet.addAction(UIAlertAction(title: "Camera Roll", style: .default, handler: { (action: UIAlertAction) in
                    
                    imagePickerController.sourceType = .photoLibrary
                    self.present(imagePickerController, animated: true, completion: nil)
                } ))
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                //Present the action sheet
                self.present(actionSheet, animated: true, completion: nil)
                
            }
        }
        alert.showEdit("Add a Receipt", subTitle: "Either upload from camera roll or take a picture", closeButtonTitle: "Cancel", colorStyle:0xFF002A)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Get the image from the picker controller and set it to the selected photo
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        selectedPhoto = image
    
        
        //Dismiss the picker controller
        picker.dismiss(animated: true, completion: self.parseReceipt)
        
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //Parse the receipt using Harsh's code
    func parseReceipt() {
        
        print("IN API CALL")
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance).showWait(self.recName, subTitle: "Adding receipt to Collect...", closeButtonTitle: nil, timeout: nil, colorStyle: 0xFF002A, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.setSubTitle("Progress: " + String(50 + Int.random(in: -5..<5)) + "%")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                alert.setSubTitle("Progress: " + String(75 + Int.random(in: -5..<5)) + "%")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    alert.setSubTitle("Progress: " + String(90 + Int.random(in: -5..<5)) + "%")
                    
                }
            }
        }
        // API Setup:
        let key = "a31246109d0211e98bfadfb7eb1aa8b5" // API-Key
        guard let url = URL(string: "https://api-au.taggun.io/api/receipt/v1/verbose/file") else {
            return
        } // URL for API
        
        // Headers for JSON request
        let headers: HTTPHeaders = [
            "apikey": key,
            "Content-type": "multipart/form-data",
            "Accept" : "application/json"]
        
        guard let img_data = selectedPhoto.jpegData(compressionQuality: 1.0) else { return  }
        
        // Use Alamofire to upload image
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(img_data, withName: "file", fileName: "rec.img", mimeType: "image/jpg")
        }, to: url, method: .post, headers: headers)
            .responseJSON { (response) in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    
                    //checks to see if error is detected or not
                    let errorCheck = json["error"].string
                    
                    //If receipt could not be read, makes an alert show up saying that
                    if (errorCheck == "I'm a teapot") {
                        alert.close()
                        SCLAlertView().showError("Receipt Read Error", subTitle: "Could Not Read Receipt", closeButtonTitle: "OK", colorStyle:0xFF002A)
                        return
                    }
                    
                    //Variable to keep track of taxPercent (initialized to 0 in case taxAmount is not valid)
                    var taxPercent: Double = 0.000
                    
                    //Gets the total amount and the tax amount
                    let totalAmount = json["totalAmount"]["data"].double
                    if let taxAmount = json["taxAmount"]["data"].double {
                        //Gets the total amount before taxes
                        let totalAmountWithoutTax = Double(totalAmount!) - Double(taxAmount)
                        
                        //Gets the tax percent of the receipt based on totalAmountWithoutTax and taxAmount
                        taxPercent = Double(taxAmount)/Double(totalAmountWithoutTax)
                    }
                    
                    //print("TOTAL AMOUNT: \(String(describing: totalAmount))")
                    //print("TAX AMOUNT: \(String(describing: taxAmount))")
                    if let amounts = json["amounts"].array
                        
                    {
                        
                        //Reset number of unknowns for each receipt
                        self.numberOfUnknowns = 1
                        
                        for JSONItem in amounts
                        {
                            
                            let item = Item(itemName: self.trimItemName(itemName: JSONItem["text"].string!), totalAmount: JSONItem["data"].double)
                            //let item = Item(itemName: JSONItem["text"].string!, totalAmount: JSONItem["data"].double)
                            // print(item.itemName!, item.totalAmount!)
                            let lowerItem = item.itemName?.lowercased()
                            //Dont add these as items
                            if(!lowerItem!.contains("total") && !lowerItem!.contains("debit") && !lowerItem!.contains("cash")) {
                                self.Items.append(item)
                            }
                        }
                        //self.printItems()
                       // self.loadingText.text = "Items:"
                        
                        print("Attempting to Print!")
                        
                        
                        for item in self.Items
                        {
                            //self.outputText.text += item.itemName!
                            //self.outputText.text += "\n"
                            
                            print(item.itemName!)
                        }
                        
                        
                        //Saves item content to local storage
                        //Passes array of Items
                        SaveAllReceiptData(NameOfReceipt: self.recName, Items: self.Items, taxPercent: taxPercent, imageData: self.selectedPhoto)
                        // Close Alert View
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                        {
                                    alert.setSubTitle("Added to Collect")
                                    alert.close()
                        }
                        self.viewDidAppear(false)
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    //Removes the price from the end of an item name
    func trimItemName(itemName: String) -> String {
        var trimmedItemName = itemName
        //Get the last token of the itemName
        var lastToken = ""
        var nonWhiteSpaceEncountered = false
        //Start at the back and make our way forward
        for index in (0...itemName.count-1).reversed() {
            //Get the index of the char we want to look at
            let charIndex = itemName.index(itemName.startIndex, offsetBy: index)
            
            //If we encounter whitespace after non-whitespace, we are done
            if(nonWhiteSpaceEncountered && itemName[charIndex] == " ") {
                break
            }
            
            //If the character is whitespace and we haven't seen non whitespace
            //characters yet, skip this loop
            if(itemName[charIndex] == " " && !nonWhiteSpaceEncountered) {
                trimmedItemName.remove(at: charIndex)
                continue
            }
            
            //If we have encountered non-whitespace for the first time
            //record that we have
            if(itemName[charIndex] != " " && !nonWhiteSpaceEncountered) {
                nonWhiteSpaceEncountered = true
            }
            
            //Add the current char to the beginning of the last token
            lastToken.insert(itemName[charIndex], at: lastToken.startIndex)
            //Remove the char from the trimmed string
            trimmedItemName.remove(at: charIndex)
            
        }
        
        //At this point the last token contains whatever the last token is
        //So now we check if it is a double
        
        //If the last token is a number
        if (Double(lastToken) != nil) {
            //If string is empty, there is no item name, give a default one
            if(trimmedItemName == "") {
                trimmedItemName = "UNKNOWN " + String(numberOfUnknowns)
                //Increment number of unknowns
                numberOfUnknowns += 1
            }
            else {
                //If string is not empty, trim any remaining trailing whitespace
                while(trimmedItemName[trimmedItemName.index(before: trimmedItemName.endIndex)] == " ") {
                    trimmedItemName.removeLast()
                }
            }
            return trimmedItemName
        }
        //If the last token is not a double put it back in the string
        else {
            //Trim any remaining trailing whitespace if string is non empty
            if(trimmedItemName != "") {
                while(trimmedItemName[trimmedItemName.index(before: trimmedItemName.endIndex)] == " ") {
                    trimmedItemName.removeLast()
                }
            }
            //Put the last token back in the string and return it
            trimmedItemName +=  " " + lastToken
            return trimmedItemName
        }
    }
    
    
    var AllReceipts:[Receipt] = []  //Array of receipts
    var receiptToOpen = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up table view
        tableView.delegate = self
        tableView.dataSource = self
        //self.title = "Receipts"
        
        //Fetches data needed to be loaded into table view
        self.FetchData()
        self.tableView.reloadData()
        
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        fixedSpace.width = 35
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.newReceiptButton)), fixedSpace]
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "CollectRed")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let logo = UIImage(named: "Collect Spelled Small 500")
        let imageView = UIImageView(image:logo)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]//, .flexibleTopMargin]
        
        imageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
        imageView.clipsToBounds = true
        //navigationItem.leftBarButtonItems = [fixedSpace]
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-2, for: .default)
        
        let viewRecButton = UIBarButtonItem(image: UIImage(named: "icons8-info-75.png"), style: .plain, target: self, action: Selector(("tutorialPressed")))
        self.navigationItem.leftBarButtonItem = viewRecButton

        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "CollectRed")
        navigationController?.navigationBar.tintColor = UIColor(named: "CollectRed")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if let viewWithTag = self.view.viewWithTag(69) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag2 = self.view.viewWithTag(420) {
            viewWithTag2.removeFromSuperview()
        }
    }
    
    
    var currBool = false
    @objc func tutorialPressed() {
        let imageName = "Shade75"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        imageView.tag = 69
        
        let textImageName = "Tap to add"
        let textImage = UIImage(named: textImageName)
        let textImageView = UIImageView(image: textImage!)
        
        textImageView.frame = CGRect(x: 45, y: 40, width: screenSize.width, height: screenSize.width)
        textImageView.tag = 420
        
        if currBool == false
        {
            currBool = true
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(imageView)
                self.view.addSubview(textImageView)
            }, completion: nil)
            
        }
        else {
            if let viewWithTag = self.view.viewWithTag(69) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag2 = self.view.viewWithTag(420) {
                viewWithTag2.removeFromSuperview()
            }
            currBool = false
        }
        
    }
    
    
    //Override function for passing data from one ViewController to another
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue identifier set at segue properties in toolbar (right side)
        if segue.identifier == "ShowReceiptItems" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //In Storyboard ItemListViewController, there is a global variable titled "receiptname".  This sends the receipt name to the ItemListViewController so it can load the items of that specific receipt
                let controller = segue.destination as! ItemListViewController
                controller.receiptname = AllReceipts[indexPath.row].receiptName!
            }
        }
        if segue.identifier == "AddPeopleVC" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //In Storyboard ItemListViewController, there is a global variable titled "receiptname".  This sends the receipt name to the ItemListViewController so it can load the items of that specific receipt
                let controller = segue.destination as! RecipientsViewController
                controller.receiptName = AllReceipts[indexPath.row].receiptName!
            }
        }
    }
    
    
    //Sets number of sections of the table view
    func SecNum (in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //Sets the number of rows for the table view
    //In this case, the table view will constantly expend, thereby using the array size of the Receipt entity
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(AllReceipts.count)
        return AllReceipts.count
    }
    
    
    //Uses identifier of table view cell (can be set in properties of the cell) to retrieve the data that will be displayed within each row of the table (in this case, its the receipt name)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let oneRecord = AllReceipts[indexPath.row]
        cell.textLabel!.text = oneRecord.receiptName!
        cell.textLabel?.textColor = UIColor.red
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    
    //Function that adds the swipe to delete function to the receipt view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Deletes the data and reloads the entire table view
            DeleteReceiptData(NameOfItem: AllReceipts[indexPath.row].receiptName!)
            viewDidLoad()
        }
    }
    
    
    //Function that fetches all data and inputs it into the table view
    //Must be changed to fetch all non-repeating data (this also implies the need to implement a restriction of not having the same receipt names for multiple receipts)
    func FetchData() {
        //Fetches the specific data
        guard let receiptObj = Receipt.FetchListOfReceipts()
            //If data is not found, returns no data found
            else {
                return
        }
        AllReceipts = receiptObj
    }
    
    
    //Override function to re-fetch data and reload data when the storyboard reappears
    override func viewDidAppear(_ animated: Bool) {
        self.FetchData()
        self.tableView.reloadData()
    }
}
