//
//  GalleryViewController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 26/4/2024.
//
import UIKit

// View controller for displaying the gallery
class GalleryViewController: UIViewController {

    // Reference to the database controller, which conforms to the DatabaseProtocol
    weak var databaseController: DatabaseProtocol?

    // Outlet for the collection view displaying the gallery images
    @IBOutlet weak var galleryImage: UICollectionView!

    // Arrays to store design data and images
    var designData: [Design] = []
    var designImages: [UIImage] = []

    // Variables to store selected design data and image
    var selectedData = Design()
    var selectedImage = UIImage()

    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the collection view layout
        let layout = UICollectionViewFlowLayout()
        galleryImage.collectionViewLayout = layout

        // Get the database controller from the app delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        // Hide the back button in the navigation item
        navigationItem.hidesBackButton = true

        // Retrieve the design data and images from the database
        if let (designs, images) = databaseController?.returnDesigns() {
            designData = designs
            designImages = images
            galleryImage.reloadData()
        }
    }

    // Called when the view is about to appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the tab bar is visible
        tabBarController?.tabBar.isHidden = false
    }
}

// Extension to conform to UICollectionViewDelegate, UICollectionViewDataSource, and UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Return the number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        designData.count
    }

    // Configure the cell for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryImage", for: indexPath) as! GalleryCollectionViewCell
        cell.designImage.image = designImages[indexPath.row]
        cell.designName.text = designData[indexPath.row].name
        cell.layer.cornerRadius = 12.0
        cell.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor(named: "BackgroundColorSecondary")?.cgColor
        return cell
    }

    // Handle item selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedData = designData[indexPath.row]
        selectedImage = designImages[indexPath.row]

        performSegue(withIdentifier: "imageDetailsSegue", sender: self)
    }

    // Set the size for the item at the given index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height / 2
        return CGSize(width: width, height: height)
    }

    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageDetailsSegue", let destination = segue.destination as? GalleryDetailsViewController {
            destination.designData = selectedData
            destination.designImage = selectedImage
        }
    }
}
