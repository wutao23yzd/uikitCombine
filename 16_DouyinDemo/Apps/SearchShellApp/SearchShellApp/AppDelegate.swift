//
//  AppDelegate.swift
//  SearchShellApp
//
//  Created by admin on 2025/12/4.
//

import UIKit
import AWELaunchKit
import AWEInfra
import AWESearch
import AWEUITheme

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    private func setupBootTasks() {
        registerUIThemeBootTasks()
        registerInfraBootTasks()
        registerSearchBootTasks(useMockService: true)
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
        guard let searchEntry = ServiceRegistry.shared.resolve(SearchEntryProtocol.self) else {
            fatalError("SearchEntryProtocol not registered")
        }
        let vc = searchEntry.makeSearchViewController()
        let nav = AWENavigationController(rootViewController: vc)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }


}

