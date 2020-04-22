//
//  FeedMainTable.swift
//  EduChat
//
//  Created by Tom Knighton on 17/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

protocol FeedMainTableDelegate {
    func UpdatePost(post: FeedPost?)
}

class FeedMainTable: UITableViewController {
    
    var selectedSubject = 1
    
    lazy var segmentStyle : PinterestSegmentStyle = { [unowned self] in //Lazily creates a style object
        var style = PinterestSegmentStyle() //A lazy var only calls this object into memory when needed
        style.indicatorColor = UIColor(white: 0.95, alpha: 1) //Basic UI layout below
        style.titleMargin = 15
        style.titlePendingHorizontal = 14
        style.titlePendingVertical = 14
        style.titleFont = UIFont.boldSystemFont(ofSize: 14)
        style.normalTitleColor = UIColor.lightGray
        style.selectedTitleColor = UIColor.darkGray
        return style //Returns the style when called
    }()
    lazy var segment : PinterestSegment = { [unowned self ] in //Lazily creates segment object
        return PinterestSegment(frame: CGRect(x: 20, y: 200, width: self.view.frame.width, height: 40), segmentStyle: self.segmentStyle, subjects: EduChat.currentUser?.Subjects ?? []) //Filled segment with dummy subjects for now
    }()
    
    var postsToDisplay : [FeedPost?] = [] //global array holding all posts
    let refresher = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad() //Calls super method
        self.tableView.dataSource = self; self.tableView.delegate = self
        self.tableView.tableHeaderView = self.segment //Sets our header to the segment control
       
        self.tableView.refreshControl = refresher
        self.refresher.addTarget(self, action: #selector(refreshPulled(_:)), for: .valueChanged)
        self.tableView.estimatedRowHeight = 444 //Random height
        self.tableView.rowHeight = UITableView.automaticDimension
        //^ resizes the cell depending on labels and heights of everything in cell
        self.createAddButton()
        segment.valueChange = { sId in self.changeSubject(subjectId: sId); }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FeedMethods.GetAllPostsForSubject(subjectId: selectedSubject) { (newPosts) in
            //^ Calls GetAllPostsForSubject with our new subjectid value from the picker
            self.postsToDisplay = newPosts ?? [] //Sets the global array to the new posts
            self.tableView.reloadData() //Reloads table
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.postsToDisplay.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = self.postsToDisplay[indexPath.section] //Gets the object in the array for the row
        if post is FeedTextPost { //If the post is a FeedTextPost object
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "feedCellTextPost", for: indexPath) as? FeedCellTextPost else { return UITableViewCell() } //Get the cell as a FeedCellTextPost
            cell.populate(with: post as! FeedTextPost) //Calls populate() on the cell
            cell.feedDelegate = self
            return cell
        }
        else if post is FeedMediaPost { //Same as above but for FeedMediaPosts
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "feedCellMediaPost", for: indexPath) as? FeedCellMediaPost else { return UITableViewCell() }
            cell.populate(with: post as! FeedMediaPost)
            cell.feedDelegate = self
            return cell
        }
        else if post is FeedPoll {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "feedCellPollPost", for: indexPath) as? FeedPollCell else { return UITableViewCell() }
            cell.populate(with: post as! FeedPoll)
            return cell
        }
        else if post is FeedQuiz {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "feedCellQuizPost", for: indexPath) as? FeedQuizCell else { return UITableViewCell() }
            cell.populate(with: post as! FeedQuiz)
            return cell
        }
        else { return UITableViewCell() }
    }
    
}

extension FeedMainTable : FeedMainTableDelegate {
    func UpdatePost(post: FeedPost?) {
        if post is FeedTextPost {
            let index = self.postsToDisplay.firstIndex(where: {$0?.PostId == post?.PostId}) ?? 0
            self.postsToDisplay[index] = post
        } //^ And below get index of the post to be modified and replace it with the new post
        else if post is FeedMediaPost {
            let index = self.postsToDisplay.firstIndex(where: {$0?.PostId == post?.PostId}) ?? 0
            self.postsToDisplay[index] = post
        }
        else if post is FeedPoll {
            let index = self.postsToDisplay.firstIndex(where: {$0?.PostId == post?.PostId}) ?? 0
            self.postsToDisplay[index] = post
            let indexPath = IndexPath(item: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        else if post is FeedQuiz {
            let index = self.postsToDisplay.firstIndex(where: {$0?.PostId == post?.PostId}) ?? 0
            self.postsToDisplay[index] = post
        }
    }
    
    @objc private func refreshPulled(_ sender: Any) {
        self.reloadAllData()
    }
    
    func reloadAllData() {
        FeedMethods.GetAllPostsForSubject(subjectId: 1) { (posts) in
            self.postsToDisplay = posts ?? []
            self.refresher.endRefreshing()
            self.tableView.reloadData() //Reloads the table
        }
    }
}

extension FeedMainTable {
    func createAddButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(createPostButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .flatBlack()
    }
    
    @objc func createPostButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Upload Post", message: "Select which type of post to upload", preferredStyle: .alert)
        //Asks user to uplaod post or quiz
        alert.addAction(UIAlertAction(title: "Feed Post (Post/Poll)", style: .default, handler: { (_) in //On feed post
            guard let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "feedCreateView") as? FeedCreateController else { return; }
            vc.selectedSubject = self.selectedSubject //^ Displays the feedCreateView in the view controller
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Quiz", style: .default, handler: { (_) in //On quiz
            guard let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "feedCreateQuizView") as? FeedCreateQuizController else { return; }
            vc.selectedSubject = self.selectedSubject //Displays the feedCreateQuizView in the view controller
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //cancel
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeSubject(subjectId: Int) {
        self.selectedSubject = subjectId
        self.postsToDisplay = []; self.tableView.reloadData() //Wipes table
        FeedMethods.GetAllPostsForSubject(subjectId: subjectId) { (newPosts) in
            //^ Calls GetAllPostsForSubject with our new subjectid value from the picker
            self.postsToDisplay = newPosts ?? [] //Sets the global array to the new posts
            self.tableView.reloadData() //Reloads table
        }
    }
}
