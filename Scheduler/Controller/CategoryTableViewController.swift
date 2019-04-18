//
//  CategoryTableViewController.swift
//  Scheduler
//
//  Created by George James Manayath on 17/04/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    
    let realm = try! Realm()
    var categories : Results<Category>?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Schedules added yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            let destinationVC = segue.destination as! SchedulerViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    
    
    //MARK: - Data Manipulation Methods

    func save(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
     categories = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }
    
    // MARK: - Add Button


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Schedule", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add Schedule"
        }
        present(alert, animated: true, completion: nil)
        
    }
    

}
