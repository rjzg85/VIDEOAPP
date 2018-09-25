//
//  Video.swift
//  tabExample
//
//  Created by Jessika Vivas on 7/2/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit


class Video: NSObject {
    
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views:NSNumber?
    var uploadDate: NSDate?
    var channel: Channel?
    var duration: String?
    
    
    
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}
