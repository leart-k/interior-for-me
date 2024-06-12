//
//  TabBarController.swift
//  InteriorForMe
//
//  Created by Leart on 1/5/2024.
//
import UIKit

// Custom UITabBarController subclass
class TabBarController: UITabBarController {
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back button in the navigation item
        navigationItem.hidesBackButton = true
    }
}
