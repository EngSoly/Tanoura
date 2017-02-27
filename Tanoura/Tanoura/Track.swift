//
//  Track.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 2/26/17.
//  Copyright © 2017 NSMohamedElalfy. All rights reserved.
//

import Foundation


struct Track {
  
  let name : String
  let type : String
  
  var path : String {
    return Bundle.main.path(forResource: name, ofType: type)!
  }
  
}
