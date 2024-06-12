//
//  ImageData.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 3/5/2024.
//
import UIKit

// Class representing image data, conforming to Decodable for easy decoding
class ImageData: NSObject, Decodable {
    
    // Properties for image URL, width, and height
    var imageURL: String?
    var width: Int?
    var height: Int?
    
    // Enum to specify coding keys for Decodable
    private enum ImageKeys: String, CodingKey {
        case imageURL = "asset_url"
        case width = "width"
        case height = "height"
    }
    
    // Initializer to decode from a decoder
    required init(from decoder: Decoder) throws {
        // Decode the root container using the specified coding keys
        let rootContainer = try decoder.container(keyedBy: ImageKeys.self)
        
        // Decode individual properties from the container
        imageURL = try rootContainer.decode(String.self, forKey: .imageURL)
        width = try rootContainer.decode(Int.self, forKey: .width)
        height = try rootContainer.decode(Int.self, forKey: .height)
    }
}
