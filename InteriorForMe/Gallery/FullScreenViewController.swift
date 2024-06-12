//
//  FullScreenViewController.swift
//  InteriorForMe
//
//  Created by Leart on 8/6/2024.
//
import UIKit

class FullScreenViewController: UIViewController, UIScrollViewDelegate {
    
    // Variable to store the image to be displayed
    var image: UIImage = UIImage()
    
    // Outlets for the scroll view and the image view
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullImage: UIImageView!
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the image for the image view
        fullImage.image = image
        
        // Configure the scroll view
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        // Enable zooming
        scrollView.addSubview(fullImage)
        scrollView.contentSize = fullImage.frame.size
    }
    
    // Delegate method to allow zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImage
    }
}
