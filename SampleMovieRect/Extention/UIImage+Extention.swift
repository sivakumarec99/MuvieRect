//
//  UIImage+Extention.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}

class AsyncImageView: UIImageView {
    
    let imageCache = NSCache<NSString, AnyObject>()

    private var currentUrl: String? //Get a hold of the latest request url
    
    public func imageFromServerURL(url: String){
        currentUrl = url
        if(imageCache.object(forKey: url as NSString) != nil){
            self.image = imageCache.object(forKey: url as NSString) as? UIImage
        }else{
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let task = session.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data!) {
                            if (url == self.currentUrl) {//Only cache and set the image view when the downloaded image is the one from last request
                                self.imageCache.setObject(downloadedImage, forKey: url as NSString)
                                self.image = downloadedImage
                            }
                        }
                    }
                }
                else {
                    print(error as Any)
                }
            })
            task.resume()
        }
        
    }
    
}
