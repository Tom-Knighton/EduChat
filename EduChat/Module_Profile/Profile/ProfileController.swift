//
//  ProfileController.swift
//  EduChat
//
//  Created by Tom Knighton on 03/02/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

enum ProfileTableViewSectionTypes {
    case ProfileHeader
    case ProfileSubjects
    case ProfilePosts
}

protocol ProfileControllerDelegate {
    func updateSubjects()
    func displaySubjectManager()
    func displayProfileSettings()
    func reloadAllData()
}

class ProfileController: UITableViewController {

    var currentViewingUser : User? = EduChat.currentUser
    var currentViewingUserPosts : [Any?]? = []
    let sections = [ProfileTableViewSectionTypes.ProfileHeader, ProfileTableViewSectionTypes.ProfileSubjects, ProfileTableViewSectionTypes.ProfilePosts]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.currentViewingUser?.UserName ?? "Profile"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentViewingUser = EduChat.currentUser
        self.createNavItemButtons()
        self.title = self.currentViewingUser?.UserName ?? "Profile"
        self.tableView.reloadData()
        self.loadPosts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func loadPosts() {
        DispatchQueue.global(qos: .background).async {
            UserMethods.GetAllFeedPosts(for: self.currentViewingUser?.UserId ?? 0) { (posts) in
                self.currentViewingUserPosts = posts
                self.tableView.reloadData()
            }
        }
    }
    
    func createNavItemButtons() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "smallSettingsCog"), style: .plain, target: self, action: #selector(displayAppSettings))
        if #available(iOS 13, *) { settingsButton.tintColor = .label; } else { settingsButton.tintColor = .black; }
        self.navigationItem.rightBarButtonItems = [settingsButton]
    }
    @objc func displayAppSettings() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppSettingsViewController") as? AppSettingsController else { return; }
        guard #available(iOS 13, *) else {
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        self.present(nav, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .ProfileHeader:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "profileHeaderCell", for: indexPath) as? ProfileHeaderCell else { return UITableViewCell() }
            cell.delegate = self
            cell.populate(with: self.currentViewingUser)
            return cell
        case .ProfileSubjects:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "profileSubjectsCell", for: indexPath) as? ProfileSubjectsCell else { return UITableViewCell() }
            cell.delegate = self
            cell.populate(with: self.currentViewingUser?.Subjects)
            return cell
        case .ProfilePosts:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "profilePostsCell", for: indexPath) as? ProfilePostsCell else { return UITableViewCell() }
            cell.populate(with: self.currentViewingUserPosts ?? [])
            return cell
        }
    }
}

extension ProfileController : ProfileControllerDelegate {
    func reloadAllData() {
        self.currentViewingUser = EduChat.currentUser
        self.title = self.currentViewingUser?.UserName ?? "Profile"
        self.tableView.reloadData()
    }
    
    func updateSubjects() { }
    
    func displayProfileSettings() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSettingsController") as? ProfileSettingsController else { return; }
        vc.delegate = self
        guard #available(iOS 13, *) else {
            self.navigationController?.pushViewController(vc, animated: true)
            return;
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        self.present(nav, animated: true, completion: nil)
    }
    
    func displaySubjectManager() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSubjectManager") as? ProfileSubjectManagerController else { return; }
        vc.delegate = self
        guard #available(iOS 13, *) else {
            self.navigationController?.pushViewController(vc, animated: true)
            return;
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        self.present(nav, animated: true, completion: nil)
    }
    
    
}

