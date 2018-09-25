//
//  Extensions.swift
//  tabExample
//
//  Created by Jessika Vivas on 6/26/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgv(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstrastWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for(index, view ) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format , options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}

// implement cache in our app
let imageCache = NSCache<AnyObject, AnyObject>()

class customImageView: UIImageView {
    var imageUrlSring: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlSring = urlString
        
        let url = URL(string: urlString)
        image = nil
        
        // validate if we have whether already have image in the cache and show up before to create a conexion
        if let imagefromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imagefromCache
            return
        }
        
        
            
            let urlRequest = URLRequest(url: url!)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            // make the request
            let task = session.dataTask(with: urlRequest) {
                (data, response, error) in
                guard error == nil else {
                    print("error calling GET on /todos/1")
                    print(error!)
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    //self.image = UIImage(data: data!)
                    let imageToCache = UIImage(data: data!)
                    // validate if still we have the same URL
                    if self.imageUrlSring == urlString {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    
                }
                
            }
            
            task.resume()
        }
        
}

