//
//  InteriorGeneratedViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 3/5/2024.
//
import UIKit

class InteriorGeneratedViewController: UIViewController {
    
    // Reference to the database controller, which conforms to the DatabaseProtocol
    weak var databaseController: DatabaseProtocol?
    
    // Properties to hold image URL and input parameters for the design
    var imageURL: String? = ""
    var inputRoom: String = ""
    var inputColor: String = ""
    var inputStyle: String = ""
    var inputItems: String = ""
    var createdImage: UIImage = UIImage()
    
    // Outlets for the generated image view and design name text field
    @IBOutlet weak var generatedImage: UIImageView!
    @IBOutlet weak var designName: UITextField!
    
    // Action to remove the design
    @IBAction func removeDesign(_ sender: Any) {
        performSegue(withIdentifier: "removeImageSegue", sender: self)
    }
    
    // Action to save the design
    @IBAction func saveDesign(_ sender: Any) {
        // Ensure design name is entered
        guard let enteredName = designName.text, !enteredName.isEmpty else {
            displayMessage(title: "Design Name Empty!", message: "Please enter a design name")
            return
        }
        // Save the design using the database controller
        databaseController?.saveDesign(designName: enteredName, image: createdImage, roomType: inputRoom, designColors: inputColor, designStyle: inputStyle, designItems: inputItems)
        
        // Perform segue to remove the image
        performSegue(withIdentifier: "removeImageSegue", sender: self)
    }
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        tabBarController?.tabBar.isHidden = false
        
        // Get the database controller from the app delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Ensure imageURL is provided
        guard let passedImageURL = imageURL else {
            print("No imageURL provided")
            return
        }
        
        // Download and set the image
        if let url = URL(string: passedImageURL) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    if let image = UIImage(data: data) {
                        self?.createdImage = image
                        DispatchQueue.main.async {
                            self?.generatedImage.image = image
                        }
                    } else {
                        print("Error creating image from data")
                    }
                } else {
                    print("No data received")
                }
            }
            task.resume()
        } else {
            print("Invalid URL")
        }
    }
    
    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveImageSegue", let destination = segue.destination as? GalleryViewController {
            // Add any necessary data transfer here
        } else if segue.identifier == "removeImageSegue", let destination = segue.destination as? HomeViewController {
            // Add any necessary data transfer here
        }
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
