//
//  MainCoordinator.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 2/27/17.
//  Copyright © 2017 NSMohamedElalfy. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator : Coordinator {
  
  let presenter : UINavigationController
  
  var mainViewController : MainViewController!
  
  init(presenter : UINavigationController) {
    self.presenter = presenter
    self.presenter.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.presenter.navigationBar.shadowImage = UIImage()
    self.presenter.navigationBar.tintColor = .white
    
    self.mainViewController = MainViewController(tracks: [], gradients: getGradientsData())
    
  }
  
  func start() {
    self.presenter.pushViewController(mainViewController, animated: false)
  }
  
  func getGradientsData() -> [Gradient] {
    
    var gradients = [Gradient]()
    let path = Bundle.main.path(forResource: "Gradients" , ofType: "json")!
    let url = URL(fileURLWithPath: path)
    
    do{
      let data = try Data(contentsOf: url)
      let json = try JSONSerialization.jsonObject(with: data , options: []) as! [JSONDictionary]
      
      for item in json {
        gradients.append(Gradient(dictionary: item)!)
      }
    }catch{print("error in loading and Parsing JSON file")}
    
    return gradients
  }
  
}
