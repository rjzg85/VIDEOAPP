//
//  ViewCell.swift
//  tabExample
//
//  Created by Jessika Vivas on 6/26/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class videoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            setupThumbnailImage()
            //if let profileImageName = video?.channel?.profileImageName {
            //    userProfileImageView.image = UIImage(named: profileImageName)
            //}
            if let channelName = video?.channel?.name, let numberViews = video?.number_of_views {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                let subtitleText = "\(channelName) * \(numberFormatter.string(from: numberViews)!) *  2 years ago"
                subtitleTextView.text = subtitleText
            }
            
            //mesure title text
            if let title = video?.title{
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let stimateRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 14)], context: nil)
                if stimateRect.size.height > 20 {
                    titleLabelHeightContranst?.constant = 44
                } else {
                    titleLabelHeightContranst?.constant = 20
                }
            }
            
            
        }
        
    }
    
    func setupThumbnailImage(){
        
        if let thumbnailURL = video?.thumbnail_image_name {
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailURL)
//            guard let url = URL(string: thumbnailURL) else {
//                print("Error: cannot create URL")
//                return
//            }
//            
//            let urlRequest = URLRequest(url: url)
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//            
//            // make the request
//            let task = session.dataTask(with: urlRequest) {
//                (data, response, error) in
//                guard error == nil else {
//                    print("error calling GET on /todos/1")
//                    print(error!)
//                    return
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    self.thumbnailImageView.image = UIImage(data: data!)
//                }
//               
//            }
//            
//            task.resume()
        }
        if let profileURL = video?.channel?.profileImageName {
            userProfileImageView.loadImageUsingUrlString(urlString: profileURL)
            
        }
        
        
    }
    
    let thumbnailImageView: customImageView = {
        let imageView = customImageView()
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 230/255)
        return view
    }()
    let userProfileImageView: customImageView = {
        let imageView = customImageView()
        imageView.image = UIImage(named: "taylor_swift_profile")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "TaylorSwiftVEVO - 1,604,684,607  views *  2 years ago"
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    var titleLabelHeightContranst: NSLayoutConstraint?
    
    override func setupViews(){
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        
        addConstrastWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        
        
        addConstrastWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        addConstrastWithFormat(format: "H:|[v0]|", views: separatorView)
        // Vertical constraints
        addConstrastWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        
        
        //thumbnailImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // top constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        
        // let constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        // right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        //height Constraint
        titleLabelHeightContranst = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        
        addConstraint(titleLabelHeightContranst!)
        
        
        
        // Constraint for subtitle
        // top constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        
        // let constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        // right constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 0))
        
        //height Constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
        
        
    }
}

