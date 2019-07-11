//
//  ItemTableView.swift
//  CollectApp
//
//  Created by Brian Thyfault on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class ItemTableView: UIViewController {
    
    var items:[Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeItems()
        
    }
    
    func makeItems() {
        
        for index in 0...5 {
            items.append(Item(itemName: "Hello", itemCost: 25))
        }
        
    }


}


extension ItemTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[IndexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>) as 
    }
    
}
