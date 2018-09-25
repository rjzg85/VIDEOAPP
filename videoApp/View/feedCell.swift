//
//  feedCell.swift
//  tabExample
//
//  Created by Jessika Vivas on 7/15/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit

class feedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var videos: [Video]?
    
    func fecthVideos(){
        ApiService.sharedIntance.fecthVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
            
        }
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor =  UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let cellId = "cellId"
    
    override func setupViews() {
        super.setupViews()
        fecthVideos()
        
        backgroundColor = UIColor.brown
        addSubview(collectionView)
        addConstrastWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstrastWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(videoCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 5
        return videos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! videoCell
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    // SET HEIGHT AND WIDTH OF THE CONTENT VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 16 - 16) * 9 / 16
        return CGSize(width: frame.width, height: height + 16 + 88)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer()
        
        
    }

    
    
}
