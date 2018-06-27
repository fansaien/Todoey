//
//  ViewController.swift
//  Todoey
//
//  Created by Yangfan on 2018-06-21.
//  Copyright © 2018 fansaien. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let defaultsSavingKey = "TodoListArray" 
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet{
            self.loadItems()
        }
    }
    
    private let cellIdentifier = "ToDoItemCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        print(dataFilePath!)
        
        
//        loadDataFromLocalStorage()
       
        //self.navigationController?.hidesBarsOnTap = true
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
    
    // MARK: - Save to local storage
    func saveToLocal(){
        /*
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print(" Error encoding item error \(error)")
        }
 */
        do{
           try self.context.save()
        }catch{
             print(" Error encoding item error \(error)")
        }
    }
    
    fileprivate func loadDataFromLocalStorage() {
        // Do any additional setup after loading the view, typically from a nib.
        /*
         if let decoded =  defaults.object(forKey: defaultsSavingKey)  as? Data{
         itemArray =  NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Item]
         }
         */
        /*
        let decoder = PropertyListDecoder()
        do{
            let data = try Data(contentsOf: self.dataFilePath!)
            
            let list = try decoder.decode([Item].self, from:data)
            self.itemArray = list
        }catch{
            print("load file error = \(error)")
        }
 */
        self.loadItems(with: Item.fetchRequest())
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        let predicate = NSPredicate(format: "parentCategory.name = %@", self.selectedCategory!.name!)
        if let orignPredicate =  request.predicate {
            let predictCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [orignPredicate,predicate])
            request.predicate = predictCompound
        }else{
            request.predicate = predicate
        }
        do{
            self.itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
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
        saveToLocal()
    }
    
    // MARK: - Add New Items
    
    @IBAction func addNewItems(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            [unowned self, unowned alert] (action) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }
            let item = Item(context: self.context)
            item.title = text
            item.done = false
            item.parentCategory = self.selectedCategory!
            self.itemArray.append(item)
            /*
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.itemArray)
            self.defaults.setValue(encodedData, forKey: self.defaultsSavingKey)
            self.defaults.synchronize()
 */
            // another way to save property object
            self.saveToLocal()
            self.tableView.reloadData()
        }
        alert.addTextField {
            (alertTextFiled) in
            alertTextFiled.placeholder = "Create New Item"
            
            
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    // MARK: - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        if text.isEmpty {
            self.loadDataFromLocalStorage()
            self.tableView.reloadData()
            return
        }
        let reqeust :NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        reqeust.predicate = predicate
        reqeust.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.loadItems(with: reqeust)
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            self.loadDataFromLocalStorage()
            
            DispatchQueue.main.async {
                [unowned self] in
                self.tableView.reloadData()
                searchBar.resignFirstResponder()
            }
 
//            self.tableView.reloadData()
//            searchBar.resignFirstResponder()
            
            return
        }
    }
    
}

