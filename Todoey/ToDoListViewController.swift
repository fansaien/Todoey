//
//  ViewController.swift
//  Todoey
//
//  Created by Yangfan on 2018-06-21.
//  Copyright © 2018 fansaien. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let defaultsSavingKey = "TodoListArray"
    
    private let cellIdentifier = "ToDoItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let decoded =  defaults.object(forKey: defaultsSavingKey)  as? Data{
            itemArray =  NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Item]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDatasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        print(item)
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            item.done = true
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            item.done = false
        }
    }
    
    // MARK: - Add New Items
    
    @IBAction func addNewItems(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            [unowned self, unowned alert] (action) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }
            self.itemArray.append(Item(title: text))
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.itemArray)
            self.defaults.setValue(encodedData, forKey: self.defaultsSavingKey)
            self.defaults.synchronize()
            self.tableView.reloadData()
        }
        alert.addTextField {
            (alertTextFiled) in
            alertTextFiled.placeholder = "Create New Item"
            
            
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}

