//
//  ColorCollectionViewCell.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 17/5/2024.
//
import UIKit

// Custom UICollectionViewCell subclass for displaying colors and a remove button
class ColorCollectionViewCell: UICollectionViewCell {
    
    // Outlet for the view that displays the color
    @IBOutlet weak var colorView: UIView!
    // Outlet for the button to remove the color
    @IBOutlet weak var removeColor: UIButton!
}

