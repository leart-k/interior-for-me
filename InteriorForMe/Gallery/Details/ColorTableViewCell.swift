//
//  ColorTableViewCell.swift
//  InteriorForMe
//
//  Created by Leart on 7/6/2024.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
