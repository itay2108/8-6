//
//  MainNavigationController.swift
//  Eight-Six
//
//  Created by itay gervash on 13/11/2020.
//

import UIKit
import Motion

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.prefersLargeTitles = true
        self.isMotionEnabled = true
        self.motionNavigationTransitionType = .autoReverse(presenting: .none)
    }
    


}
