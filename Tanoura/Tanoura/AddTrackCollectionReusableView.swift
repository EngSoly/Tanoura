//
//  AddTrackCollectionReusableView.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 12/8/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import UIKit
import DynamicButton
import SnapKit
import ChameleonFramework

class AddTrackCollectionReusableView: UICollectionReusableView {
  
  var didSetupConstraints = false
  
  var dynamicButton = DynamicButton(style: DynamicButtonStyle.plus)
 
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = FlatWhiteDark()
    dynamicButton.strokeColor = .white
    addSubview(dynamicButton)
    setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func updateConstraints() {
    
    if (!didSetupConstraints) {
      
      dynamicButton.snp.makeConstraints{ make in
        
        make.center.equalTo(self)
        
      }
      
      didSetupConstraints = true
    }
    
    super.updateConstraints()
    
  }

  
}
