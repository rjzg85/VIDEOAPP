//
//  MenuBar.swift
//  tabExample
//
//  Created by Jessika Vivas on 7/2/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgv(red: 230, green: 32, blue: 31)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let cellId = "cellId"
    let imageNames = ["home", "trending", "subscriptions", "account"]
    var homeController: HomeViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        addConstrastWithFormat(format: "H:|[v0]|",	 views: collectionView)
        addConstrastWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.allowsSelection = true
        
        
        setupHorizontalBar()
        
       
        
        
    }
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    
    func setupHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.white
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        // new school way to laying out our view
        // in ios9
        // need x,y,with, height constraint
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
            horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        
        cell.imageView.tintColor = UIColor.rgv(red: 91, green: 14, blue: 13)
        
        let indexPathForFirstRow = IndexPath(item: 0, section: 0)
        self.collectionView.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let x = CGFloat(indexPath.item) * frame.width / 4
//        horizontalBarLeftAnchorConstraint?.constant = x
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
        
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgv(red: 91, green: 14, blue: 13)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgv(red: 91, green: 14, blue: 13)
        }
    }
    
    
    override func setupViews(){
        super.setupViews()
        
        addSubview(imageView)
        addConstrastWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstrastWithFormat(format: "V:[v0(28)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
