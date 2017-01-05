//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Ollie on 2016/9/23.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import CoreData

class RestaurantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables
    var restaurantForOne: Restaurant!
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - @IBOutlet & @IBAction
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBAction func close(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? ReviewViewController {
            if let rating = sourceViewController.rating {
                ratingButton.setImage(UIImage(named: rating), for: UIControlState.normal)
                
                restaurantForOne.rating = rating
                
                // update managedObject
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: View Property & Func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantImageView.image = UIImage(data: restaurantForOne.image! as Data)
        
        tableView.backgroundColor = UIColor(red: 228.0/255.0, green: 241.0/255.0, blue: 254.0/255.0, alpha: 1)
        // 隱藏多於分隔線
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor  = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        self.title = restaurantForOne.name
        
        //Self Sizing Cells
        self.tableView.estimatedRowHeight = 36.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
        // 明確告訴App不要隱藏導覽列
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - tableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        // 將cell背景色變成透明
        cell.backgroundColor = UIColor.clear
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurantForOne.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurantForOne.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurantForOne.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurantForOne.phoneNumber
        case 4:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = restaurantForOne.isVisited ? "Yes, I've been here before" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }

        return cell
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurantForOne
        }
    }
    
}
