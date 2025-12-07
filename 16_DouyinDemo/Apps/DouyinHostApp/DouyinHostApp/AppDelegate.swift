//
//  AppDelegate.swift
//  DouyinHostApp
//
//  Created by admin on 2025/12/4.
//

import UIKit
import AWELaunchKit
import AWEInfra
import AWESearch
import AWEFeed
import AWEUITheme

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private func setupBootTasks() {
        registerUIThemeBootTasks()
        registerInfraBootTasks()
        registerSearchBootTasks(useMockService: false)
        registerFeedBootTasks(useMockService: false)
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        setupBootTasks()
        
        LaunchKit.run(phase: .infra) {
            LaunchKit.run(phase: .bizRegister) {
                self.setupRootUI()
            }
        }
        
        return true
    }
    
    private func setupRootUI() {
        guard let feedEntry = ServiceRegistry.shared.resolve(FeedEntryProtocol.self) else {
            fatalError("FeedEntryProtocol not registered")
        }
        let root = feedEntry.makeRootViewController()
        let nav = AWENavigationController(rootViewController: root)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}

