//
//  ViewController.swift
//  Scheduler
//
//  Created by George James Manayath on 05/04/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit

class SchedulerViewController: UITableViewController {

    var itemArray = [Item]()
   // let defaults = UserDefaults.standard
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        
        print(dataFilePath)
       
        
        loadItems()
        
    //   if let items = defaults.array(forKey: "TodoListArray") as? [Item]
    //  {
    //  itemArray = items
    //  }
    }

    // Tableview Datasource Methods

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
    
    // TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
  
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Schedule", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // when user click add item button on UIalert
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
    
    func saveItem() {
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding item \(error)")
        }
        
        
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
           if let data = try? Data(contentsOf: dataFilePath!)
           {
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding \(error)")
            }
        }
    }
    
        
    }
    



