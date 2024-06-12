//
//  SignUpViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 26/4/2024.
//
import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // Reference to the database controller, which conforms to the DatabaseProtocol
    weak var databaseController: DatabaseProtocol?
    // Handle for Firebase authentication state listener
    var handle: AuthStateDidChangeListenerHandle?
    
    // Outlets for the sign-up text fields
    @IBOutlet weak var signUpName: UITextField!
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpPass: UITextField!
    @IBOutlet weak var signUpPassConf: UITextField!
    
    // Action for the create account button
    @IBAction func createAccButtonTapped(_ sender: Any) {
        
        // Ensure name is entered
        guard let enteredName = signUpName.text, !enteredName.isEmpty else {
            displayMessage(title: "Name is empty!", message: "Please enter a name")
            return
        }
        
        // Ensure email is entered
        guard let enteredEmail = signUpEmail.text, !enteredEmail.isEmpty else {
            displayMessage(title: "Email is empty!", message: "Please enter an email address")
            return
        }
        
        // Ensure password is entered
        guard let enteredPass = signUpPass.text, !enteredPass.isEmpty else {
            displayMessage(title: "Password is empty!", message: "Please enter a password")
            return
        }
        
        // Ensure password confirmation is entered
        guard let enteredPassConf = signUpPassConf.text, !enteredPassConf.isEmpty else {
            displayMessage(title: "Password confirmation is empty!", message: "Please enter a password")
            return
        }
        
        // Ensure passwords match
        guard let password = signUpPass.text, enteredPass == enteredPassConf else {
            displayMessage(title: "Error!", message: "Passwords do not match!")
            return
        }
        
        // Perform the sign-up asynchronously
        Task {
            let result = try await databaseController?.signup(name: enteredName, email: enteredEmail, password: password)
            
            if result != "Success" {
                displayMessage(title: "Weak Password", message: result!)
            }
        }
    }
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            }
        })
    }
    
    // Called just before the view disappears from the screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the authentication state listener
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // Function to display an alert message to the user
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
