//
//  ProfileSubjectManagerController.swift
//  EduChat
//
//  Created by Tom Knighton on 04/02/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class ProfileSubjectManagerController: UITableViewController {

    var searchBar : UISearchController?
    
    
    var currentSelectedSubjects : [Int] = [] //Global array of selected (toggled) subjects
    var possibleSubjects : [Subject] = [] //Global array of all possible subjects existing in database
    var filteredSubjects : [Subject] = []
    
    var delegate : ProfileControllerDelegate?
    
    override func viewDidLoad() { //When the view is loaded
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100 //Estimate height of each cell at 100 points
        self.tableView.rowHeight = UITableView.automaticDimension //Row height automatic, will be decided by constaints, but default to above
        searchBar = UISearchController()
        self.navigationItem.searchController = searchBar
        self.searchBar?.searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) { //When the view has just appeared
        super.viewDidAppear(true)
        self.reloadData() //Calls reloadData function, filling the table
        self.createNavButtons() //Adds the 'save' button

    }

    func reloadData() {
        SubjectMethods.GetAllSubjects { (subjects, err) in //Calls API method to get all possible subjects
            if err != nil { self.navigationController?.popViewController(animated: true); return; }
            // ^ if there is an error, pop the controller and return
            self.currentSelectedSubjects = (EduChat.currentUser?.Subjects ?? []).filter { $0.IsEducational ?? false }.compactMap { $0.SubjectId ?? 0 }
            //^ set the current selected subjects to the ids of all the subjects the user is already subscribed to
            self.possibleSubjects = subjects?.filter { $0.IsEducational ?? false } ?? [] //Set the possible subjects to all possible educational subjects
            self.filteredSubjects = self.possibleSubjects
            self.tableView.reloadData() //reload the table
        }
    }
    
    func createNavButtons() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveSubjects)) //Creates button that call saveSubjects() when tapped
        let dismissButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.dismissPressed)) //Creates cancel button
        self.navigationItem.rightBarButtonItems = [saveButton] //Sets the above button as the right button in the navigation item
        if #available(iOS 13, *) { self.navigationItem.leftBarButtonItems = [dismissButton] }
        //If iOS 13 available then screen is modally presented, display cancel button

    }
    
    
    @objc func saveSubjects() {
        let selectedSubjects = currentSelectedSubjects; //Copies our global array to local
        let deSelectedSubjects = self.possibleSubjects.filter { (EduChat.currentUser?.Subjects?.contains($0) ?? false) && self.currentSelectedSubjects.contains($0.SubjectId ?? 0) == false}.compactMap { $0.SubjectId ?? 0 } //All possible subjects, that are contained by the current/old user object, BUT are not in the currentSelected array, i.e. have been unselected
        self.lockAndDisplayActivityIndicator(enable: true) //Locks display
        UserMethods.UnsubscribeUserToSubjects(userid: EduChat.currentUser?.UserId ?? 0, subjects: deSelectedSubjects) { (newUser, err) in
//            ^ Calls unsubscribe API method for all the subjects the user has just deseleted
            if err != nil { self.displayBasicError(title: "Error", message: "An error occurred modifying these subjects"); self.lockAndDisplayActivityIndicator(enable: false); return }
            UserMethods.SubscribeUserToSubjects(userid: EduChat.currentUser?.UserId ?? 0, subjects: selectedSubjects) { (finalUser, err) in
//                 ^ then calls Subscribe API method for all the now subscribed subjects
                if err != nil { self.displayBasicError(title: "Error", message: "An error occurred modifying these subjects"); self.lockAndDisplayActivityIndicator(enable: false); return }
                EduChat.currentUser = finalUser //Sets our global current user to the final returned user
                
                self.delegate?.reloadAllData()
                guard #available(iOS 13, *) else { self.navigationController?.popViewController(animated: true); return /*Pops the view*/ }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func dismissPressed() {
        self.dismiss(animated: true) {
            self.delegate?.reloadAllData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //1 section
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredSubjects.count //Sets the row count to the numer of possible subjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSubjectManagerCell", for: indexPath) as? ProfileSubjectManagerCell else { return UITableViewCell() } //Tries to get the set cell as a ProfileSubjectManagerCell class, else just returns
        cell.populate(with: self.filteredSubjects[indexPath.row], selectedSubjectIds: self.currentSelectedSubjects) //Populates cell with data
        cell.profileSubjectManagerDelegate = self //Sets the delegate to this class
        return cell
    }
    
}

extension ProfileSubjectManagerController : ProfileSubjectManagerDelegate {
    
    func selectSubject(SubjectId: Int) {
        self.currentSelectedSubjects.append(SubjectId) //Adds selected subject to global list
        self.tableView.reloadData() //reloads table
    }
    
    func unselectSubject(SubjectId: Int) {
        self.currentSelectedSubjects.removeAll(where: { $0 == SubjectId }) //Removes selected subject from list
        self.tableView.reloadData() //reloads table
    }
    
    
}

extension ProfileSubjectManagerController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSubjects = searchText.isEmpty ? self.possibleSubjects : self.possibleSubjects.filter { $0.SubjectName?.range(of: searchText, options: .caseInsensitive) != nil }
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredSubjects = self.possibleSubjects
        self.tableView.reloadData()
    }
}
