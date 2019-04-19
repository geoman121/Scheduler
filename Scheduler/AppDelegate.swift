//
//  AppDelegate.swift
//  Scheduler
//
//  Created by George James Manayath on 05/04/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
      //  print(Realm.Configuration.defaultConfiguration.fileURL)
        
       
        do{
            _ = try Realm()
        
    }catch{
            print("error installing new realm, \(error)")
        }
        
        return true
    }

}

