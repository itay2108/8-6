//
//  ImageData.swift
//  Eight-Six
//
//  Created by itay gervash on 12/11/2020.
//

import Foundation

struct ImageData: Codable {
    
    struct Links: Codable {
        let download: String
    }
    
    struct User: Codable {
        let name: String
    }
    
    let likes: Int
    let links: Links
    let user: User
    
}
