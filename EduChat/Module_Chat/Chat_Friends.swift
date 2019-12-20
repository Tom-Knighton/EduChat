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
        self.table.delegate = self //Sets delegate and data source to this class so we can control the object
        self.table.dataSource = self
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            //controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            return controller
        })() //^ Creates a search bar so we can filter our friends list
        if #available(iOS 11.0, *) { //If user has ios11 or above
            self.navigationItem.searchController = resultSearchController //Put the search bar in the navigation item
        } else {
            self.table.tableHeaderView = resultSearchController.searchBar //Else put it above the table
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateList(_:)), name: .updateFriendshipList, object: nil)
        //^ listen for our update notification to be called
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addUser"), style: .plain, target: self, action: #selector(self.addUser)) // Programatically adds a button to the title bar with the addUser image, and calls addUser when pressed
    }
    
    @objc func addUser() {
        let alert = UIAlertController(title: "Add User", message: "Enter the username of the user", preferredStyle: .alert)
        //Creates an alert ^
        alert.addTextField { (tf) in //Adds a text field we can modify through the local 'tf' variable
            tf.placeholder = "Enter Username" //Sets the placeholder text to Enter Username
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in //Adds the 'add' button
            let tf = alert.textFields![0] as UITextField //Gets the text field
            if tf.text ?? "" == EduChat.currentUser?.UserName ?? "" { self.displayBasicError(title: "Error", message: "Did you just try to add yourself as a friend?"); return; }
            UserMethods.GetUserByUsername(username: tf.text ?? "", completion: { (usr, err) in //Calls API method
                if err != nil { self.displayBasicError(title: "Error", message: "No user was found with that username! :("); return }
                //^ If no user was found display an error
                let friendship = Friendship(FirstUserId: EduChat.currentUser?.UserId ?? 0, SecondUserId: usr?.UserId ?? 0, IsBlocked: false, IsBestFriend: false)! //Create a friendship with this user
                FriendshipMethods.CreateFriendship(friendship: friendship, completion: { (fShip) in //Send that to DB and get return
                    if fShip != nil {
                        if EduChat.currentUser?.Friendships?.contains(where: { $0.SecondUserId == fShip?.SecondUserId }) == true {
                            //^ If we have a friend with this user already (blocked or not)
                            let index = EduChat.currentUser?.Friendships?.firstIndex(where: {$0.SecondUserId == fShip?.SecondUserId}) ?? 0
                            EduChat.currentUser?.Friendships?[index] = fShip! //Finds the existing friendship and replaces it
                            self.table.reloadData() //reload table
                        }
                        else { EduChat.currentUser?.Friendships?.append(fShip!); self.table.reloadData() }
                        //^ Otherwise append the new friendship to our list and reload data
                        
                    } //Add friendship to our user object
                    else { self.displayBasicError(title: "Error", message: "An error occurred adding this user" )}
                })
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //Adds the 'cancel' button
        self.present(alert, animated: true, completion: nil) //Presents the alert on the screen
    }
    @objc func updateList(_ notification : NSNotification) { //When updateFriendsList is called
        self.table.reloadData() //Reload the table, our list has already been updated
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EduChat.currentUser?.Friendships?.count ?? 0 //The table will contain rows for each friend user
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = self.table.dequeueReusableCell(withIdentifier: "chatFriendCell", for: indexPath) as? ChatFriendsCell else { return UITableViewCell() } //Gets the cell as a ChatFriendsCell object
        cell.configureWithItem(friendship: EduChat.currentUser?.Friendships?[indexPath.row]) //Calls configureWithItem on the cell
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 //Sets row height to 80
    }
 
}


