//
//  VideoPlayerViewController.swift
//  Aotomot
//
//  Created by AOTOMOT on 4/7/18.
//  Copyright © 2018 Aotomot. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerViewController: AVPlayerViewController {
  var videoUrl:URL?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if videoUrl != nil{
      self.player = AVPlayer(url: videoUrl!)
    }
  }

}
