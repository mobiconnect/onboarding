
//
//  APIData.swift
//  Aotomot
//
//  Created by AOTOMOT on 4/7/18.
//  Copyright © 2018 Aotomot. All rights reserved.
//

import UIKit
import Alamofire

class APIData: NSObject {
  class var shared: APIData {
    struct Singleton {
      static let instance = APIData()
    }
    return Singleton.instance
  }
  
  /// network error
  struct MBDError : Error
  {
    public var code:Int
    public var message:String
    public var apiMessage:String
    
    public init(code: Int?,apiMessage:Any?)
    {
      self.code = code ?? 500
      switch code {
      case 400:
        self.message = "We are unable to process your request at this time."
      case 401:
        self.message = "Seems you don't have the right access."
      case 403:
        self.message = "Seems you don't have the right access."
      case 404:
        self.message = "We can't seem to find that."
      default:
        self.message = "Seems there's a problem, please try again in a while."
      }
      if apiMessage != nil,let response = apiMessage as? [String:Any], let message = response["message"] as? String{
        self.apiMessage = message
      }else{
        self.apiMessage = self.message
      }
    }
  }
  
  func getOnboarding(_ success:@escaping ([Onboarding]) -> Void){
    if !Reachability.isConnectedToNetwork(){
      return
    }
    
    let headers = [
      "accept":"application/json",
    ]
    Alamofire.request(Urls.onboarding,method: .get, parameters: nil, encoding: URLEncoding.default,headers: headers)
      .responseJSON { response in
        print("\n**************************\nresponse code:\(response.response?.statusCode ?? 500)\nresponse:\((response.result.value ?? "No result value"))\n**************************\n")
        if response.result.isSuccess{
          if response.response?.statusCode == 200{
            var onboardingItems:[Onboarding] = []
            if let onboardingArray = response.result.value as? [[String:Any]] {
              for onboarding in onboardingArray{
                let onboardingInfo = Onboarding(onboarding)
                if onboardingInfo.enabled{
                  onboardingItems.append(onboardingInfo)
                }
              }
              let maxSortOrder = onboardingItems.map{$0.listOrder ?? 0}.reduce(0) { $0 > $1 ? $0 : $1 } + 1
              onboardingItems.sort(by: {$0.listOrder ?? maxSortOrder < $1.listOrder ?? maxSortOrder})
              success(onboardingItems)
            }else{
              let error = MBDError(code: response.response?.statusCode, apiMessage: response.result.value)
              Utility.showAlert(message: error.message)
            }
          }else{
            let error = MBDError(code: response.response?.statusCode, apiMessage: response.result.value)
            Utility.showAlert(message: error.message)
          }
        }else{
          let error = MBDError(code: response.response?.statusCode, apiMessage: response.result.value)
          Utility.showAlert(message: error.message)
        }
    }
  }
}
