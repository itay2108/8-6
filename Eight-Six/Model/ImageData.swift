//
//  ImageData.swift
//  Eight-Six
//
//  Created by itay gervash on 12/11/2020.
//

import Foundation

struct ImageData: Codable {
    
    struct Urls: Codable {
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
    struct Links: Codable {
        let download: String
    }
    
    struct User: Codable {
        let name: String
    }
    
    let likes: Int
    let links: Links
    let user: User
    let urls: Urls
    
}
