//
//  MainTabController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit


class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
    }

    
    func configureViewControllers(){
        
        
        
        let homeController = HomeController()
        let homeControllerNavBar = templateNavController(image: UIImage(systemName: "car")!, rootViewController: homeController)
        
        let profileController = ProfileController()
        let profileControllerNavBar = templateNavController(image: UIImage(systemName: "person")!, rootViewController: profileController)
        
        let notificationsController = NotificationsController()
        let notificationsControllerNavBar =  templateNavController(image: UIImage(systemName: "bell")!, rootViewController: notificationsController)
        
        let ordersController = OrdersController()
        let ordersControllerNavBar = templateNavController(image: UIImage(systemName: "shippingbox")!, rootViewController: ordersController)
        
        
        viewControllers = [homeControllerNavBar, ordersControllerNavBar, notificationsControllerNavBar ,profileControllerNavBar]
    }
    
    
    func templateNavController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        navController.navigationBar.barTintColor = .white
        navController.navigationBar.barStyle = .black
        return navController
        
    }

}
