//
//  FeedMainTable.swift
//  EduChat
//
//  Created by Tom Knighton on 17/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import PinterestSegment

class FeedMainTable: UITableViewController {
    
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
        return PinterestSegment(frame: CGRect(x: 20, y: 200, width: self.view.frame.width, height: 40), segmentStyle: self.segmentStyle, titles: ["Social", "English", "English A-Level", "Maths", "Maths A-Level", "Further Maths", "History", "History A-Level", "Politics", "Computer Science", "Computer Science A-Level"]) //Filled segment with dummy subjects for now
    }()
    override func viewDidLoad() {
        super.viewDidLoad() //Calls super method
        self.tableView.dataSource = self; self.tableView.delegate = self
        self.tableView.tableHeaderView = self.segment //Sets our header to the segment control
        //self.tableView.tableHeaderView?.layer.borderColor = UIColor.red.cgColor //Lays out a border temporarily
        //self.tableView.tableHeaderView?.layer.borderWidth = 0.5 //So we can see where it draws
        
        self.tableView.estimatedRowHeight = 900
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "feedCellImagePost", for: indexPath) as? FeedPostContentCell else { return UITableViewCell() }
        cell.postImageView?.sd_setImage(with: URL(string: EduChat.currentUser?.UserProfilePictureURL ?? "")!, completed: nil)
        return cell
    }
    
}
