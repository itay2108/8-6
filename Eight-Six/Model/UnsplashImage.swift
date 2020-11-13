//
//  UnsplashImage.swift
//  Eight-Six
//
//  Created by itay gervash on 12/11/2020.
//

import UIKit

class UnsplashImage {
    
    var notificationCenter = NotificationCenter.default

    
    var url: URL?
    var title: String
    var likes: Int
    
    var image: UIImage? {
        didSet {
            if image != nil { notificationCenter.post(name: .imageHasFinishedLoading, object: nil)}
        }
    }
    
    func getImagefrom(_ url: URL?, completion: @escaping (_ image: UIImage?) -> Void) {

        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            guard error == nil, data != nil else { return }
            DispatchQueue.main.async {
                completion(UIImage(data: data!))
                session.invalidateAndCancel()

            }
        }
        
        dataTask.resume()
    
    }
    
    init(url: String, title: String, likes: Int) {
        self.url = URL(string: url)
        self.title = title
        self.likes = likes
        
        getImagefrom(URL(string: url)) { (image) in
            self.image = image
        }
    }
    
}
