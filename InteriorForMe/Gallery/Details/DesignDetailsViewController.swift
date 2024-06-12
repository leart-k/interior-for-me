//
//  DesignDetailsViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 5/6/2024.
//
import UIKit

class DesignDetailsViewController: UIViewController {
    
    // Variable to store the design data
    var designData = Design()
    
    // Action to close the design details view
    @IBAction func closeDetails(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // Outlets for the labels and image views
    @IBOutlet weak var roomType: UILabel!
    @IBOutlet weak var prefColors: UILabel!
    @IBOutlet weak var designLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var designStyle: UIImageView!
    @IBOutlet weak var designName: UILabel!
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    // Arrays to store design colors and items
    var designColors: [String]?
    var designItems: [String]?
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add bottom line to labels
        addBottomLine(labelName: roomType)
        addBottomLine(labelName: prefColors)
        addBottomLine(labelName: designLabel)
        addBottomLine(labelName: itemsLabel)
        
        // Set the room image and name
        if let room = UIImage(named: designData.room?.lowercased() ?? "") {
            roomImage.image = room
            roomImage.layer.cornerRadius = 12
        }
        roomName.text = designData.room
        
        // Set the design style image and name
        if let design = UIImage(named: designData.style?.lowercased() ?? "") {
            designStyle.image = design
            designStyle.layer.cornerRadius = 12
        }
        designName.text = designData.style
        
        // Split colors and items into arrays
        designColors = designData.colors?.split(separator: ",").map { String($0) }
        designItems = designData.items?.split(separator: ",").map { String($0) }
    }
    
    // Function to add a bottom line to a label
    func addBottomLine(labelName: UILabel) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: labelName.frame.height - 1, width: labelName.frame.width, height: 1)
        bottomBorder.backgroundColor = UIColor(named: "SecondaryTextColor")?.withAlphaComponent(0.2).cgColor
        labelName.layer.addSublayer(bottomBorder)
    }
}

// Extension to conform to UICollectionViewDataSource, UICollectionViewDelegate, and UICollectionViewDelegateFlowLayout
extension DesignDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Return the number of sections in the collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Return the number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollectionView {
            return designColors?.count ?? 0
        } else if collectionView == itemsCollectionView {
            return designItems?.count ?? 0
        }
        return 0
    }
    
    // Configure the cell for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorDetailsCollectionViewCell
            if let colorHex = designColors?[indexPath.row], let color = UIColor(hex: String(colorHex)) {
                cell.colorCircle.tintColor = color
            }
            return cell
        } else if collectionView == itemsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemDetailsCollectionViewCell
            cell.itemName.text = designItems?[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    // Set the size for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == colorCollectionView {
            return CGSize(width: 50, height: 50)
        } else if collectionView == itemsCollectionView {
            return CGSize(width: collectionView.frame.width, height: 44)
        }
        return CGSize.zero
    }
}

// Extension to UIColor to initialize with a hex string
extension UIColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        guard Scanner(string: hex).scanHexInt64(&int) else { return nil }
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
