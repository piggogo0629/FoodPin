//
//  AppDelegate.swift
//  FoodPin
//
//  Created by Ollie on 2016/9/18.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 自訂NavigationBar樣式
        // 修改導覽列的背景色
        UINavigationBar.appearance().barTintColor = UIColor(red: 242.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        // 修改導覽列項目＆按鈕項目的顏色
        UINavigationBar.appearance().tintColor = UIColor.white
        
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            let attr = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: barFont
            ]
            
            UINavigationBar.appearance().titleTextAttributes = attr
        }
        
        //變更狀態欄樣式
        //1.IOS允許開發者覆寫preferredStatusStyle方法來控制任一viewController的狀態欄樣式
        //2.也可以從UIApplication的statusBarStyle屬性做全面設定
        //  要關閉預設啟用的「View controller-based status bar appearance」:
        //  專案 -> target -> Info -> 新增Key:View controller-based status bar appearance,Value:NO
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - Core Data stack
    lazy var applicationDocumentDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tutsplus.Core_Data" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelUrl = Bundle.main.url(forResource: "FoodPin", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentDirectory.appendingPathComponent("FoodPin.sqlite")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dic = [String: Any]()
            dic[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dic[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dic[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dic)
            
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error:\(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()

}

