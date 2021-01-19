//
//  OnboardViewController
//  Aotomot
//
//  Created by AOTOMOT on 4/7/18.
//  Copyright © 2018 Aotomot. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {
  //  IBOutlets
  @IBOutlet var collectionView: ScalingCarouselView!
  @IBOutlet weak var pageIndicator: UIPageControl!
  @IBOutlet weak var backgroundImage: UIImageView!
  var onboarding: [Onboarding] = []
  var centerCell = 0
  
  //  Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.collectionView.inset = 0.0
    getOnboarding()
  }
  
  fileprivate func getOnboarding(){
    APIData.shared.getOnboarding({onboarding in
      if onboarding.count > 0{
        self.onboarding = onboarding
        self.viewConfigrations()
        self.collectionView.reloadData()
      }else{
        Utility.showAlert(message: "No on boardig content found. Please go to your Aotomot account add the content to view here.")
      }
    })

  }
  
  fileprivate func viewConfigrations() {
    
    /// configure the page indicator
    pageIndicator.numberOfPages = self.onboarding.count
    pageIndicator.currentPageIndicatorTintColor = UIColor(hex: "#E31349")
    self.updateItemDetails()
    collectionView.register(UINib(nibName: "OnboardingCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCell")
  }
  
  func updateCellsLayout()  {
    let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width)/2
    for cell in collectionView.visibleCells {
      
      var offsetX = centerX - cell.center.x
      if offsetX < 0 {
        offsetX *= -1
      }
      cell.transform = CGAffineTransform.identity
      let offsetPercentage = offsetX / (view.bounds.width * 5.0)
      let scaleX = 1-offsetPercentage
      cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)            
    }
  }
  
  func updateItemDetails(){
    var centerCellTag = 0
    for cell in collectionView.visibleCells {
      centerCellTag = cell.tag
    }
    
    let onboardItem = self.onboarding[centerCellTag]
    centerCell = centerCellTag
    pageIndicator.currentPage = centerCell
    UIView.transition(with: self.backgroundImage,
                      duration: 0.25,
                      options: .transitionCrossDissolve,
                      animations: {
                        self.backgroundImage.backgroundColor = onboardItem.backgroundColor
                        self.backgroundImage.sd_setImage(with: URL(string:onboardItem.backgroundImageURL), placeholderImage:nil, options: .avoidAutoSetImage, completed: { (image, _, type, _) -> Void in
                          if (image != nil) {
                            self.backgroundImage.image = image
                          }
                        })
    },completion: nil)
  }

  @IBAction func getStartedPressed(_ sender: Any) {
  }
}



//  Collection View FlowLayout Delegate & Data Source

extension OnboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.onboarding.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
    let onboardItem = self.onboarding[indexPath.row]
    cell.configureCell(onboardItem)
    cell.tag = indexPath.item
    cell.btnSelect.isHidden = indexPath.item != self.onboarding.count-1
    cell.btnSelect.addTarget(self, action: #selector(getStartedPressed(_:)), for: .touchUpInside)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if self.onboarding[indexPath.item].externalURL != ""{
      if let url = URL(string: self.onboarding[indexPath.item].externalURL){
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.collectionView.didScroll()
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    updateItemDetails()
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    updateItemDetails()
  }
}
