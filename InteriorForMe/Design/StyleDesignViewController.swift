//
//  StyleDesignViewController.swift
//  InteriorForMe
//
//  Created by Leart on 2/5/2024.
//
import UIKit

class StyleDesignViewController: UIViewController {
    
    // Array of style names
    var styleNames = ["Modern", "Contemporary", "Minimalist", "Industrial", "Scandinavian", "Transitional", "Bohemian", "Mid-Century Modern", "Modern Farmhouse", "Coastal", "Rustic", "Art Deco", "Asian Zen", "Eclectic"]
    
    // Array of corresponding style images
    var styleImages = ["modern", "contemporary", "minimalist", "industrial", "scandinavian", "transitional", "bohemian", "mid-century modern", "modern farmhouse", "coastal", "rustic", "art deco", "asian zen", "eclectic"]
    
    // Variables to store selected style, room, and colors
    var selectedStyle: String = ""
    var selectedRoom: String = ""
    var selectedColors: String = ""
    
    // Action to continue to the next step
    @IBAction func continueTapped(_ sender: Any) {
        // Ensure a style is selected
        guard !selectedStyle.isEmpty else {
            displayMessage(title: "Style not selected", message: "Please select a design style")
            return
        }
        // Perform segue to the next screen
        performSegue(withIdentifier: "itemsSegue", sender: self)
    }
    
    // Outlet for the collection view
    @IBOutlet weak var designStyle: UICollectionView!
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup progress view
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.setProgress(0.75, animated: true) // Set initial progress
        progressView.tintColor = UIColor(named: "MainColor")
        navigationItem.titleView = progressView
        
        // Setup collection view layout
        let layout = UICollectionViewFlowLayout()
        designStyle.collectionViewLayout = layout
        designStyle.allowsMultipleSelection = false
        designStyle.allowsSelection = true
    }
}

// Extension to conform to UICollectionViewDelegate, UICollectionViewDataSource, and UICollectionViewDelegateFlowLayout
extension StyleDesignViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Return the number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleNames.count
    }
    
    // Configure the cell for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "styleTypeCell", for: indexPath) as! DesignsCollectionViewCell
        
        // Set the image and name for the cell
        cell.designImage.image = UIImage(named: styleImages[indexPath.row])
        cell.designName.text = styleNames[indexPath.row]
        cell.designImage.layer.cornerRadius = 12.0
        cell.designImage.layer.masksToBounds = true
        
        return cell
    }
    
    // Set the size for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
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
            selectedStyle = styleNames[indexPath.row]
        }
    }
    
    // Handle deselection of an item
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DesignsCollectionViewCell {
            cell.designImage.layer.borderWidth = 0
            cell.designImage.layer.borderColor = UIColor.clear.cgColor
            cell.designName.textColor = UIColor.black
            selectedStyle = ""
        }
    }
    
    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemsSegue", let destination = segue.destination as? ItemsDesignViewController {
            destination.selectedStyle = selectedStyle
            destination.selectedRoom = selectedRoom
            destination.selectedColors = selectedColors
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
