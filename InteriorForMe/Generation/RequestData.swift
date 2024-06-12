//
//  RequestData.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 3/5/2024.
//
import UIKit

// Class representing request data, conforming to Decodable for easy decoding
class RequestData: NSObject, Decodable {
    
    // Property for an array of image data
    var images: [ImageData]?
    
    // Enum to specify coding keys for Decodable
    private enum CodingKeys: String, CodingKey {
        case images = "data"
    }
}

