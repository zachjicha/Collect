//
//  DebtsView.swift
//  CollectApp
//
//  Created by Brian Thyfault on 7/15/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class DebtsView: UIViewController {
    
    var receiptItems:[ReceiptItem] = []
    var groupOfNames:[String] = []
    var costPerPerson:[Double] = []
    var output:String = ""

    @IBOutlet weak var outputText: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...groupOfNames.count-1 {
            costPerPerson.append(0)
        }
        
        split()
        // Do any additional setup after loading the view.
        for (index, name) in groupOfNames.enumerated() {
            output += name
            output += ": "
            output += String(costPerPerson[index])
            output += "\n"
        }
        outputText.text = output
    }
    
    func split() {
        for item in receiptItems {
            let cost = item.itemCost/Double(item.itemSplitters!.count)
            for splitter in item.itemSplitters! {
                costPerPerson[groupOfNames.firstIndex(of: splitter)!] += cost
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
