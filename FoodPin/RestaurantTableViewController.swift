//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Ollie on 2016/9/18.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import CoreData


class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Variables
    var restaurant: [Restaurant] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedObjectContext: NSManagedObjectContext!
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    // MARK: - @IBOutlet & @IBAction
    // unwind segue (identifier:"addRestaurant")
    @IBAction func unwindToHomeScreen(_ segue: UIStoryboardSegue) {
        
    }
    
    // MARK: View Property & Func
    override var prefersStatusBarHidden: Bool {
        get{
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //ps.如果有設定LeftBarButtonItem,則預設的backBarButtonItem會消失
        //e.g. controller A -> controller B
        //要修改backBarButtonItem title文字（預設是前一畫面的標題）：所以從 controller A 設定
        //要隱藏backBarButtonItem：self.navigationItem.hideBackButton = true , 從 controller B 設定
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        managedObjectContext = appDelegate.managedObjectContext
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Initialize Fetched Results Controller
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
            restaurant = fetchResultsController.fetchedObjects as! [Restaurant]
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            print(fetchError.userInfo)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        // 先呼叫父類別方法
        super.viewWillAppear(animated)
        // 當滑動時隱藏navigationController的Bar
        navigationController?.hidesBarsOnSwipe = true
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let _indexPath = newIndexPath {
                self.tableView.insertRows(at: [_indexPath], with: .fade)
            }
        case .delete:
            if let _indexPath = indexPath {
                self.tableView.deleteRows(at: [_indexPath], with: .fade)
            }
        case .update:
            if let _indexPath = indexPath {
                self.tableView.reloadRows(at: [_indexPath], with: .fade)
            }
        case .move:
            //If the change type is equal to Move, we remove the row at indexPath and insert a row at newIndexPath to reflect the record's updated position in the fetched results controller's internal data structure.
            if let _indexPath = indexPath {
                self.tableView.deleteRows(at: [_indexPath], with: .fade)
            }
            
            if let _newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [_newIndexPath], with: .fade)
            }
        }
        
        // synchornize array of Restaurant
        restaurant = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurant.count
    }

    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            restaurant.remove(at: indexPath.row)
        }
        
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        cell.nameLabel.text = restaurant[indexPath.row].name
        cell.locationLabel.text = restaurant[indexPath.row].location
        cell.typeLabel.text = restaurant[indexPath.row].type
        cell.thumbnailImageView.image = UIImage(data: restaurant[indexPath.row].image! as Data)
        
        //修改圖案的圓角
        //cell.thumbnailImageView.layer.cornerRadius = 30
        //cell.thumbnailImageView.clipsToBounds = true
        
        if restaurant[indexPath.row].isVisited == true {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    /*
    override func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //建立一個類似動作清單的選單
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //加入動作至選單中
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        optionMenu.addAction(cancelAction)
        
        let callActionHandler = { (action: UIAlertAction) -> Void in
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        let callAction = UIAlertAction(title: "Call" + "0800-123-\(indexPath.row)", style: .default, handler: callActionHandler)
        
        optionMenu.addAction(callAction)
        
        
        let titleText: String = self.restaurantIsVisited[indexPath.row] ? "The new place" : "I've been there"
        
        let isVisitedAction = UIAlertAction(title: titleText, style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction) -> Void in
                    let cell = tableView.cellForRow(at: indexPath)
            
            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] == false ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            
            self.restaurantIsVisited[indexPath.row] = !self.restaurantIsVisited[indexPath.row]
        })
        
        optionMenu.addAction(isVisitedAction)
        
        //呈現選單
        self.present(optionMenu, animated: true, completion: nil)
        //取消列的選取狀態
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //分享按鈕
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: {(rowAction, indexPath) -> Void in
            
            let defaultText = "Just checking in at " + self.restaurant[indexPath.row].name!
            
            if let defaultImage = UIImage(data: self.restaurant[indexPath.row].image! as Data) {
                
                let activityController = UIActivityViewController(activityItems: [defaultText,defaultImage], applicationActivities: nil)
                
                self.present(activityController, animated: true, completion: nil)
            }
        })
        
        //刪除按鈕
        //實作tableView的editActionsForRowAt方法後,此tableview將不再自動產生刪除按鈕,須自行加入
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            //從datasource刪除資料
            //self.restaurant.remove(at: indexPath.row)
            //再將tableView上的Row移除
            //self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            let deleteRestaurant = self.fetchResultsController.object(at: indexPath) as! Restaurant
            
            self.managedObjectContext.delete(deleteRestaurant)
            
            do {
                try self.managedObjectContext.save()
            } catch {
               print(error)
            }
        }
        
        shareAction.backgroundColor = UIColor(colorLiteralRed: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        
        deleteAction.backgroundColor = UIColor.darkGray
        
        return [deleteAction,shareAction]
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
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRestaurantDetail" {
            //方式一
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationViewController =  segue.destination as! RestaurantDetailViewController
                destinationViewController.restaurantForOne = self.restaurant[indexPath.row]
                destinationViewController.managedObjectContext = managedObjectContext
            }
            //方式二
            //let destinationViewController = segue.destination as! RestaurantDetailViewController
            //let cell  = sender as! RestaurantTableViewCell
            //let indexPath = self.tableView.indexPath(for: cell)
            //destinationViewController.restaurantForOne = restaurant[(indexPath?.row)!]
            
        } else if segue.identifier == "addRestaurant" {
            let destinationViewController = segue.destination as! UINavigationController
            if let addController = destinationViewController.topViewController as? AddRestaurantViewController {
                addController.managedObjectContext = managedObjectContext
            }
        }
    }
}
