//
//  AppSettingsController.swift
//  EduChatp
//
//  Created by Tom Knighton on 10/02/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

enum AppSettingsCellTypes {
    case security
    case app
}

class AppSettingsController: UITableViewController {

    let cellTypes : [AppSettingsCellTypes] = [.security, .app]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "App Settings"
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.reloadData()
    }


    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTypes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.cellTypes[indexPath.row]
        switch (type) {
        case .security:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AppSettingsSecurityCell", for: indexPath) as? AppSettingsSecurityCell else { return UITableViewCell() }
            return cell
        case .app:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AppSettingsAppCell", for: indexPath) as? AppSettingsAppCell else { return UITableViewCell() }
            cell.populate()
            return cell          
        }
    }
}
