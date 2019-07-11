//
//  ReceiptsViewController.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/10/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class ReceiptsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var AllReceipts:[Receipt] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        self.FetchData()
        self.tableView.reloadData()
    }
    
    //Returns number of sections
    func SecNum (in tableView: UITableView) -> Int {
        return 1
    }
    
    //Returns number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllReceipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let oneRecord = AllReceipts[indexPath.row]
        cell.textLabel!.text = oneRecord.itemName!
        return cell
    }
    
    func FetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            AllReceipts = try context.fetch(Receipt.fetchRequest())
        } catch{
            print(error)
        }
        
        
    }
    
}
