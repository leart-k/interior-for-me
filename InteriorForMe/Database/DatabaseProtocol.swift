//
//  DatabaseProtocol.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 26/4/2024.
//

import Foundation
import UIKit

// Enum to specify the type of change that has been done to the database
enum DatabaseChange {
    case add
    case remove
    case update
}

// Enum to differentiate sets of data that exist within the database
enum ListenerType {
    case users
}

// Protocol defining the delegate used to receive messages
// This protocol is database agnostic and can be used for other databases
protocol DatabaseListener: AnyObject {
    // Specifies the type of listener (get and set)
    var listenerType: ListenerType { get set }
}

// Protocol defining the behavior of the database, with methods accessible by the rest of the app
protocol DatabaseProtocol: AnyObject {
    // Cleanup function for database
    func cleanup()
    
    // Methods to add and remove listeners
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    // Authentication functions
    func login(email: String, password: String) async throws -> String
    func signup(name: String, email: String, password: String) async throws -> String
    func signOutRemoval()
    
    // User control functions
    func addUser(name: String, email: String, userID: String)
    func returnUserInfo() -> (String, String)
    
    // Design control functions
    func saveDesign(designName: String, image: UIImage, roomType: String, designColors: String, designStyle: String, designItems: String)
    func retrieveDesigns() async throws
    
    func returnDesigns() -> ([Design], [UIImage])
    
    func deleteDesign(designID: String, designName: String) async throws -> Bool
    
    func updateNotes(designID: String, designNotes: String) async throws -> Bool
}
