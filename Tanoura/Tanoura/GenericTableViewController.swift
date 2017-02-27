//
//  GenericTableViewController.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 2/15/17.
//  Copyright © 2017 NSMohamedElalfy. All rights reserved.
//

import UIKit

class GenericTableViewController<Item,Cell: UITableViewCell>:UITableViewController {
  
  // MARK: - Properties
  
  let cellIdentifier = "reuseIdentifier"
  let configureCell : (Cell , Item) -> ()
  var items : [Item] = [] {
    didSet{
      tableView.reloadData()
    }
  }
  var didSelect : (Item , IndexPath) -> () = { _ in}
  
  
  // MARK: - Initializers
  init(items:[Item] , configureCell : @escaping (Cell , Item) -> ()){
    self.configureCell = configureCell
    super.init(style: .plain)
    self.items = items
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifier)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return items.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier , for: indexPath) as! Cell
    let item = self.items[indexPath.row]
    // Configure the cell...
    configureCell(cell , item)
    return cell
  }
  
  // MARK: - Table view delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = self.items[indexPath.row]
    didSelect(item , indexPath)
  }
  
}
