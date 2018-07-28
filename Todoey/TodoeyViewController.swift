//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by Bonny Varghese P B on 22/07/18.
//  Copyright © 2018 Bonny Varghese P B. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController {
var itemArray = [Item]()
    let documentFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemPlist.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()
    }
    
    //MARK - Tableview delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoeyCell", for: indexPath)
        let ite = itemArray[indexPath.row]
        cell.textLabel?.text = ite.title
        cell.accessoryType = ite.done ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ite = itemArray[indexPath.row]
        ite.done = !ite.done
        SaveData()
    }
    
    //MARK - Barbutton Action
    @IBAction func AddButtonPushed(_ sender: UIBarButtonItem) {
        var txtField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //When add item tapped
            if (txtField.text?.count)!>0{
                let ite = Item()
                ite.title = txtField.text!
                self.itemArray.append(ite)
                self.SaveData()
                
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            txtField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
//MARK - SAVE ITEM ENCODE
    func SaveData(){
        let encoder = PropertyListEncoder()
        do{
        let data = try encoder.encode(self.itemArray)
        try data.write(to: documentFilePath!)
        }
        catch{
            
        }
        self.tableView.reloadData()
    }
    //MARK - LOAD ITEM USING DECODE
    func LoadData(){
        if let data = try? Data.init(contentsOf: documentFilePath!){
            let decoder = PropertyListDecoder()
            do{
                self.itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                
            }
        }
        self.tableView.reloadData()
    }
}

