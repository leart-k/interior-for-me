//
//  DesignNotesViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 5/6/2024.
//
import UIKit

class DesignNotesViewController: UIViewController {
    
    // Reference to the database controller, which conforms to the DatabaseProtocol
    weak var databaseController: DatabaseProtocol?
    
    // Variables to store design notes, name, and ID
    var designNotes: String = ""
    var designName: String = ""
    var designID: String = ""
    
    // Action to close the notes view
    @IBAction func closeNotes(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // Outlets for design name label and notes text view
    @IBOutlet weak var designNameTitle: UILabel!
    @IBOutlet weak var notesField: UITextView!
    
    // Action to save the notes
    @IBAction func saveNotes(_ sender: Any) {
        // Save notes to database and alert user that they have been saved
        Task {
            let status = try await databaseController?.updateNotes(designID: designID, designNotes: notesField.text)
            if status == true {
                displayMessage(title: "Notes Saved", message: "The notes have been saved!")
            }
        }
    }
    
    // Action to discard the notes
    @IBAction func discardNotes(_ sender: Any) {
        notesField.text = ""
    }
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the database controller from the app delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Configure the notes field appearance
        notesField.backgroundColor = UIColor(named: "BackgroundColorSecondary")
        notesField.layer.cornerRadius = 12
        // Set the design name and notes
        designNameTitle.text = designName
        notesField.text = designNotes
    }
    
    // Function to display an alert message to the user
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
