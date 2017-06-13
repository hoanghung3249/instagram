//
//  NotificationViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/7/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit

class NotificationViewController: UITableViewController {

    
    let cellID = "cellId"
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupNavigation()
        self.setupTable()
    }
    
    
    //MARK:- Support functions
    private func setupNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Billabong", size: 30)!]
        self.navigationItem.title = "Activity"
    }
    
    
    private func setupTable() {
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: cellID)
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 150.0
    }


}



extension NotificationViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NotificationCell
        cell.lblState.text = "\(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}
