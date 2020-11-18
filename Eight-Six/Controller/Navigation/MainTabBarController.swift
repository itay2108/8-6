//
//  MainTabBarController.swift
//  Eight-Six
//
//  Created by itay gervash on 13/11/2020.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        let mainNC = MainNavigationController(rootViewController: MainViewController())
        
        mainNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "square.grid.2x2.fill"), tag: 0)
        
        let secondVC = SecondViewController()
        
        secondVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "arrow.2.circlepath.circle.fill"), tag: 1)
        
        let thirdVC = ThirdViewController()
        
        thirdVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "square.fill.and.line.vertical.and.square"), tag: 1)
        
        self.viewControllers = [mainNC, secondVC, thirdVC]
        
        self.tabBar.tintColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1)
        
    }
    

}
