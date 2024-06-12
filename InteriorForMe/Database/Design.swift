//
//  Design.swift
//  InteriorForMe
//
//  Created by Leart on 23/5/2024.
//
import UIKit
import FirebaseFirestoreSwift

// Design class conforming to Codable for easy serialization
class Design: NSObject, Codable {
    
    // Firestore document ID
    @DocumentID var id: String?
    var name: String?
    var url: String?
    // Design details
    var room: String?
    var style: String?
    var colors: String?
    var items: String?
    var notes: String?
    
    // Enum to specify coding keys for Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case room
        case style
        case colors
        case items
        case notes
    }
}
