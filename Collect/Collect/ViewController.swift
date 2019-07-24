//
//  ViewController.swift
//  CollectApp
//
//  Created by Rizzian Tuazon on 7/2/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

//Import buildin APIs
import UIKit
import CoreData

//Import External APIs
import Alamofire
import SwiftyJSON

struct Item : Codable
{
    let itemName : String?
    let totalAmount: Double?
}



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedPhoto:UIImage!
    var Items : [Item] = []
    
    @IBOutlet weak var outputText: UITextView!
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    
    //Creates variable/ref for container (Data Storage management)
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Receipts"
        outputText.text = ""
        loadingText.text = "Please add a receipt"
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    //Display an action menu to select from camera or camera roll
    @IBAction func addReceipt(_ sender: Any) {
        
        //Ensures that a receipt name is inputted
        if (GetInfo.text == "") {
            print("Please Enter a receipt Name")
            ReceiptNameRequiredAlert()
            return
        }
        
        //Checks to see if the receipt name entered already exists within the core database
        //If it does already exist, tells the user to input a new name
        if (CheckDuplicity(receiptName: GetInfo.text!) == true) {
            print("Data already exists")
            DuplicityAlert()
            return
        }
        
        
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Get the image from the picker controller and set it to the selected photo
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedPhoto = image
        
        //Parse the receipt
        self.parseReceipt()
        
        //Dismiss the picker controller
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Parse the receipt using Harsh's code
    func parseReceipt() {
        
        print("IN API CALL")
        self.outputText.text = ""
        self.loadingText.text = "Analyzing..."
        
        showInputDialog()
        
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
                        self.loadingText.text = "Items:"
                        
                        print("Attempting to Print!")
                        
                        
                        for item in self.Items
                        {
                            self.outputText.text += item.itemName!
                            self.outputText.text += "\n"
                            
                            print(item.itemName!)
                        }

                        
                        //Saves item content to local storage
                        //Passes array of Items
                        //SaveAllReceiptData(NameOfReceipt: self.GetInfo.text!, Items: self.Items, taxPercent: taxPercent)
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    
    //Function that makes a dialog box pop up to ask for Receipt Name
    //TEMPORARY (TEST FNCTION)
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter details?", message: "Enter Receipt Name", preferredStyle: .alert)
        
        //Processes user input from dialog box
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            
            //Updates label (checks for data save state)
            self.labelMessage.text = "Name: " + name!
            
        }
        
        //Cancel button - makes popup disappear (glorified do nothing button)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Receipt Name"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //Make the dialog box appear
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Function that makes an alert pop up saying the receipt name already exists
    func DuplicityAlert() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Receipt Name Error", message: "The receipt name entered already exists", preferredStyle: .alert)
        
        //Cancel button - makes popup disappear (glorified do nothing button)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(cancelAction)
        
        //Make the dialog box appear
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Function that makes an alert pop up saying the a receipt name is required
    func ReceiptNameRequiredAlert() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Receipt Name Error", message: "A receipt name must be entered before proceeding", preferredStyle: .alert)
        
        //Cancel button - makes popup disappear (glorified do nothing button)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(cancelAction)
        
        //Make the dialog box appear
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //Button that triggers Dialog box input
    @IBAction func ChangeReceiptName(_ sender: UIButton) {
        showInputDialog()
    }
    
    
    @IBOutlet weak var GetInfo: UITextField!
    @IBOutlet weak var LoadChange: UILabel!
    
    
    //Pressing the button will load the data
    @IBAction func LoadTextData(_ sender: UIButton) {
        
        //Fetches the specific data
        guard let item = Receipt.FetchData(with: GetInfo.text!)
            //If data is not found, returns no data found
            else {
                self.LoadChange.text = "No Data Found"
                return
        }
        self.LoadChange.text = item.receiptName!
    }
    
    //Pressing the button prints the text field onto Xcode command line
    @IBAction func SaveTextData(_ sender: UIButton) {
        SaveReceiptData(NameOfReceipt: GetInfo.text!)
    }
    
    //Pressing the button will delete the data in text field from core data
    @IBAction func DeleteTextData(_ sender: UIButton) {
        DeleteReceiptData(NameOfItem: GetInfo.text!)
    }
    
    @IBOutlet weak var ItemDataText: UITextField!
    
    @IBAction func AddToReceipt(_ sender: UIButton) {
        //context variable (use for fetching and storing data)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let NameOfReceipt = Receipt(context: context)
        NameOfReceipt.receiptName = GetInfo.text!
        let itemInReceipt = ReceiptItems(context: context)
        itemInReceipt.itemName = ItemDataText.text!
        NameOfReceipt.addToItemsOnReceipt(itemInReceipt)
    }
    
    
    
    
    
}



