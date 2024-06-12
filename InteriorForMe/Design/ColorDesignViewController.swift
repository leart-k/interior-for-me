//
//  ColorDesignViewController.swift
//  InteriorForMe
//
//  Created by Leart on 2/5/2024.
//
import UIKit

class ColorDesignViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    // Variable to store the selected room
    var selectedRoom: String = ""
    // Array to store the selected colors
    var selectedColors: [UIColor] = []
    // String to store the selected colors in HEX format
    var colorsSelected: String = ""
    
    // Outlet for the color collection view
    @IBOutlet weak var colorCollection: UICollectionView!
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup progress view
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.setProgress(0.5, animated: true) // Set initial progress
        progressView.tintColor = UIColor(named: "MainColor")
        navigationItem.titleView = progressView
        
        // Setup collection view layout
        let layout = UICollectionViewFlowLayout()
        colorCollection.collectionViewLayout = layout
        colorCollection.allowsMultipleSelection = true
    }
    
    // Function to present the color picker
    func presentColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    // Action to continue to the next step
    @IBAction func continueTapped(_ sender: Any) {
        // Ensure at least one color is selected
        guard !selectedColors.isEmpty else {
            displayMessage(title: "A color not selected", message: "Please select up to 5 colors")
            return
        }
        // Convert selected colors to HEX and perform segue
        colorsSelected = convertColorsToHex(colors: selectedColors)
        performSegue(withIdentifier: "styleSegue", sender: self)
    }
}

// Function to convert UIColor array to a comma-separated HEX string
func convertColorsToHex(colors: [UIColor]) -> String {
    let hexStrings = colors.map { color in
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
    return hexStrings.joined(separator: ",")
}

// Extension to conform to UICollectionViewDelegate, UICollectionViewDataSource, and UICollectionViewDelegateFlowLayout
extension ColorDesignViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedColors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            // Configure the color picker cell
            let colorPickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorPicker", for: indexPath)
            colorPickerCell.layer.backgroundColor = UIColor(named: "BackgroundColorSecondary")?.cgColor
            colorPickerCell.layer.cornerRadius = 12.0
            colorPickerCell.layer.masksToBounds = true
            return colorPickerCell
        } else {
            // Configure the color display cell
            let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath) as! ColorCollectionViewCell
            colorCell.colorView.backgroundColor = selectedColors[indexPath.item - 1]
            colorCell.layer.cornerRadius = 12.0
            colorCell.colorView.backgroundColor?.withAlphaComponent(0.3)
            colorCell.removeColor.tag = indexPath.row
            colorCell.removeColor.addTarget(self, action: #selector(removeColorButtonTapped(_:)), for: .touchUpInside)
            return colorCell
        }
    }
    
    // Function to handle removal of a selected color
    @objc func removeColorButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedColors.remove(at: index - 1)
        colorCollection.reloadData()
    }
    
    // Set the size for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        let size = collectionViewSize / 2
        return CGSize(width: size, height: size)
    }
    
    // Handle selection of the color picker item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            presentColorPicker()
        }
    }
    
    // UIColorPickerViewControllerDelegate method to handle color selection
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        if selectedColors.count < 5 {
            if !selectedColors.contains(viewController.selectedColor) {
                selectedColors.append(viewController.selectedColor)
                colorCollection.reloadData()
                viewController.dismiss(animated: true, completion: nil)
            }
        } else {
            displayMessage(title: "Too many colors", message: "Cannot add more than 5 colors!")
        }
    }
    
    // UIColorPickerViewControllerDelegate method to handle when the color picker is dismissed
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        // Any additional actions after the color picker is dismissed can be handled here
    }
    
    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "styleSegue", let destination = segue.destination as? StyleDesignViewController {
            destination.selectedRoom = selectedRoom
            destination.selectedColors = colorsSelected
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
