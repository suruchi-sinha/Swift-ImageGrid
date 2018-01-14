//
//  ImageHandler.swift
//  GetMyParking
//
//  Created by Suruchi Sinha on 1/14/18.
//  Copyright © 2018 Suruchi Sinha. All rights reserved.
//

import Foundation
import Cloudinary
import Alamofire

class ImageHandler {
    
    let cloudinary: CLDCloudinary
    init() {
        let config = CLDConfiguration(cloudName: Constants.cloudname)
        cloudinary = CLDCloudinary(configuration: config)
    }
    
    public func uploadImageToServer(_  imageData: Data, completion: @escaping (_ result: String?, Bool)->()) {
        let uploader = cloudinary.createUploader()
        uploader.upload(data: imageData, uploadPreset: Constants.presetName) { result, error in
            if result != nil {
                let imageUrl = result?.resultJson["secure_url"] as! String
                completion(imageUrl, true)
            }else {
                completion(nil, false)
                print(error.debugDescription)
            }
        }
    }
    
    public func downloadImageFromServer(_ imageUrl: String, completion: @escaping (UIImage?)->()) {
        let downloader = cloudinary.createDownloader()
        downloader.fetchImage(imageUrl, nil) { (image, error) in
            if image != nil {
                completion(image)
            }else {
                completion(nil)
            }
        }
    }
    
    public func getResourceList(completion: @escaping ([String]?)->()) {
    
        var imageUrls = [String]()
        let url = URL(string: Constants.resourceUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(request).responseJSON {  (response) in
            switch response.result {
            case .success(let json):
                print("Success with JSON: \(json)")
                break
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                
                break
            }
        
        }
        
    }
    
}
