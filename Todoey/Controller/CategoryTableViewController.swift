//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Bonny Varghese P B on 28/07/18.
//  Copyright © 2018 Bonny Varghese P B. All rights reserved.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
loadData()
    }
//MARK - Tableview Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "ITEMS", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ITEMS" {
            if let destinationVC = segue.destination as? TodoeyViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow{
                    destinationVC.selectedCategory = self.categoryArray[indexPath.row]
                }
            }
        }
    }
    
//MARK - Add new category
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var txtField = UITextField()
        let alert = UIAlertController.init(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            if (txtField.text?.count)!>0{
                let cat = Category(context: self.context!)
                cat.title = txtField.text!
                self.categoryArray.append(cat)
                self.SaveData()
            }
        }
        alert.addTextField { (tf) in
            txtField = tf
            tf.placeholder = "Enter Category"
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    //MARK - Save Data
    func SaveData(){
        do{
            try self.context?.save()
        }catch{
            print("Error in context:\(error)")
        }
        self.tableView.reloadData()
    }
    //MARK - Load Data
    func loadData(with request:NSFetchRequest<Category>=Category.fetchRequest()){
        do{
            categoryArray = (try context?.fetch(request))!
        }catch{
            print("Error in context:\(error)")
        }
        self.tableView.reloadData()
    }
}
