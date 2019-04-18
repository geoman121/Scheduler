//
//  ViewController.swift
//  Scheduler
//
//  Created by George James Manayath on 05/04/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import RealmSwift

class SchedulerViewController: UITableViewController{

    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?{
        didSet{
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
//       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
 
    }

    //MARK:- Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
   
        return cell 
        
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]
        {
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Error saving done \(error)")
            }
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK:- Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // when user click add item button on UIalert
            
            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                }catch{
                    print("Error saving \(error)")
                }
            }
           self.tableView.reloadData()
            
            }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        }
    
    
    //MARK:- Model Manupulation method
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
        }
}
    //MARK:- Search Bar
    extension SchedulerViewController: UISearchBarDelegate{


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        }
 

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0{
                loadItems()

                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }

}





