//
//  ViewController.swift
//  Todoey
//
//  Created by Yangfan on 2018-06-21.
//  Copyright © 2018 fansaien. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mikes","Buy Eggos","Destroy"]
    private let cellIdentifier = "ToDoItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        print(item)
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
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
            self.itemArray.append(text)
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

