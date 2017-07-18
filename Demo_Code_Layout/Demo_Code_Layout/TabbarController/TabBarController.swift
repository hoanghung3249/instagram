//
//  TabBarController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 5/31/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    var curUser:User?
    
//MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getCurrentUser { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setupViewControllers()
        }
        self.tabBar.tintColor = UIColor.black
        self.view.backgroundColor = .white
    }
    
    
//MARK:- Support function
    func setupViewControllers() {
        let homeVC = HomeViewController()
        homeVC.curUser = self.curUser
        let navHomeVC = UINavigationController(rootViewController: homeVC)
        navHomeVC.navigationBar.isTranslucent = false
        navHomeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Home"), selectedImage: UIImage(named: "Home_Selected"))
        
        let camera = CameraViewController()
        camera.userName = self.curUser?.username
        camera.urlAvatar = self.curUser?.avatarUrl
        let navCamera = UINavigationController(rootViewController: camera)
        navCamera.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Photo"), selectedImage: UIImage(named: "Photo"))
        
        let search = SearchViewController()
        let navSearch = UINavigationController(rootViewController: search)
        navSearch.navigationBar.backgroundColor = .white
        navSearch.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Search"), selectedImage: UIImage(named: "Search_Selected"))

        let layout = UICollectionViewFlowLayout()
        let infoVC = InfoViewController(collectionViewLayout: layout)
        infoVC.userProfile = self.curUser
        let navInfo = UINavigationController(rootViewController: infoVC)
        navInfo.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Profile"), selectedImage: UIImage(named: "Profile_Selected"))
        
        let noti = NotificationViewController()
        let navNoti = UINavigationController(rootViewController: noti)
        navNoti.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Activity"), selectedImage: UIImage(named: "Activity_Selected"))
        
        self.viewControllers = [navHomeVC,navSearch,navCamera,navNoti,navInfo]
        
        self.selectedViewController = navHomeVC
        
    }
    
    
    
    private func getCurrentUser(completion:@escaping ()->()) {
        Firebase.shared.getCurUser(TableName.user, (aut?.currentUser?.uid)!, .value) { [weak self] (data, key, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                guard let value = data else { return }
                var currentUser = User()
                currentUser.avatarUrl = value["avatar"] as? String ?? ""
                currentUser.username = value["username"] as? String ?? ""
                currentUser.email = value["email"] as? String ?? ""
                currentUser.uid = aut?.currentUser?.uid ?? ""
                strongSelf.curUser = currentUser
                completion()
            } else {
                ProgressHUD.showError(error!)
            }
        }
    }

}

