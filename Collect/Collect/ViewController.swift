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
    
    //Creates variable/ref for container (Data Storage management)
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Receipts"
        outputText.text = ""
        loadingText.text = "Please add a receipt"
    }

    //Display an action menu to select from camera or camera roll
    @IBAction func addReceipt(_ sender: Any) {

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
                    // print(json["amounts"])
                    if let amounts = json["amounts"].array
                    {
                        for JSONItem in amounts
                        {
                            let item = Item(itemName: JSONItem["text"].string, totalAmount: JSONItem["data"].double)
                            // print(item.itemName!, item.totalAmount!)
                            self.Items.append(item)
                        }
                        //self.printItems()
                        self.loadingText.text = "Items:"
                        
                        print("Attempting to Print!")
                        
                        
                        for item in self.Items
                        {
                            self.outputText.text += item.itemName!
                            self.outputText.text += "\n"
                            
                            print(item.itemName!);
                            self.SaveReceiptData(NameOfItem: item.itemName!/*, ItemCost: 1*/)
                            print("Output Printed!")
                        }
                    }

                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    
    //Function for saving data using core data
    func SaveReceiptData (NameOfItem: String/*, ItemCost: Double*/) {
        
        //Creates variable for Container access
        let CreateReceipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: context)
        CreateReceipt.setValue(NameOfItem, forKey: "itemName")
        
        //save to container/core data
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
        
        
    


}
