//
//  TableViewController.swift
//  coreDataTodo
//
//  Created by Hari on 29/03/23.
//

import UIKit

class TableViewController: UITableViewController {
    //create a singleton object for core data base
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var models = [ToDoList]()
    override func viewDidLoad() {
        super.viewDidLoad()
       title = "To Do List"
        getallItem()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//tapAction
    @IBAction func tap(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Item",
                                    message: "to add in list", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel,handler: { [weak self]_ in
            guard let f = alert.textFields?.first, let t = f.text, !t.isEmpty else{
                return
            }
            self?.createItem(name: t)
        }))
        present(alert, animated: true)
    }
    
//CoreData
    
    func getallItem(){
        do{
            models = try context.fetch(ToDoList.fetchRequest())
            
            //reloading Data - main threading - because it is a UI Operation
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("Err in getAllItem")
        }
        
    }
    
    func editItem(item:ToDoList,newName: String){
        
        item.name = newName
       
        do{
            try context.save()
            getallItem()
        }
        catch{
            print("Err in Saving Data - editItem")
        }
        
        
    }
    
    func createItem(name : String){
        
        //setting a new obj ready for coreData
        
        let newItem = ToDoList(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        //Saving it in dataCore
        
        do{
            try context.save()
            getallItem()
        }
        catch{
            print("Err in Saving Data - createItem")
        }
        
    }
    
    func deleteItem(item:ToDoList){
        
        context.delete(item)
        
        do{
            try context.save()
            getallItem()
        }
        catch{
            print("Err in Saving Data - deleteItem")
        }
        
        
    }

    // MARK: - Table view data source
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let Curritem = models[indexPath.row]
        let alert = UIAlertController(title: "Update",
                                      message: "Press", preferredStyle: .actionSheet)
       
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Edit", style: .default,handler: { _ in
            
            let inAlert = UIAlertController(title: "rename Item",
                                        message: "to add in list", preferredStyle: .alert)
            inAlert.addTextField(configurationHandler: nil)
            //to prefill the data in the textField
            inAlert.textFields?.first?.text = Curritem.name
            inAlert.addAction(UIAlertAction(title: "Submit", style: .cancel,handler: {[weak self]_ in
                guard let f = inAlert.textFields?.first, let t = f.text, !t.isEmpty else{
                    return
                }
                self?.editItem(item: Curritem, newName: t)
            }))
            self.present(inAlert, animated: true)
            
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: {[weak self] _ in
            self?.deleteItem(item: Curritem)
        }))
        present(alert, animated: true)
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data.name
        // Configure the cell...

        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.deleteItem(item: models[indexPath.row])
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

}
