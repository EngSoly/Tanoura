//
//  Gradient.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 12/15/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import Foundation


typealias JSONDictionary = [String: AnyObject]

struct Gradient {
  var name : String
  var colors : [String]
}


extension Gradient {
  init?(dictionary:JSONDictionary){
    guard let name = dictionary["name"] as? String ,let colors = dictionary["colors"] as? [String] else{return nil}
    self.name = name ; self.colors = colors
  }
}
