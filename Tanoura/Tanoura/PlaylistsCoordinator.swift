//
//  PlaylistsCoordinator.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 2/27/17.
//  Copyright © 2017 NSMohamedElalfy. All rights reserved.
//

import Foundation
import UIKit


class PlaylistsCoordinator : Coordinator {
  
  let presenter : UINavigationController
  
  let playlistsTableViewController : GenericTableViewController<Playlist , UITableViewCell>
  
  init(presenter : UINavigationController) {
    self.presenter = presenter
    
    playlistsTableViewController = GenericTableViewController(items: [
      Playlist(name: "Unnamed Playlist", tracks: [])
    ]) { (cell : UITableViewCell, playlist) in
      cell.textLabel?.text = playlist.name
    }
    
    playlistsTableViewController.didSelect = { (playlist , indexPath) in
      
    }
    
  }
  
  func start() {
    self.presenter.pushViewController(playlistsTableViewController, animated: false)
  }
}
