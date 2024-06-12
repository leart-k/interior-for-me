//
//  FirebaseController.swift
//  InteriorForMe
//
//  Created by Leart Kepuska on 26/4/2024.
//
import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

// Class implementing DatabaseProtocol to interact with Firebase
class FirebaseController: NSObject, DatabaseProtocol {
    
    // Listeners using the delegate
    var listeners = MulticastDelegate<DatabaseListener>()
    
    // Authentication and database references
    var authController: Auth
    var database: Firestore
    
    // References to the collections
    var usersRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    var currentUserID: String?
    let user = User()
    
    // Design-related references and data
    var designsRef: CollectionReference?
    var designs: [Design] = []
    var designImages: [UIImage] = []
    var userFullName: String = ""
    var userEmail: String = ""
    
    // Initializer
    override init() {
        // Configure Firebase
        FirebaseApp.configure()
        authController = Auth.auth()
        currentUserID = authController.currentUser?.uid
        database = Firestore.firestore()
        super.init()
    }
    
    // Authentication methods
    func login(email: String, password: String) async throws -> String {
        do {
            // Sign in with email and password
            try await Auth.auth().signIn(withEmail: email, password: password)
            self.currentUser = Auth.auth().currentUser
            self.currentUserID = self.currentUser?.uid
            self.setupFirebaseReferences()
            return "Success"
        } catch {
            return error.localizedDescription
        }
    }
    
    func signup(name: String, email: String, password: String) async throws -> String {
        do {
            // Sign up with email and password
            try await Auth.auth().createUser(withEmail: email, password: password)
            self.currentUser = Auth.auth().currentUser
            self.setupFirebaseReferences()
            let users_id = self.currentUser?.uid
            self.currentUserID = users_id
            self.addUser(name: name, email: email, userID: users_id!)
            userFullName = name
            userEmail = email
            return "Success"
        } catch {
            return error.localizedDescription
        }
    }
    
    // User control functions
    func addUser(name: String, email: String, userID: String) {
        let user = User()
        user.id = userID
        user.name = name
        user.email = email
        do {
            // Add user to Firestore
            let usersRef = Firestore.firestore().collection("users")
            try usersRef.document(userID).setData(from: user)
        } catch {
            print("Failed to serialize user")
        }
    }
    
    func returnUserInfo() -> (String, String) {
        // Return user information (name and email)
        return (userFullName, userEmail)
    }
    
    // Design control functions
    func saveDesign(designName: String, image: UIImage, roomType: String, designColors: String, designStyle: String, designItems: String) {
        let imageURL = saveImage(image: image, designName: designName)
        let design = Design()
        
        design.name = designName
        design.url = imageURL
        design.room = roomType
        design.colors = designColors
        design.style = designStyle
        design.items = designItems
        design.notes = ""
        
        designs.append(design)
        designImages.append(image)
        do {
            // Add design to Firestore
            let usersDesignsRef = database.collection("users").document(currentUserID!).collection("designs")
            try usersDesignsRef.addDocument(from: design)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func retrieveDesigns() async throws {
        let storage = Storage.storage().reference()
        let snapshot = try await database.collection("users").document(currentUserID!).collection("designs").getDocuments()
        let detailsData = try await database.collection("users").document(currentUserID!).getDocument().data()
        userFullName = detailsData?["name"] as! String
        userEmail = detailsData?["email"] as! String
        
        for document in snapshot.documents {
            // Retrieve designs from Firestore
            let design = try document.data(as: Design.self)
            designs.append(design)
            let imageRef = storage.child(design.url!)
            let data = try await imageRef.data(maxSize: 1 * 1024 * 1024)
            let image = UIImage(data: data)!
            designImages.append(image)
        }
    }
    
    func returnDesigns() -> ([Design], [UIImage]) {
        // Return designs and their images
        return (designs, designImages)
    }
    
    func signOutRemoval() {
        // Clear designs and user information on sign out
        designs = []
        designImages = []
        userFullName = ""
        userEmail = ""
    }
    
    func saveImage(image: UIImage, designName: String) -> String {
        let path = "images/\(currentUserID!)/\(designName).jpg"
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(path)
        designImages.append(image)
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    print(error!)
                    return
                }
                imageRef.downloadURL { (url, error) in
                    guard url != nil else {
                        return
                    }
                }
            }
        }
        return path
    }
    
    func deleteDesign(designID: String, designName: String) async throws -> Bool {
        let usersDesignsRef = database.collection("users").document(currentUserID!).collection("designs").document(designID)
        let storageRef = Storage.storage().reference().child("images/\(currentUserID!)/\(designName).jpg")
        
        if let index = designs.firstIndex(where: { $0.id == designID }) {
            designs.remove(at: index)
            designImages.remove(at: index)
        }
        do {
            // Delete design and image from Firestore and Storage
            try await usersDesignsRef.delete()
            try await storageRef.delete()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func updateNotes(designID: String, designNotes: String) async throws -> Bool {
        let usersDesignsRef = database.collection("users").document(currentUserID!).collection("designs").document(designID)
        if let index = designs.firstIndex(where: { $0.id == designID }) {
            designs[index].notes = designNotes
        }
        do {
            // Update design notes in Firestore
            try await usersDesignsRef.updateData(["notes": designNotes])
            return true
        } catch {
            return false
        }
    }
    
    // Other methods
    func cleanup() {
        // Cleanup method
    }
    
    func addListener(listener: DatabaseListener) {
        // Add a listener to the list
        listeners.addDelegate(listener)
    }
    
    func removeListener(listener: DatabaseListener) {
        // Remove a listener from the list
        listeners.removeDelegate(listener)
    }
    
    func setupFirebaseReferences() {
        // Setup Firebase references
        if currentUser != nil {
            setupUserListener()
        }
    }
    
    func setupUserListener() {
        usersRef = database.collection("users")
        usersRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseUsersSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseUsersSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            do {
                var user = try change.document.data(as: User.self)
            } catch {
                fatalError("Unable to decode user: \(error.localizedDescription)")
            }
        }
        listeners.invoke { (listener) in
            // Invoke listener with the changes
        }
    }
}
