//
//  AppDelegate.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-07.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.register(defaults: ["PhotoFeedURLString": "https://api.flickr.com/services/feeds/photos_public.gne?tags=kitten&format=json&nojsoncallback=1"])
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
        let urlString = UserDefaults.standard.string(forKey: "PhotoFeedURLString")
        print(urlString as Any)
        
        
        guard let foundURLString = urlString else {
            return
        }
        
        if let url = NSURL(string: foundURLString) {
            self.updateFeed(url: url, completion: { (feed) -> Void in
                let viewController = application.windows[0].rootViewController as? ImageFeedTableViewController
                viewController?.feed = feed
            })
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func updateFeed(url: NSURL, completion: @escaping (_ feed: Feed?) -> Void) {
        let request = NSURLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error == nil && data != nil {
                let feed = Feed(data: data! as NSData, sourceURL: url)
                OperationQueue.main.addOperation({ () -> Void in
                    completion(feed)
                })
            }

        }
        
        task.resume()
    }

    

}

