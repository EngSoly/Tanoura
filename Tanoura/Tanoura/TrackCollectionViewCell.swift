//
//  TrackCollectionViewCell.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 12/7/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import UIKit
import DynamicButton
import SwifterSwift
import SnapKit
import ChameleonFramework

class TrackCollectionViewCell: UICollectionViewCell {
  
  var didSetupConstraints = false
  
  var roundedView =  UIView()
  var playDynamicButton = DynamicButton(style: DynamicButtonStyle.play)
  var trackNameLabel = UILabel()
  var deleteDynamicButton = DynamicButton(style: DynamicButtonStyle.close)
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    [roundedView,playDynamicButton,trackNameLabel,deleteDynamicButton].forEach{contentView.addSubview($0)}
    roundedView.cornerRadius = 10
    trackNameLabel.text = "Name"
    trackNameLabel.textColor = .white
    playDynamicButton.strokeColor = .white
    deleteDynamicButton.strokeColor = .white
    deleteDynamicButton.backgroundColor = FlatRed()
    deleteDynamicButton.cornerRadius = 7
    setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func updateConstraints() {
    
    if (!didSetupConstraints) {
      // rounded View
      roundedView.snp.makeConstraints{ make in
        make.edges.equalTo(contentView)
      }
      
      playDynamicButton.snp.makeConstraints{ make in
        make.leadingMargin.equalTo(contentView).inset(8)
        make.centerY.equalTo(contentView)
      }
      
      trackNameLabel.snp.makeConstraints{ make in
        make.trailingMargin.equalTo(contentView).inset(8)
        make.centerY.equalTo(contentView)
      }

      deleteDynamicButton.snp.makeConstraints{ make in
        make.topMargin.trailingMargin.equalTo(contentView).inset(4)
        make.width.height.equalTo(14)
      }
      
      didSetupConstraints = true
    }
    
    super.updateConstraints()
    
  }
  
}
