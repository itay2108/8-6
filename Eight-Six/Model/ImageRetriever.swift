//
//  ImageRetriever.swift
//  Eight-Six
//
//  Created by itay gervash on 12/11/2020.
//

import UIKit

//protocol ImageRetrieverDelegate {
//    func didReceive(images: [UnsplashImage])
//}

class ImageRetriever {
    
    static let shared = ImageRetriever()
    
    let baseURL: String = "https://api.unsplash.com/photos/random/"
    let publicKey: String = "eZeO6V5TxBL0xm5YfDUfmZ5TRzEfuBX1HxGWQ1J4nbs"
    let secretKey: String = "bBJBfzPJrK6zyErSyXyeJJURfCZYDrIzF-TxYg6kwFA"
    
    func getImages(count: Int, featured: Bool, completion: @escaping (_ result: [UnsplashImage]) -> Void) {
        
        var finalURL = "\(baseURL)?client_id=\(publicKey)&count=\(count)&orientation=squarish"
        
        if featured { finalURL += "&featured=\(featured)" }
        
        let session = URLSession(configuration: .default)
        
        guard let url = URL(string: finalURL) else { return }

        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil { print("Error creating url task: \(String(describing: error))") }
            
            if let receivedData = data {
                if let blueprint = self.parseJSON(from: receivedData) {
                    DispatchQueue.main.async {
                        completion(self.buildImageObjects(from: blueprint))
                        session.invalidateAndCancel()
                    }
                }
            }
        }
        
        task.resume()
        
    }

    func buildImageObjects(from data: [ImageData]) -> [UnsplashImage] {
        var images: [UnsplashImage] = []
        
        for image in data {
            let uImg = UnsplashImage(url: image.links.download, title: image.user.name, likes: image.likes, full: image.urls.full, regular: image.urls.regular, small: image.urls.small, thumb: image.urls.thumb)
            images.append(uImg)

        }
        
        return images
    }


    func parseJSON(from data: Data) -> [ImageData]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([ImageData].self, from: data)
            return decodedData
        } catch {
            print("cannot parse data \(error)")
        }
        
        return nil
        
    }
    
}
