//
//  ItemsDesignViewController.swift
//  InteriorForMe
//
//  Created by Leart on 2/5/2024.
//
import UIKit

class ItemsDesignViewController: UIViewController {
    
    // Variables to store selected room, colors, style, and items
    var selectedRoom: String = ""
    var selectedColors: String = ""
    var selectedStyle: String = ""
    var selectedItems: String = ""
    
    // Array of possible design items
    let designItems = ["Sofa", "Coffee Table", "Armchair", "TV", "TV Stand", "Bookshelf", "Dining Table", "Dining Chairs", "Bed", "Nightstand", "Dresser", "Wardrobe", "Desk", "Office Chair", "Books", "Lamp", "Chandelier", "Rug", "Curtains", "Blinds", "Mirror", "Painting", "Clock", "Fireplace", "Cushions", "Throw Blanket", "Plant", "Flower Vase", "Orchid", "Cactus", "Books", "Wall Art", "Side Table", "Armchair", "Bench", "Pouf", "Wall Shelves", "Floor Lamp", "Picture Frames", "Decorative Bowl"]
    
    // Array to store the indices of currently selected items
    var currSelectedItems: [Int] = []
    
    // Action to create the interior design
    @IBAction func createInterior(_ sender: Any) {
        // Convert selected item indices to a comma-separated string of item names
        selectedItems = currSelectedItems.map { designItems[$0] }.joined(separator: ",")
        // Perform segue to the next screen
        performSegue(withIdentifier: "createInteriorSegue", sender: self)
    }
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup progress view
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.setProgress(1, animated: true) // Set initial progress
        progressView.tintColor = UIColor(named: "MainColor")
        navigationItem.titleView = progressView
    }
}

// Extension to conform to UITableViewDelegate and UITableViewDataSource
extension ItemsDesignViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return the number of rows in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return designItems.count
    }
    
    // Configure the cell for the row at the given index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")
        cell?.textLabel?.text = designItems[indexPath.row]
        // Set accessory type and text color based on selection state
        cell?.accessoryType = self.currSelectedItems.contains(indexPath.row) ? .checkmark : .disclosureIndicator
        cell?.textLabel?.textColor = self.currSelectedItems.contains(indexPath.row) ? UIColor(named: "MainColor") : UIColor.label
        return cell!
    }
    
    // Handle selection of a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currSelectedItems.contains(indexPath.row) {
            // If the item is already selected, remove it from the selected items
            let index = self.currSelectedItems.firstIndex(of: indexPath.row)
            self.currSelectedItems.remove(at: index!)
        } else {
            // If the item is not selected, add it to the selected items
            self.currSelectedItems.append(indexPath.row)
        }
        // Reload the table view to update the selection state
        tableView.reloadData()
    }
    
    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createInteriorSegue", let destination = segue.destination as? APIRequestViewController {
            destination.inputRoom = selectedRoom
            destination.inputColor = selectedColors
            destination.inputStyle = selectedStyle
            destination.inputItems = selectedItems
        }
    }
}
