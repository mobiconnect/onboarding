//
//  ImageCell.swift
//  FAPaginationLayout
//
//  Created by Fahid Attique on 14/06/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit
import SDWebImage

class OnboardingCell: ScalingCarouselCell,YouTubePlayerDelegate {

  @IBOutlet weak var lbTitle: UILabel!
  @IBOutlet weak var btnSelect: UIButton!
  @IBOutlet weak var lbMessage: UILabel!
  @IBOutlet var wallpaperImageView: UIImageView!
    @IBOutlet weak var videoView: PlayerView!
    @IBOutlet weak var ytPLayer: YouTubePlayerView!
    var videoPlayer: VideoPlayer!

    
    //  Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        wallpaperImageView.layer.cornerRadius = 4.0
        videoView.layer.cornerRadius = 4.0
        ytPLayer.layer.cornerRadius = 4.0
        ytPLayer.delegate = self
    }

  func configureCell(_ onboarding:Onboarding){
    // Text
    lbTitle.text = onboarding.headline
    self.lbMessage.attributedText = Utility.convertStrToAttriuteStr(onboarding.shortDescription,colour: UIColor(hex: "#444444"), size: 21.0)
    self.lbMessage.textAlignment = .center

    // Image
    if let url = URL(string:onboarding.imageURL){
      self.wallpaperImageView.sd_setImage(with:  url, placeholderImage:nil, options: .avoidAutoSetImage, completed: { (image, _, type, _) -> Void in
        if (image != nil) {
          if (type == SDImageCacheType.none || type == SDImageCacheType.disk) {
            UIView.transition(with: self.wallpaperImageView, duration: 0.75, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
              self.wallpaperImageView.image = image
              self.wallpaperImageView.backgroundColor = UIColor.clear
            }, completion: nil)
          } else {
            self.wallpaperImageView.image = image
            self.wallpaperImageView.backgroundColor = UIColor.clear
          }
        }
      })
    }
    
    // Video
    self.videoView.isHidden = true
    self.ytPLayer.isHidden = true
    if let urlString = onboarding.videoURL,
      let url = URL(string: urlString){
      if urlString.contains(find: "youtube"){
        self.ytPLayer.playerVars = ["playsinline": 1 as AnyObject, "autoplay": 1 as AnyObject, "autohide": 1 as AnyObject, "controls" : 0 as AnyObject, "showinfo" : 0 as AnyObject, "modestbranding" : 1 as AnyObject, "rel" : 0 as AnyObject]
        _ = self.ytPLayer.loadVideoURL(url)
        self.ytPLayer.mute()
        self.ytPLayer.play()
        self.ytPLayer.isHidden = false
      }else{
        self.videoView.isHidden = false
        self.videoPlayer = VideoPlayer(url:url)
        self.videoPlayer.setUpPlayerInView(view: self.videoView)
        self.videoPlayer.playLoop()
      }
    }
  }
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        ytPLayer.play()
        ytPLayer.mute()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == .Ended{
            ytPLayer.play()
            ytPLayer.mute()
        }
    }
}
