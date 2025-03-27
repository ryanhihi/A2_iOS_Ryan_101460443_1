//
//  ProductListTableViewController.swift
//  A2_iOS_Ryan_101460443_1
//
//  Created by Christian Aiden on 2025-03-27.
//

import UIKit
import CoreData

class ProductListTableViewController: UITableViewController {
    
    // Context for Core Data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Array to store products
        var products: [Product]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Fetch products
    private func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Failed to fetch products: \(error.localizedDescription)")
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products?.count ?? 0    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)

        // Configure the cell...
        if let product = products?[indexPath.row] {
            cell.textLabel?.text = product.name
            cell.detailTextLabel?.text = """
                    ID: \(product.productID?.uuidString ?? "N/A")
                    Description: \(product.desc ?? "No details to show")
                    Price: $\(String(format: "%.2f", product.price))
                    Provider: \(product.provider ?? "N/A")
                    """
                }
                
                return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //edit product
    private func updateProduct(product: Product, with newName: String, newDesc: String, newPrice: Double, newProvider: String) {
        
        let indexPath = IndexPath(row: products?.firstIndex(of: product) ?? 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)

        product.name = newName
        product.desc = newDesc
        product.price = newPrice
        product.provider = newProvider
        
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Failed to update task: \(error.localizedDescription)")
        }
    }

    
    //delete function /delete function
    private func deleteProduct(at indexPath: IndexPath) {
        
        if let productToDelete = products?[indexPath.row] {
            context.delete(productToDelete)
            
            do {
                try context.save()
                products?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Failed to delete task: \(error.localizedDescription)")
            }
        }
    }
    
    //Swipe to delete or update
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteProduct(at: indexPath)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") {
            _, indexPath in self.presentEditDialog(for: indexPath)
            
        }
        
        editAction.backgroundColor = .systemBlue
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            _, indexPath in self.deleteProduct(at: indexPath)
        }
        
        return [editAction, deleteAction]
        
        
        
    }
    
    private func presentEditDialog(for indexPath: IndexPath) {
        guard let product = products?[indexPath.row] else {return}
        
        let alert = UIAlertController(title: "Edit Product", message: "Update Product", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = product.name
        }
        alert.addTextField { textField in
            textField.text = product.desc
        }
        alert.addTextField { textField in
            textField.text = String(format: "%.2f", product.price)
        }
        alert.addTextField { textField in
            textField.text = product.provider
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let newName = alert.textFields?[0].text,
               let newDesc = alert.textFields?[1].text,
               let priceText = alert.textFields?[2].text,
               let newProvider = alert.textFields?[3].text,
               let newPrice = Double(priceText) {
                self.updateProduct(product: product, with: newName, newDesc: newDesc, newPrice: newPrice, newProvider: newProvider)
            }
        }
        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
    }
}

