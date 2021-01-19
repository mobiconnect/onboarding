//
//  Onboarding.swift
//  Aotomot
//
//  Created by AOTOMOT on 4/7/18.
//  Copyright © 2018 Aotomot. All rights reserved.
//

import UIKit

struct Onboarding {
  var headline:String = ""
  var shortDescription:String = ""
  var imageURL:String = ""
  var videoURL:String?
  var enabled:Bool = false
  var externalURL:String = ""
  var backgroundColor:UIColor = .clear
  var backgroundImageURL:String = ""
  var callToActionText:String = ""
  var callToActionURL:String = ""
  var listOrder:Int?
  
  init(_ info:[String : Any]) {
    if let lheadline = info["headline"] as? String{
      self.headline = lheadline
    }
    
    if let lshortDescription = info["shortDescription"] as? String{
      self.shortDescription = lshortDescription
    }
    
    if let limageURL = info["imageURL"] as? String{
      self.imageURL = limageURL
    }
    
    if let lvideoURL = info["videoURL"] as? String{
      self.videoURL = lvideoURL
    }
    
    if let lexternalURL = info["externalURL"] as? String{
      self.externalURL = lexternalURL
    }
    
    if let lbackgroundColor = info["backgroundColor"] as? String{
      self.backgroundColor = lbackgroundColor != "" ? UIColor(hex: lbackgroundColor) : .clear
    }
    
    if let lcallToActionText = info["callToActionText"] as? String{
      self.callToActionText = lcallToActionText
    }
    
    if let lcallToActionURL = info["callToActionURL"] as? String{
      self.callToActionURL = lcallToActionURL
    }
    
    if let lenabled = info["enabled"] as? Bool{
      self.enabled = lenabled
    }
    
    if let llistOrder = info["listOrder"] as? Int{
      self.listOrder = llistOrder
    }
    
    if let lcallToActionURL = info["callToActionURL"] as? String{
      self.callToActionURL = lcallToActionURL
    }
    
    if let lcallToActionURL = info["callToActionURL"] as? String{
      self.callToActionURL = lcallToActionURL
    }  
  }
}


