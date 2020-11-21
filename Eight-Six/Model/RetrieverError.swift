//
//  File.swift
//  Eight-Six
//
//  Created by itay gervash on 20/11/2020.
//

import Foundation

enum RetrieverError: String {
    case json = "Failed to parse JSON"
    case data = "Failed to retrieve data from URL"
    case builder = "Failed to build UnsplashImage object from data"
    case url = "Error accessing URL"
    case test = "This is a dummy error created for testing purposes"
}
