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
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc func newReceiptButton()
    {
        // Custom alert view
        let alert = SCLAlertView()
        let GetInfo = alert.addTextField("Enter receipt name")
        alert.addButton("Add Receipt") {
            // If field is empty
            if (GetInfo.text == "") {
                print("Please Enter a receipt Name")
                SCLAlertView().showError("Add Error", subTitle: "You must enter a receipt name")
                return
            }
            if (CheckDuplicity(receiptName: GetInfo.text!) == true) {
                print("Data already exists")
                SCLAlertView().showError("Add Error", subTitle: "This receipt name already exists.")
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
        alert.showEdit("Add a Receipt", subTitle: "Either upload from camera roll or take a picture")

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
        // Hide close button
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance).showWait(self.recName, subTitle: "Adding receipt to Collect...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.setSubTitle("Progress: 50%")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alert.setSubTitle("Progress: 80%")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    alert.setSubTitle("Progress: 95%")
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    alert.setSubTitle("Progress: 100%")
                    alert.close()
                    self.viewDidAppear(false)
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
                    //print(json["amounts"])
                    //print(json)
                    
                    //Gets the total amount and the tax amount
                    let totalAmount = json["totalAmount"]["data"].double
                    let taxAmount = json["taxAmount"]["data"].double
                    
                    //Gets the tax percent of the receipt based on totalAmount and taxAmount
                    let taxPercent = Double(taxAmount!)/Double(totalAmount!)
                    
                    //print("TOTAL AMOUNT: \(String(describing: totalAmount))")
                    //print("TAX AMOUNT: \(String(describing: taxAmount))")
                    if let amounts = json["amounts"].array
                        
                    {
                        for JSONItem in amounts
                        {
                            let item = Item(itemName: JSONItem["text"].string, totalAmount: JSONItem["data"].double)
                            // print(item.itemName!, item.totalAmount!)
                            let lowerItem = item.itemName!.lowercased()
                            if(!lowerItem.contains("total") && !lowerItem.contains("debit") && !lowerItem.contains("debit")) {
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
                        SaveAllReceiptData(NameOfReceipt: self.recName, Items: self.Items, taxPercent: taxPercent)
                        self.viewDidAppear(false)
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    var AllReceipts:[Receipt] = []  //Array of receipts
    var receiptToOpen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up table view
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Receipts"
        
        //Fetches data needed to be loaded into table view
        self.FetchData()
        self.tableView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.newReceiptButton))
        
        
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
                let controller = segue.destination as! ViewControllerB
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.FetchData()
        self.tableView.reloadData()
    }
}
