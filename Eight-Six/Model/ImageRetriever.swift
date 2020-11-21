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
    
    private var networkError: RetrieverError? = nil
    
    let baseURL: String = "https://api.unsplash.com/photos/random/"
    let publicKey: String = "eZeO6V5TxBL0xm5YfDUfmZ5TRzEfuBX1HxGWQ1J4nbs"
    let secretKey: String = "bBJBfzPJrK6zyErSyXyeJJURfCZYDrIzF-TxYg6kwFA"
    
    func getImages(count: Int, featured: Bool, didReceiveImage: @escaping (_ result: UnsplashImage, _ count: Int) -> Void, completion: ((_ success: Bool, _ error: RetrieverError?) -> Void)? = nil) {
        
        
        
        self.networkError = nil
        
        var finalURL = "\(baseURL)?client_id=\(publicKey)&orientation=squarish"
        
        if featured { finalURL += "&featured=\(featured)" }
        
        guard let url = URL(string: finalURL) else { return }
        
        let dispatchGroup = DispatchGroup()
        let sema = DispatchSemaphore(value: 0)
        
        print(url)
        
        DispatchQueue.main.async {
            
            for _ in 1...count.magnitude {
                
                if self.networkError == nil {
                    //enter dispatch group if error is nil
                    dispatchGroup.enter()
                    
                    //create session and task to get data and create the image objects with it
                    let session = URLSession(configuration: .default)
                    
                    let _ = session.dataTask(with: url) { (data, response, error) in
                        if error != nil { self.networkError = .url }
                        
                        if let receivedData = data {
                            if let blueprint = self.parseJSON(from: receivedData) {
                                DispatchQueue.main.async {
                                    didReceiveImage(self.buildImageObject(from: blueprint), count)
                                    session.finishTasksAndInvalidate()
                                }
                            } else { self.networkError = .json; print(self.networkError!.rawValue) }
                        } else { self.networkError = .data; print(self.networkError!.rawValue) }
                        
                        //leave dispatch group when finished executing the task and signal the semaphore to continue to the next loop iteration
                        dispatchGroup.leave()
                        sema.signal()
                    }.resume()
                    
                    //if there is an error fire the completion with success = false and return
                } else {
                    if completion != nil { completion!(false, self.networkError)
                        return
                    }
                }
                //at the end of the loop, wait for a semaphore signal before starting another loop iteration
                sema.wait()
            }
            
            dispatchGroup.notify(queue: .main) {
                if completion != nil { completion!(true, nil) }
            }
        }
        
        
        
        //        DispatchQueue.global().async { [weak self] in
        //
        //            var networkError: RetrieverError? = nil
        //
        //            imageLoop: for _ in 1...count {
        //
        //                if networkError == nil {
        //
        //                    dispatchGroup.enter()
        //                    guard let url = URL(string: finalURL) else { return }
        //
        //                    let imageData = try? Data(contentsOf: url)
        //
        //                    if let safeData = imageData {
        //                        if let blueprint = self?.parseJSON(from: safeData) {
        //                            guard self != nil else { print("self is nil"); break imageLoop }
        //                            DispatchQueue.main.async {
        //                                didReceiveImage(self!.buildImageObject(from: blueprint), count)
        //                                print(self!.buildImageObject(from: blueprint).title)
        //
        //                            }
        //                        } else { networkError = .data; print(networkError!.rawValue) }
        //                    }
        //                    dispatchGroup.leave()
        //                    sema.signal()
        //                }  else {
        //                    if completion != nil { completion!(false, nil) }
        //                    print("error completion")
        //                    break
        //                }
        //                sema.wait()
        //            }
        //        }
        
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
            let _ = error
        }
        
        return nil
        
    }
    
}
