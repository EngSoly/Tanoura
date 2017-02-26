//
//  ApplicationCoordinator.swift
//  OfferMe
//
//  Created by NSMohamedElalfy on 2/15/17.
//  Copyright © 2017 NSMohamedElalfy. All rights reserved.
//

import Foundation
import UIKit


protocol Coordinator {
  func start()
}

class ApplicationCoordinator: Coordinator {
  let window: UIWindow
  let rootViewController  = UITabBarController()
  
  /*let offersNavigationController = UINavigationController()
  let profileNavigationController = UINavigationController()
  
  let offersCoordinator : OffersCoordinator
  let profileCoorinator : ProfileCoordinator*/
  
  init(window : UIWindow) {
    self.window = window
    /*self.offersCoordinator = OffersCoordinator(presenter: offersNavigationController)
    self.profileCoorinator = ProfileCoordinator(presenter: profileNavigationController)
    
    self.rootViewController.setViewControllers(setViewControllers(), animated: false)*/
  }
  
  /*func setViewControllers()-> [UIViewController] {
    offersNavigationController.tabBarItem = UITabBarItem(title: "Offers", image: #imageLiteral(resourceName: "first"), selectedImage: nil)
    profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "second"), selectedImage: nil)
    return [offersNavigationController , profileNavigationController]
  }*/
  
  func start() {
    self.window.rootViewController = rootViewController
    //self.offersCoordinator.start()
    //self.profileCoorinator.start()
    self.window.makeKeyAndVisible()
  }
  
}


class OffersCoordinator : Coordinator {
  
  let presenter : UINavigationController
  
  //let offersTableViewController : GenericTableViewController<Offer , OfferCell>
  
  init(presenter : UINavigationController) {
    self.presenter = presenter
    /*self.offersTableViewController = GenericTableViewController(items: [Offer(title:"Offer Title 1" , description : "Bla Bla Bla"),Offer(title:"Offer Title 2", description : "Bla Bla Bla"),Offer(title:"Offer Title 3", description : "Bla Bla Bla"),Offer(title:"Offer Title 4", description : "Bla Bla Bla"),Offer(title:"Offer Title 5", description : "Bla Bla Bla"),Offer(title:"Offer Title 6", description : "Bla Bla Bla")], configureCell: { (cell: OfferCell, offer : Offer) in
      cell.textLabel?.text = offer.title
      cell.detailTextLabel?.text = offer.description
    })
    self.offersTableViewController.didSelect = { (offer , indexPath) in
      print("\(offer.title) will begain at \(offer.description)")
      self.offersTableViewController.tableView.deselectRow(at: indexPath, animated: true)
    }*/
    
  }
  
  func start() {
    //self.presenter.pushViewController(offersTableViewController, animated: false)
  }
}

class ProfileCoordinator : Coordinator {
  
  let presenter : UINavigationController
  
  init(presenter : UINavigationController) {
    self.presenter = presenter
  }
  
  func start() {
    
  }
}





