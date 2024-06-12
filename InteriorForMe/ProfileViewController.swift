//
//  ProfileViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 26/4/2024.
//
import UIKit
import FirebaseAuth

// View controller for the user's profile page
class ProfileViewController: UIViewController {
    
    // Reference to the database controller, which conforms to the DatabaseProtocol
    weak var databaseController: DatabaseProtocol?
    
    // Outlets for the segmented control and user information labels
    @IBOutlet weak var themeSegment: UISegmentedControl!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    // Action to switch the theme between light and dark mode
    @IBAction func themeSwitcher(_ sender: Any) {
        let window = UIApplication.shared.windows.first
        if themeSegment.selectedSegmentIndex == 1 {
            window?.overrideUserInterfaceStyle = .dark
            themeSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        } else {
            window?.overrideUserInterfaceStyle = .light
            themeSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        }
    }
    
    // Action to navigate to the references page
    @IBAction func referencesButton(_ sender: Any) {
        performSegue(withIdentifier: "refPageSegue", sender: self)
    }
    
    // Action to sign out the user
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            // Sign-out successful.
            databaseController?.signOutRemoval()
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            // An error occurred while signing out.
            print("Error signing out: \(signOutError)")
        }
    }
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        themeSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        // Retrieve and display user information
        if let (fullName, email) = databaseController?.returnUserInfo() {
            userName.text = fullName
            userEmail.text = email
        }
    }
}

