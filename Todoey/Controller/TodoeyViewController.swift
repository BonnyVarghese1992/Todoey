//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by Bonny Varghese P B on 22/07/18.
//  Copyright © 2018 Bonny Varghese P B. All rights reserved.
//

import UIKit
import CoreData
class TodoeyViewController: UITableViewController {
var itemArray = [Item]()
    var selectedCategory:Category?{
        didSet{
            let request:NSFetchRequest<Item>=Item.fetchRequest()
            request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
            self.loadData(with: request)
        }
    }
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        DispatchQueue.global().async {
        self.saveData()
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            self.context?.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
           DispatchQueue.global().async {
            self.saveData()
            }
        }
    }
    //MARK - Barbutton Action
    @IBAction func AddButtonPushed(_ sender: UIBarButtonItem) {
        var txtField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //When add item tapped
            if (txtField.text?.count)!>0{
                let ite = Item(context: self.context!)
                ite.title = txtField.text!
                ite.done = false
                ite.parentCategory = self.selectedCategory
                self.itemArray.append(ite)
                DispatchQueue.global().async {
                self.saveData()
                    let request:NSFetchRequest<Item>=Item.fetchRequest()
                    request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
                    self.loadData(with: request)
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            txtField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
//MARK - Save data into coredata
    func saveData(){
        do{
            try context?.save()
        }
        catch{
            print("Error in context :\(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //MARK - load data
    func loadData(with request:NSFetchRequest<Item> ,predicate:NSPredicate? = nil){
        do{
            let categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES %@", (selectedCategory?.title)!)
            if let additionalPredicate = predicate{
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
            }
            else{
                request.predicate = categoryPredicate
            }
            
            itemArray = (try context?.fetch(request))!
        }
        catch{
            print("Error in context :\(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
       
    }
}
extension TodoeyViewController:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       self.view.endEditing(true)
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        self.loadData(with: request)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request ,predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            DispatchQueue.global().async {
                let request:NSFetchRequest<Item>=Item.fetchRequest()
                request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
                self.loadData(with: request)
            }        }
        else{
            let request:NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadData(with: request,predicate:predicate )
        }
    }
}
