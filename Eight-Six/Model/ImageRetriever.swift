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
    
    func getImages(count: Int, featured: Bool, didReceiveImage: @escaping (_ result: UnsplashImage, _ count: Int) -> Void, completion: ((_ success: Bool) -> Void)? = nil) {
        
        var finalURL = "\(baseURL)?client_id=\(publicKey)&orientation=squarish"
        
        if featured { finalURL += "&featured=\(featured)" }
         
        let dispatchGroup = DispatchGroup()
        
        guard let url = URL(string: finalURL) else { return }
        
        print(url)
        
        imageLoop: for _ in 1...count {
            
                dispatchGroup.enter()
                
                let session = URLSession(configuration: .default)

                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil { print("Error creating url task: \(String(describing: error))") }
                    
                    if let receivedData = data {
                        if let blueprint = self.parseJSON(from: receivedData) {
                            DispatchQueue.main.async {
                                didReceiveImage(self.buildImageObject(from: blueprint), count)
                                session.invalidateAndCancel()
                                dispatchGroup.leave()

                            }
                        }
                    }

                }
                
                task.resume()

        }
        
        dispatchGroup.notify(queue: .main) {

            if completion != nil { completion!(true) }
        }
    }

    func buildImageObject(from data: ImageData) -> UnsplashImage {
         return UnsplashImage(url: data.links.download, title: data.user.name, likes: data.likes, full: data.urls.full, regular: data.urls.regular, small: data.urls.small, thumb: data.urls.thumb)

    }


    func parseJSON(from data: Data) -> ImageData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ImageData.self, from: data)
            return decodedData
        } catch {
            print("cannot parse data \(error)")
        }
        
        return nil
        
    }
    
}
