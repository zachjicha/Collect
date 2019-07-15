//
//  ViewControllerB.swift
//  Collect
//
//  Created by Norris Chan on 7/14/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

 class ViewControllerB: UIViewController, UITableViewDelegate, UITableViewDataSource, AddName {

    // creates an array for the list of names
    var recipient: [Names] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // displays list
    override func viewDidLoad() {
        
    }
    
    // displays number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipient.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameCell
        
        cell.nameLabel.text = recipient[indexPath.row].names
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addButton = segue.destination as! AddNameController
        addButton.delegate = self
    }
    
    func addName(name: String){
        recipient.append(Names(names2: name))
        tableView.reloadData()
        
    }
    
}

class Names {
    var names = ""
    convenience init(names2: String) {
        self.init()
        self.names = names2
    }
}
