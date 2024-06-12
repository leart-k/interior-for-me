//
//  RoomDesignViewController.swift
//  InteriorForMe
//
//  Created by Leart on 2/5/2024.
//
import UIKit

class RoomDesignViewController: UIViewController {
    
    // Array of room names
    var roomNames: [String] = ["Living Room", "Bedroom", "Kitchen", "Bathroom", "Dining Room", "Home Office", "Balcony", "Kids Room", "Her Room", "His Room"]
    // Array of corresponding room images
    var roomImages: [String] = ["living room", "bedroom", "kitchen", "bathroom", "dining room", "home office", "balcony", "kids room", "her room", "his room"]
    // Variable to store the selected room
    var selectedRoom: String = ""
    
    // Action to continue to the next step
    @IBAction func continueTapped(_ sender: Any) {
        // Ensure a room is selected
        guard !selectedRoom.isEmpty else {
            displayMessage(title: "Room not selected", message: "Please select a room type")
            return
        }
        // Perform segue to the next screen
        performSegue(withIdentifier: "colorSegue", sender: self)
    }
    
    // Outlet for the collection view
    @IBOutlet weak var roomTypes: UICollectionView!
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup progress view
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.setProgress(0.25, animated: true) // Set initial progress
        progressView.tintColor = UIColor(named: "MainColor")
        navigationItem.hidesBackButton = true
        navigationItem.titleView = progressView
        
        // Setup collection view layout
        let layout = UICollectionViewFlowLayout()
        roomTypes.collectionViewLayout = layout
        roomTypes.allowsMultipleSelection = false
    }
}

// Extension to conform to UICollectionViewDelegate, UICollectionViewDataSource, and UICollectionViewDelegateFlowLayout
extension RoomDesignViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Return the number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomNames.count
    }
    
    // Configure the cell for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roomTypeCell", for: indexPath) as! DesignsCollectionViewCell
        
        // Set the image and name for the cell
        cell.designImage.image = UIImage(named: roomImages[indexPath.row])
        cell.designName.text = roomNames[indexPath.row]
        
        cell.designImage.layer.cornerRadius = 12.0
        cell.designImage.layer.masksToBounds = true
        return cell
    }
    
    // Set the size for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        let size = collectionViewSize / 2
        return CGSize(width: size, height: size)
    }
    
    // Handle selection of an item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DesignsCollectionViewCell {
            cell.designImage.layer.borderWidth = 3
            cell.designImage.layer.borderColor = UIColor(named: "MainColor")?.cgColor
            cell.designName.textColor = UIColor(named: "MainColor")
            selectedRoom = roomNames[indexPath.row]
        }
    }
    
    // Handle deselection of an item
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DesignsCollectionViewCell {
            cell.designImage.layer.borderWidth = 0
            cell.designImage.layer.borderColor = UIColor.clear.cgColor
            cell.designName.textColor = UIColor.black
            selectedRoom = ""
        }
    }
    
    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorSegue", let destination = segue.destination as? ColorDesignViewController {
            destination.selectedRoom = selectedRoom
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
