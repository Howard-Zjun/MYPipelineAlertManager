//
//  AppDelegate.swift
//  MYPipelineAlertManager
//
//  Created by ios on 2025/1/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var nav1: UINavigationController = {
        let nav = UINavigationController(rootViewController: ViewController())
        nav.tabBarItem.title = "页面1"
        return nav
    }()
    
    lazy var nav2: UINavigationController = {
        let nav = UINavigationController(rootViewController: ViewController())
        nav.tabBarItem.title = "页面2"
        return nav
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = UITabBarController()
        mainVC.viewControllers = [nav1, nav2]
        window.rootViewController = mainVC
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

