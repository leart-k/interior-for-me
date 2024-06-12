//
//  LoginViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 26/4/2024.
//
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // Reference to the database controller, which conforms to the DatabaseProtocol
    weak var databaseController: DatabaseProtocol?
    // Handle for Firebase authentication state listener
    var handle: AuthStateDidChangeListenerHandle?
    
    // Outlets for the email and password text fields
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    // Activity indicator to show loading state
    var activityIndicator: UIActivityIndicatorView!
    // Dim view to overlay the screen while loading
    var dimView: UIView!
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the activity indicator and dim view
        setupActivityIndicator()
        
        // Get the database controller from the app delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    // Called just before the view becomes visible to the user
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a state listener to Firebase authentication
        handle = Auth.auth().addStateDidChangeListener({ Auth, user in
            if user != nil {
                self.showLoadingIndicator() // Show loading indicator
                Task {
                    do {
                        // Retrieve designs from the database
                        try await self.databaseController?.retrieveDesigns()
                        // Perform segue to the next screen
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    } catch {
                        // Handle errors
                        print("Error retrieving designs: \(error.localizedDescription)")
                    }
                    self.hideLoadingIndicator() // Hide loading indicator
                }
            }
        })
    }
    
    // Called just before the view disappears from the screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the authentication state listener
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // Action for the login button
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // Ensure email is entered
        guard let enteredEmail = loginEmail.text, !enteredEmail.isEmpty else {
            displayMessage(title: "Email is empty!", message: "Please enter an email address")
            return
        }
        
        // Ensure password is entered
        guard let enteredPass = loginPassword.text, !enteredPass.isEmpty else {
            displayMessage(title: "Password is empty!", message: "Please enter a password")
            return
        }
        
        showLoadingIndicator() // Show loading indicator
        
        Task {
            do {
                // Attempt to login with the provided credentials
                let result = try await databaseController?.login(email: enteredEmail, password: enteredPass)
                
                // Check if login was successful
                if (result != "Success") {
                    displayMessage(title: "An error has occurred", message: result!)
                }
            } catch {
                // Handle errors
                displayMessage(title: "An error has occurred", message: error.localizedDescription)
            }
            
            hideLoadingIndicator() // Hide loading indicator
        }
    }
    
    // Setup the activity indicator and dim view
    func setupActivityIndicator() {
        // Create a dim view to cover the entire screen
        dimView = UIView(frame: self.view.bounds)
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimView.isHidden = true
        
        // Create and configure the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        // Add the dim view and activity indicator to the main view
        self.view.addSubview(dimView)
        self.view.addSubview(activityIndicator)
    }
    
    // Show the loading indicator
    func showLoadingIndicator() {
        dimView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    // Hide the loading indicator
    func hideLoadingIndicator() {
        dimView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // Display an alert message to the user
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
