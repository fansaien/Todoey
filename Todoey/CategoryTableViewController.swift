//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Yangfan on 2018-06-26.
//  Copyright © 2018 fansaien. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToitems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToitems" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let destination = segue.destination as! ToDoListViewController
            destination.selectedCategory = categories[(indexPath?.row)!]
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var localTextFiled = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) {
            [unowned self, unowned alert](action) in
            guard let categoryText = alert.textFields?.first?.text, !categoryText.isEmpty else{
                return;
            }
            let category = Category(context: self.context)
//            category.name = categoryText
            category.name = localTextFiled.text
            self.categories.append(category)
            self.saveCategories()
            DispatchQueue.main.async {
                [unowned self] in
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(action)
        alert.addTextField {
            (textFiled) in
            textFiled.placeholder = "Create new category"
            localTextFiled = textFiled
        }
        self.present(alert, animated: true)
    }
    
    //MARK: - load and save entity
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest() ) -> () {
        do {
            categories = try context.fetch(request)
            DispatchQueue.main.async {
                [unowned self] in
                self.tableView.reloadData()
            }
        }catch{
            print(" Load Error = \(error)")
        }
    }
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print(" Load Error = \(error)")
        }
    }
    
}
