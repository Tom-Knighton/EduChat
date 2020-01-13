//
//  Profile_Subject_Manager.swift
//  EduChat
//
//  Created by Tom Knighton on 04/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

protocol SubjectManagerDelegate {
    func subjectToggled(toggled : Bool?, sub : Subject?)
}
class Profile_Subject_Manager: UIViewController, SubjectManagerDelegate {
    
    func subjectToggled(toggled : Bool?, sub : Subject?) {
        if toggled ?? false { //If switch is on, add Id to selectedIds
            self.selectedIds.append(sub?.SubjectId ?? 0)
        }
        else {
            if self.selectedIds.contains(sub?.SubjectId ?? 0) { //If it is off and SelectedIds contains the id, remove it
                self.selectedIds.remove(at: self.selectedIds.firstIndex(of: sub?.SubjectId ?? 0) ?? 0)
            }
        }
    }
    

    @IBOutlet weak var subjectsTable: UITableView!
    
   
    var possibleSubjects : [Subject] = [] //All possible subjects
    var filteredSubjects : [Subject] = [] //Subjects after being filtered from searchbar
    
    var selectedIds : [Int] = [] //Ids of selected subjects
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.subjectsTable.delegate = self
        self.subjectsTable.dataSource = self
        
        self.filteredSubjects = possibleSubjects //Sets filtered subjects originally to all of them
        EduChat.currentUser?.Subjects?.forEach({ (sub) in
            selectedIds.append(sub.SubjectId ?? 0) //Fill selected ids with already subacribed ones
        })
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            return controller
        })()
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = resultSearchController
        } else {
            self.subjectsTable.tableHeaderView = resultSearchController.searchBar
        }
        // ^ create search bar
        self.possibleSubjects.removeAll() //remove all possible subjects before filling
        SubjectMethods.GetAllSubjects { (subjects, err) in
            if err == nil {
                subjects?.forEach({ (sub) in
                    if sub.IsEducational ?? false { self.possibleSubjects.append(sub)}
                })
                // ^ gets all possible subjects that are educational and fills possibleSubjects with them
                self.subjectsTable.reloadData()
                //Reloads the table
            }
        }
        
       
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let selected = self.selectedIds
        var deSelected : [Int] = [] //Creates basic arrays for selected and deselected ids
        self.possibleSubjects.forEach { (sub) in
            if EduChat.currentUser?.Subjects?.contains(sub) ?? true && !selected.contains(sub.SubjectId ?? 0) { deSelected.append(sub.SubjectId ?? 0) }
            //Loops through each subject in possibleSubjects, if the current user object is subscribed to that subject and it is no longer selected in the view, add it to the deselected array
        }
        UserMethods.UnsubscribeUserToSubjects(userid: EduChat.currentUser?.UserId ?? 0, subjects: deSelected) { (User, err) in
            //Unsubscribes the user to the deselected subjects
            if err == nil {
                UserMethods.SubscribeUserToSubjects(userid: EduChat.currentUser?.UserId ?? 0, subjects: selected, completion: { (User, err) in
                    //Subscribes the user to the selected subjects
                    if err == nil {
                        //Sets the current user object to our new user
                        EduChat.currentUser = User
                        //Dismisses the view
                        self.navigationController?.popViewController(animated: true)
                    }
                    else { self.displayBasicError(title: "Error", message: "Unable to manage subjects") }
                })
            }
            else { self.displayBasicError(title: "Error", message: "Unable to manage subjects") }
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension Profile_Subject_Manager: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive { return self.filteredSubjects.count }
        else { return self.possibleSubjects.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.subjectsTable.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as? Profile_Subject_Cell else { return UITableViewCell() }
        
        
        if (resultSearchController.isActive) {
            let current = self.filteredSubjects[indexPath.row]
            cell.configureCellWithItem(subject: current)
        }
        else {
            let current = self.possibleSubjects[indexPath.row]
            cell.configureCellWithItem(subject: current)
        }
        return cell
    }
    
    @objc func switchToggled(_ sender : UISwitch?) {
        
    }
}

extension Profile_Subject_Manager : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.trim() != nil {
            filteredSubjects.removeAll()
            
            let filterSubjects = self.possibleSubjects.filter({ sub in
                return sub.SubjectName?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false
            })
            self.filteredSubjects = filterSubjects
            self.subjectsTable.reloadData()
        }
       
    }
    
    
}
