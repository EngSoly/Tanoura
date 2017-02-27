//
//  MainViewController.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 12/3/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework
import SlideMenuControllerSwift
import DynamicButton
import ActionKit
import SwiftyTimer


class MainViewController: UIViewController {
  
  struct Identifiers {
    static let TrackCellID = "TrackCellID"
    static let AddTrackHeaderID = "AddTracksID"
  }
  
 
  // MARK: UI Components
  let containerView : UIView = {
    let container = UIView()
    container.borderWidth = 10
    container.borderColor = UIColor.white
    return container
  }()
  
  let tracksCollectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionHeadersPinToVisibleBounds = true
    layout.itemSize = CGSize(width: 120, height: 70)
    layout.headerReferenceSize = CGSize(width: 60, height: 80)
    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 5
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.register(AddTrackCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifiers.AddTrackHeaderID)
    collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.TrackCellID)

    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  let openTracksBtn : DynamicButton = {
    let button = DynamicButton(style: DynamicButtonStyle.caretUp)
    button.strokeColor = .white
    return button
  }()
  
  
  let tanouraVC : TanouraViewController = {
    let tvc = TanouraViewController()
    tvc.view.translatesAutoresizingMaskIntoConstraints = false
    return tvc
  }()
  
  
  
  var didSetupConstraints = false
  var isOpen = false
  var gradientLayer : CAGradientLayer?
  var toColors : [CGColor]!
  var fromColors : [CGColor]!
  
  var didTapTracksPicker : () -> () = { _ in }
  
  let gradients : [Gradient]
  var tracks : [Track] = [] {
    didSet{
      tracksCollectionView.reloadData()
    }
  }

  init(tracks : [Track] , gradients : [Gradient]){
    self.gradients = gradients
    super.init(nibName: nil, bundle: nil)
    self.tracks = tracks
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
    fromColors = [UIColor(hexString: "#5C258D")!.cgColor , UIColor(hexString: "#4389A2")!.cgColor]
    
    gradientLayer = CAGradientLayer()
    gradientLayer!.colors = fromColors!
    gradientLayer!.frame = view.bounds
    view.layer.addSublayer(gradientLayer!)
    
    Timer.every(15.0.seconds) {
      
      let gradient = self.gradients.randomItem
      self.toColors = [UIColor(hexString: gradient.colors[0])!.cgColor , UIColor(hexString: gradient.colors[1])!.cgColor]

      self.changeColors()
    }
    
    
    containerView.cornerRadius = (view.frame.width - 10) / 2
    view.addSubview(containerView)
    
    
    self.addChildViewController(tanouraVC)
    self.containerView.addSubview(tanouraVC.view)
    tanouraVC.view.frame = self.containerView.bounds
    tanouraVC.didMove(toParentViewController: self)
    tanouraVC.delegate = self
    
    tracksCollectionView.dataSource = self
    tracksCollectionView.delegate = self
    view.addSubview(tracksCollectionView)
    
    openTracksBtn.addControlEvent(.touchUpInside) { (dynamicButton: DynamicButton!) in
      let offset = self.isOpen ? 0:80
      dynamicButton.style = self.isOpen ? DynamicButtonStyle.caretUp:DynamicButtonStyle.caretDown
      
      UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
        self.tracksCollectionView.snp.updateConstraints{ make in
          make.top.equalTo(self.view.snp.bottom).inset(offset)
        }
        self.tracksCollectionView.superview?.layoutIfNeeded()
      }, completion: { (isComplete:Bool) in
        self.isOpen = !self.isOpen
      })
    }
    view.addSubview(openTracksBtn)
    
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")!, actionClosure: { 
      self.slideMenuController()?.openLeft()
    })
    
    view.setNeedsUpdateConstraints()
    
  }
  
  func changeColors(){
    let colors = gradientLayer!.presentation()?.colors // save the in-flight current colors
    gradientLayer!.removeAnimation(forKey: "animateGradient")      // cancel the animation
    gradientLayer!.colors = colors                                // restore the colors to in-flight values
    animateLayer()
  }
  
  func animateLayer() {
    let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
    animation.fromValue = gradientLayer!.colors
    animation.toValue = toColors
    animation.duration = 1.0
    animation.isRemovedOnCompletion = true
    animation.fillMode = kCAFillModeForwards
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.delegate = self
    gradientLayer!.colors = toColors
    gradientLayer!.add(animation, forKey:"animateGradient")
  }
  
  
  override func updateViewConstraints() {
    if (!didSetupConstraints) {
      
      // tanoura view Constraints
      containerView.snp.makeConstraints{ make in
        make.width.height.equalTo(view.snp.width).inset(10)
        make.center.equalTo(view)
      }
      
      // tracks view Constraints
      tracksCollectionView.snp.makeConstraints{ make in
        make.right.left.equalTo(view)
        make.top.equalTo(view.snp.bottom)
        make.height.equalTo(80)
      }
      
      // openTracks Button Constraints
      openTracksBtn.snp.makeConstraints{ make in
        make.bottom.equalTo(tracksCollectionView.snp.top)
        make.centerX.equalTo(view)
      }
      
      didSetupConstraints = true
    }
    
    super.updateViewConstraints()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}


extension MainViewController : CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      swap(&toColors, &fromColors)
      //animateLayer()
    }
  }
}

extension MainViewController : TanouraViewControllerDelegate {
  
  func touchDidBegin(flag: Bool) {
    
  }
  
  func rendered(image: CIImage) {
    
  }
  
}


extension MainViewController : UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tracks.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.TrackCellID, for: indexPath) as! TrackCollectionViewCell
    cell.roundedView.backgroundColor = RandomFlatColorWithShade(.dark)
    cell.playDynamicButton.addControlEvent(.touchUpInside) { (dynamicButton : DynamicButton) in
      dynamicButton.setStyle(DynamicButtonStyle.pause, animated: true)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifiers.AddTrackHeaderID , for: indexPath) as! AddTrackCollectionReusableView
    
    header.dynamicButton.addControlEvent(.touchUpInside) { (dynamicButton: DynamicButton!) in
    self.didTapTracksPicker()
      
    }
    
    return header
  }
   
}

extension MainViewController : UICollectionViewDelegate {
  
}





