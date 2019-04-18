//
//  ViewController.swift
//  Scheduler
//
//  Created by George James Manayath on 05/04/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import CoreData

class SchedulerViewController: UITableViewController{

    var itemArray = [Item]()
   // let defaults = UserDefaults.standard
    
    var selectedCategory : Category?{
        didSet{
           loadItems()
        }
    }
    
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
//       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
 
    }

    //MARK:- Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
         let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
      
        
        return cell 
        
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
  
        //print(itemArray[indexPath.row])
        
//       context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK:- Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // when user click add item button on UIalert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItem()
            
         
            
            }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        }
    
    //MARK:- Save Items
    func saveItem() {
        
     
        
        do{
            try context.save()
        }
        catch{
            print("Error saving item \(error)")
        }
        
        
        self.tableView.reloadData()
        
    }
    
    //MARK:- Load Items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }

        do{
        itemArray = try context.fetch(request)
        }catch{
                print("Error fetching \(error)")
            }
        tableView.reloadData()
        }
}
    //MARK:- Search Bar
    extension SchedulerViewController: UISearchBarDelegate{
        
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate =  NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

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

    



