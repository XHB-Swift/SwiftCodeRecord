//
//  SwiftCodeRecordApp.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/26.
//

import UIKit

@UIApplicationMain
class SwiftCodeRecordApp: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let main = SCRMainViewController()
        let navigationCtrl = UINavigationController(rootViewController: main)
        window?.rootViewController = navigationCtrl
        window?.makeKeyAndVisible()
        SCRRouter.router.register(pages: [(SCRRouter.SCRRouterPageUnsplash, UNSViewController.self)])
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
}
