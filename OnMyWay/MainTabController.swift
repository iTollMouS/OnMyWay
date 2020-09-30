//
//  MainTabController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit


class MainTabController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
        self.delegate = self
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .black
        
    }

    
    func configureViewControllers(){
        
        let homeController = HomeController()
        let homeControllerNavBar = templateNavController(image: UIImage(systemName: "car")!, rootViewController: homeController, tabBarItemTitle: "Travelers")
        
        let profileController = ProfileController(style: .insetGrouped)
        let profileControllerNavBar = templateNavController(image: UIImage(systemName: "person")!, rootViewController: profileController, tabBarItemTitle: "Profile")
        
        let notificationsController = NotificationsController()
        let notificationsControllerNavBar =  templateNavController(image: UIImage(systemName: "envelope")!, rootViewController: notificationsController, tabBarItemTitle: "Messages")
        
        let ordersController = OrdersController()
        let ordersControllerNavBar = templateNavController(image: UIImage(systemName: "shippingbox")!, rootViewController: ordersController, tabBarItemTitle: "Orders")
        
        viewControllers = [homeControllerNavBar, ordersControllerNavBar, notificationsControllerNavBar ,profileControllerNavBar]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let notificationsController = NotificationsController()
            let navController = UINavigationController(rootViewController: notificationsController)
            navController.modalPresentationStyle = .fullScreen
            navController.navigationBar.barStyle = .black
            navController.navigationBar.isTranslucent = true
            present(navController, animated: true, completion: nil)
            return false
        }
      
        return true
    }
    
    
    func templateNavController(image: UIImage, rootViewController: UIViewController, tabBarItemTitle: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.title = tabBarItemTitle
        navController.navigationBar.barStyle = .black
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }

}
