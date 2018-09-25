//
//  ApiService.swift
//  tabExample
//
//  Created by Jessika Vivas on 7/11/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedIntance = ApiService()
    
    
    func fecthVideos(completion: @escaping ([Video]) -> ()){
        
        let urlString: String = "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json"
        fetchFeedForUrlString(urlString: urlString, completion: completion)
        
        
    }
    
    
    func fecthTrendingFeed(completion: @escaping ([Video]) -> ()){
        
        let urlString: String = "https://s3-us-west-2.amazonaws.com/youtubeassets/trending.json"
        fetchFeedForUrlString(urlString: urlString, completion: completion)
        
        
    }
    
    
    
    func fecthSusbcriptionFeed(completion: @escaping ([Video]) -> ()){
        
        let urlString: String = "https://s3-us-west-2.amazonaws.com/youtubeassets/subscriptions.json"
        fetchFeedForUrlString(urlString: urlString, completion: completion)
        
        
        
        
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video])-> ()){
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                
                //print(json)
                
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as! String
                    video.thumbnail_image_name = dictionary["thumbnail_image_name"] as! String
                    video.number_of_views = dictionary["number_of_views"] as! NSNumber
                    
                    //video.setValuesForKeys(dictionary)
                    
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    
                    
                    videos.append(video)
                    
                    // print(dictionary["title"])
                }
                
                DispatchQueue.main.async {
                    // self.collectionView?.reloadData()
                    completion(videos)
                }
                
                
                
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }
    
    
}
