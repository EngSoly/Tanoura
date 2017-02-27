//
//  ApplicationCoordinator.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 2/15/17.
//  Copyright © 2017 NSMohamedElalfy. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import ChameleonFramework

protocol Coordinator {
  func start()
}

class ApplicationCoordinator: Coordinator {
  let window: UIWindow
  
  let mainCoordinator : MainCoordinator
  let playlistsCoordinator : PlaylistsCoordinator
  
  var rootViewController : SlideMenuController!
  
  init(window : UIWindow) {
    self.window = window
    
    mainCoordinator  = MainCoordinator(presenter: UINavigationController())
    playlistsCoordinator  = PlaylistsCoordinator(presenter: UINavigationController())

    self.rootViewController = SlideMenuController(mainViewController: mainCoordinator.presenter, leftMenuViewController: playlistsCoordinator.presenter)
    rootViewController.setStatusBarStyle(.lightContent)
  }
  
  func start() {
    guard let root = self.rootViewController else {return}
    window.rootViewController = root
    mainCoordinator.start()
    playlistsCoordinator.start()
    window.makeKeyAndVisible()
  }
  
}





