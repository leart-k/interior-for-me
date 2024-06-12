//
//  GalleryDetailsViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 5/6/2024.
//
import UIKit

// View controller for displaying the details of a design
class GalleryDetailsViewController: UIViewController, UITabBarDelegate {

    // Reference to the database controller, which conforms to the DatabaseProtocol
    weak var databaseController: DatabaseProtocol?

    // Variables to store design data and image
    var designData = Design()
    var designImage = UIImage()

    // Outlets for the tab bar and its items
    @IBOutlet weak var detailsTabBar: UITabBar!
    @IBOutlet weak var detailsButton: UITabBarItem!
    @IBOutlet weak var notesButton: UITabBarItem!
    @IBOutlet weak var deleteButton: UITabBarItem!

    // Outlets for design name label and image view
    @IBOutlet weak var designName: UILabel!
    @IBOutlet weak var image: UIImageView!

    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the design name and image
        designName.text = designData.name
        image.image = designImage

        // Set the tab bar delegate
        detailsTabBar.delegate = self

        // Get the database controller from the app delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        // Add tap gesture recognizer to the image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
    }

    // Handle tab bar item selection
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == detailsButton {
            performSegue(withIdentifier: "detailsSegue", sender: self)
        } else if item == notesButton {
            performSegue(withIdentifier: "notesSegue", sender: self)
        } else if item == deleteButton {
            displayMessage(title: "Caution, deleting design!", message: "This design will be deleted. This action cannot be undone.", deleteHandler: {
                self.deleteDesign(designID: self.designData.id!, designName: self.designData.name!)
            })
        }
    }

    // Function to delete the design
    func deleteDesign(designID: String, designName: String) {
        Task {
            let results = try await databaseController?.deleteDesign(designID: designID, designName: designName)
            if results == true {
                tabBarController?.tabBar.isHidden = false
                navigationController?.popViewController(animated: true)
            } else {
                print("Delete was not completed, please try again!")
            }
        }
    }

    // Handle image tap to show full screen image
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "fullImageSegue", sender: image)
    }

    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue", let destination = segue.destination as? DesignDetailsViewController {
            destination.designData = designData
        } else if segue.identifier == "notesSegue", let destination = segue.destination as? DesignNotesViewController {
            destination.designNotes = designData.notes!
            destination.designName = designData.name!
            destination.designID = designData.id!
        } else if segue.identifier == "gallerySegue", let destination = segue.destination as? GalleryViewController {
            // No additional data to pass
        } else if segue.identifier == "fullImageSegue", let destination = segue.destination as? FullScreenViewController {
            destination.image = designImage
        }
    }

    // Function to display an alert message to the user with an optional delete handler
    func displayMessage(title: String, message: String, deleteHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            deleteHandler?()
        })

        self.present(alertController, animated: true, completion: nil)
    }
}
