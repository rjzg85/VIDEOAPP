//
//  ViewController.swift
//  tabExample
//
//  Created by Jessika Vivas on 6/25/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

//    var videos: [Video] = {
//        var kanyeChannel = Channel()
//        kanyeChannel.name = "KanyeIsTheBestChannel"
//        kanyeChannel.profileImageName = "kanye_profile"
//        var blankSpaceVideo = Video()
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        blankSpaceVideo.thumnbnailImageName = "taylor_swift_blank_space"
//        blankSpaceVideo.channel = kanyeChannel
//        blankSpaceVideo.numberOfViews = 213453564345
//        var badBlodVideo = Video()
//        badBlodVideo.title = "Taylor Swift - Bad Blood feacturing Kendrick Lamar"
//        badBlodVideo.thumnbnailImageName = "taylor_swift_bad_blood"
//        badBlodVideo.channel = kanyeChannel
//        badBlodVideo.numberOfViews = 542345616564
//
//
//        return [blankSpaceVideo, badBlodVideo]
//    }()
    let cellId = "cellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
  
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.title = "Home"
        // Create a label in order in put as title of the navigation
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "   Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.isTranslucent = false
        
        
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = UIColor.white
//        collectionView?.register(videoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(feedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.isPagingEnabled = true
    }
    private func setupMenuBar(){
        navigationController?.hidesBarsOnSwipe = true
        let redView = UIView()
        redView.backgroundColor = UIColor.rgv(red: 230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addSubview(menuBar)
        view.addConstrastWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstrastWithFormat(format: "V:[v0(50)]", views: redView)
        view.addConstrastWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstrastWithFormat(format: "V:[v0(50)]", views: menuBar)
        // trick it  to get the right height
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    
    }
    
    private func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        
        let searchBarImage = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        
        let moreButton = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        
        let moreBarButton = UIBarButtonItem(image: moreButton, style: .plain, target: self, action: #selector(handleMore))
        
        
        navigationItem.rightBarButtonItems = [moreBarButton, searchBarImage]
        
    }
    @objc func handleSearch() {
        scrollToMenuIndex(menuIndex: 2)
        print(123)
    }
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        
      setTitleForIndex(index: menuIndex)
        
        
    }
    
    private func setTitleForIndex(index: Int){
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "   \(titles[index])"
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
       
        setTitleForIndex(index: Int(index))
        
    }
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleMore() {
        settingsLauncher.showSetting()
        //showControllerForSetting()
    }
    
    func showControllerForSettings(setting: Setting){
        let dumbySettingViewController = UIViewController()
        
        
        dumbySettingViewController.view.backgroundColor = UIColor.white
        dumbySettingViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationController?.pushViewController(dumbySettingViewController, animated: true)
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.x)
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        
        if indexPath.item == 1 {
            identifier = trendingCellId
        }else if indexPath.item == 2 {
            identifier = subscriptionCellId
        }else {
            identifier = cellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
//        let colorArray: [UIColor] = [UIColor.blue, .green, .black, UIColor.gray]
//        cell.backgroundColor = colorArray[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
  

    





}




