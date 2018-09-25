//
//  SubscriptionCell.swift
//  tabExample
//
//  Created by Jessika Vivas on 7/16/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit

class SubscriptionCell: feedCell {
    override func fecthVideos() {
        
        ApiService.sharedIntance.fecthSusbcriptionFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
            
        }
    }
    
}
