//
//  Chat_Friends.swift
//  EduChat
//
//  Created by Tom Knighton on 06/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class Chat_Friends: UITableViewController {

    @IBOutlet var table: UITableView!
    //let tstData = ["Tom Knightn", "Bob Dylan", "Test Account", "Name"]
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            //controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            return controller
        })()
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = resultSearchController
        } else {
            self.table.tableHeaderView = resultSearchController.searchBar
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateList(_:)), name: .updateFriendshipList, object: nil)
    }
    
    @objc func updateList(_ notification : NSNotification) {
        self.table.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EduChat.currentUser?.Friendships?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = self.table.dequeueReusableCell(withIdentifier: "chatFriendCell", for: indexPath) as? ChatFriendsCell else { return UITableViewCell() }
        cell.configureWithItem(friendship: EduChat.currentUser?.Friendships?[indexPath.row])
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
 
}


