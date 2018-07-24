//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by Bonny Varghese P B on 22/07/18.
//  Copyright © 2018 Bonny Varghese P B. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController {
let items = ["Item 1","Item 2","Item 3","Item 4","Item 5"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoeyCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    


}

