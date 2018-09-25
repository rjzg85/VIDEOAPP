//
//  VideoLauncher.swift
//  tabExample
//
//  Created by Jessika Vivas on 7/17/18.
//  Copyright © 2018 Roberth Zambrano. All rights reserved.
//

import UIKit
import  AVFoundation

class VideoPlayerView: UIView {
    var player: AVPlayer?
    var isPlaying = false
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        aiv.startAnimating()
        return aiv
    }()
    let pauseButton: UIButton = {
       let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        return button
        
    }()
    
    @objc func handlePause(){
        if isPlaying {
            player?.pause()
            pauseButton.setImage(UIImage(named: "play"), for: .normal)
            isPlaying = false
        }else{
            player?.play()
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            isPlaying = true
        }
    
    }
    
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
        
    }()
    
    let videoLengthLabel: UILabel = {
       let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    lazy var videSlider: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange(){
        print(videSlider.value)
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value)  , timescale: 1)
            player?.seek(to: seekTime,completionHandler: {(completedSeek) in
                
            })
        }
        
    }
    
    
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        setupGradientLayer()
        
        controlContainerView.frame = self.frame
        
        addSubview(controlContainerView)
        
        controlContainerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.center = controlContainerView.center
        
        controlContainerView.addSubview(pauseButton)
        pauseButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        pauseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlContainerView.addSubview(videoLengthLabel)
        
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlContainerView.addSubview(videSlider)
        videSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = UIColor.black
        
    }
    
    private func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor ]
        gradientLayer.locations = [0.7, 1.2]
        controlContainerView.layer.addSublayer(gradientLayer)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/trainging-ios.appspot.com/o/Video%20Shorton%20Express.mp4?alt=media&token=55ec33a6-0fc3-4b06-ab54-f733112ab0c4"
        if let url = URL(string: urlString){
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            // start player the video from URL
            player?.play()
            // create an observer in order to check wheter the video load or not
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            // track player progress
            let intervals = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: intervals, queue: DispatchQueue.main, using: {(progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                
                let secondsString = String(format: "%02d", Int(seconds) % 60 )
                let minuteString = String(format: "%02d", Int(seconds) / 60 )
                self.currentTimeLabel.text = "\(minuteString):\(secondsString)"
                
                // lets move the slider thumb
                if let duration  = self.player?.currentItem?.duration{
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    self.videSlider.value = Float(seconds / durationSeconds)
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // this is whem the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges"{
            activityIndicatorView.stopAnimating()
            controlContainerView.backgroundColor = UIColor.clear
            pauseButton.isHidden = false
            isPlaying = true
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                // let minuteText = Int(seconds) / 60
                let minuteText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLabel.text = "\(minuteText):\(secondsText)"
            }
            
        }
    }
    
    
    
}




class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        print("Showing video player animation...")
        
        // creating new view
        if let keyWindow = UIApplication.shared.keyWindow{
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            // create animation to how do you want to present the new view
            keyWindow.addSubview(view)
            // 16 x 9 is the aspect ratio for all HD Video
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerViewFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerViewFrame)
            view.addSubview(videoPlayerView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
                
            }, completion: {(completionAnimate) in
                // maybe run somethins later
                // hide statusBar
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
            
        }
    }
   
    
}
