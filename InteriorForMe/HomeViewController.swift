//
//  HomeViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 26/4/2024.
//
import UIKit

// View controller for the home screen
class HomeViewController: UIViewController {
    
    // Reference to the database controller, which conforms to the DatabaseProtocol
    weak var databaseController: DatabaseProtocol?
    
    // Arrays for design styles, room names, and items
    let designStyles: [String] = [
        "Modern",
        "Mid-century Modern",
        "Scandinavian",
        "Minimalist",
        "Bohemian",
        "Rustic",
        "Traditional",
        "Industrial",
        "Coastal"
    ]
    let roomNames: [String] = [
        "Living Room",
        "Bedroom",
        "Kitchen",
        "Bathroom",
        "Dining Room",
        "Home Office",
        "Balcony"
    ]
    let items: [String] = [
        "Sofa",
        "Armchair",
        "Coffee Table",
        "End Table",
        "TV Stand",
        "Bed",
        "Nightstand",
        "Dresser",
        "Dining Table",
        "Chairs",
        "Refrigerator",
        "Stove",
        "Sink",
        "Cabinet",
        "Toilet",
        "Bathtub",
        "Shower",
        "Rug",
        "Lamp",
        "Curtains",
        "Artwork",
        "Bookshelf",
        "Plant"
    ]
    
    // Variables to store randomly selected room, style, item, and color
    var randomRoom: String = ""
    var randomStyle: String = ""
    var randomItem: String = ""
    var randomColorString: String = ""
    
    // Outlets for user name label, random image view, and count label
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var randomImage: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    // Arrays to store design data and images
    var designData: [Design] = []
    var designImages: [UIImage] = []
    var fullName: String = ""
    
    // Action to generate a random design
    @IBAction func randomDesignGen(_ sender: Any) {
        randomRoom = roomNames.shuffled().first ?? ""
        randomStyle = designStyles.shuffled().first ?? ""
        randomItem = items.shuffled().first ?? ""
        
        let red = Int.random(in: 0..<256)
        let green = Int.random(in: 0..<256)
        let blue = Int.random(in: 0..<256)
        randomColorString = String(format: "#%02X%02X%02X", red, green, blue)
        performSegue(withIdentifier: "randomInteriorGen", sender: self)
    }
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        becomeFirstResponder()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let (designs, images) = databaseController?.returnDesigns() {
            designData = designs
            designImages = images
        }
        
        userName.text = "Welcome!"
        
        let count = designData.count
        countLabel.text = "\(count)"
        if count > 0 {
            let randomNumber = Int.random(in: 0...count-1)
            randomImage.image = designImages[randomNumber]
            randomImage.layer.cornerRadius = 12
        } else {
            randomImage.image = UIImage(named: "EmptyDesign")
        }
    }
    
    // Allow the view controller to become the first responder to receive motion events
    override var canBecomeFirstResponder: Bool {
        return true
    }

    // Handle shake motion to generate a random design
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            randomDesignGen(self)
        }
    }
    
    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "randomInteriorGen", let destination = segue.destination as? APIRequestViewController {
            destination.inputRoom = randomRoom
            destination.inputColor = randomColorString
            destination.inputItems = randomItem
            destination.inputStyle = randomStyle
        }
    }
}
