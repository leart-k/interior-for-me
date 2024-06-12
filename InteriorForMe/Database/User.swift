//
//  User.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 26/4/2024.
//
import UIKit
import FirebaseFirestoreSwift

// User class conforming to Codable for easy serialization
class User: NSObject, Codable {
    
    // Firestore document ID
    @DocumentID var id: String?
    var name: String?
    var email: String?
    
    // Enum to specify coding keys for Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }
}
