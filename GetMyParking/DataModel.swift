//
//  DataModel.swift
//  GetMyParking
//
//  Created by Suruchi Sinha on 1/14/18.
//  Copyright © 2018 Suruchi Sinha. All rights reserved.
//

import Foundation

class DataModel {
    
    static let sharedInstance = DataModel()
    private let keyname = "urls"
    
    func setImageUrl(_ imageUrl: String) {
        var urls : [String]
        let defaults = UserDefaults.standard
        if let array = defaults.value(forKey: keyname) {
            urls = (array as? [String])!
        }else {
            urls = [String]()
        }
        urls.append(imageUrl)
        defaults.set(urls, forKey: keyname)
    }
    
    func getImageUrls()->[String]? {
        let defaults = UserDefaults.standard
        if let array = defaults.value(forKey: keyname) {
            return array as? [String]
        }
        return nil
    }
}
