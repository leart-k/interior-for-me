//
//  APIRequestViewController.swift
//  InteriorForMe
//
//  Created by Leart on 2/5/2024.
//
import UIKit

class APIRequestViewController: UIViewController {
    
    // Constants for API URL and request limits
    let urlString = "https://api.limewire.com/api/image/generation"
    let MAX_ITEMS_PER_REQUEST = 1
    let MAX_REQUESTS = 5
    
    // State variables
    var imageReady = false
    var imageURL = ""
    
    // Input parameters for the API request
    var inputRoom: String = ""
    var inputColor: String = ""
    var inputStyle: String = ""
    var inputItems: String = ""
    
    // Array to hold generated images
    var addedImages = [ImageData]()
    
    // Flag to indicate if generation should stop
    var shouldStopGenerating = false
    
    // Action to stop the generation process
    @IBAction func stopGenerating(_ sender: Any) {
        shouldStopGenerating = true
        tabBarController?.tabBar.isHidden = false
        performSegue(withIdentifier: "stopGenerating", sender: self)
        navigationItem.hidesBackButton = true
    }
    
    // Called when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        tabBarController?.tabBar.isHidden = true
        
        // Get the API key from environment variables
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY2"] else {
            print("API Key is not set")
            return
        }
        
        // Start image generation task
        Task {
            URLSession.shared.invalidateAndCancel()
            await imageGeneration(apiKey: apiKey, room: inputRoom, color: inputColor, style: inputStyle, items: inputItems)
        }
    }
    
    // Function to generate images using the API
    func imageGeneration(apiKey: String, room: String, color: String, style: String, items: String) async {
        
        // Create the prompt for the API request
        let prompt = "Generate me a very realistic interior of a \(room), using these HEX colours which are separated by a comma: \(color). Please use the \(style) interior style, and the interior must include the following items: \(items)."
        
        // Create the payload for the API request
        let payload: [String: Any] = [
            "prompt": prompt,
            "samples": 1,
            "quality": "HIGH",
            "guidance_scale": 70,
            "aspect_ratio": "1:1",
            "style": "PHOTOREALISTIC"
        ]
        
        // Encode the payload to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            print("Error encoding payload to JSON")
            return
        }
        
        // Create the URL request
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("v1", forHTTPHeaderField: "X-Api-Version")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonData
        
        do {
            // Send the request and get the response
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let decoder = JSONDecoder()
            let requestData = try decoder.decode(RequestData.self, from: data)
            
            // Check if images are generated
            if let images = requestData.images {
                addedImages.append(contentsOf: images)
                imageReady = true
            }
            
            // Perform the segue if images are ready and generation is not stopped
            if imageReady && !shouldStopGenerating {
                performSegue(withIdentifier: "interiorGenerated", sender: self)
            }
        }
        catch let error {
            print(error)
        }
    }
    
    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "interiorGenerated", let destination = segue.destination as? InteriorGeneratedViewController {
            destination.imageURL = (addedImages[0].imageURL)!
            destination.inputRoom = inputRoom
            destination.inputColor = inputColor
            destination.inputStyle = inputStyle
            destination.inputItems = inputItems
        }
    }
}
