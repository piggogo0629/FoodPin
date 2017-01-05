//
//  AddRestaurantViewController.swift
//  FoodPin
//
//  Created by Ollie on 2016/10/12.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import CoreData

class AddRestaurantViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Variables
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedObjectContext: NSManagedObjectContext!
    var restaurant: Restaurant!
    var isVisited: Bool = false
    
    // MARK: - @IBOutlet & @IBAction
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!

    @IBAction func changeButtonState(_ sender: UIButton) {
        if sender.restorationIdentifier == "yesButton" {
            isVisited = true
            yesButton.backgroundColor = UIColor.red
            noButton.backgroundColor  = UIColor.darkGray
        } else {
            isVisited = false
            yesButton.backgroundColor = UIColor.darkGray
            noButton.backgroundColor  = UIColor.red
        }
    }
    
    @IBAction func saveNewRestaurant() {
        
        var alertMessage = ""
        
        if nameTextField.text == "" {
            alertMessage += "Please enter restaurant name.\n"
        }
        if typeTextField.text == "" {
            alertMessage += "Please enter restaurant type.\n"
        }
        if locationTextField.text == "" {
            alertMessage += "Please enter restaurant location."
        }
        
        if alertMessage != "" {
            let alert = UIAlertController(title: "Notice", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            // 儲存至Core Data
            // Create Entity
            let entityDescription = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedObjectContext)
            // Initialize Restaurant
            restaurant = NSManagedObject(entity: entityDescription!, insertInto: managedObjectContext) as! Restaurant
            
            //restaurant.setValue(nameTextField.text!, forKey: "name")
            restaurant.name = nameTextField.text!
            restaurant.type = typeTextField.text!
            restaurant.location = locationTextField.text!
            restaurant.phoneNumber = phoneNumberTextField.text!
            restaurant.isVisited = isVisited
            
            if let restaurantImage = imageView.image {
                let imageData = UIImagePNGRepresentation(restaurantImage) as NSData?
                restaurant.image = imageData
            }
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
            
            // 返回主畫面
            // 方式1:藉由unwind segue
            self.performSegue(withIdentifier: "unwindToHomeScreen", sender: nil)
            // 方式2
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: View Property & Func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
       
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        //設定預設約束條件 & Active it
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: imageView.superview, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: imageView.superview, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: imageView.superview, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        leadingConstraint.isActive  = true
        trailingConstraint.isActive = true
        topConstraint.isActive      = true
        bottomConstraint.isActive   = true
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
            
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            return
        }
    }
    
    // MARK: - User Defined Method

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
