//
//  InfoViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 5/31/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class InfoViewController: UICollectionViewController {

    let auth = FIRAuth.auth()
    let ref = FIRDatabase.database().reference()
    var userProfile:User?
    
    var arrUrlString:[String] = []
    
    let cellId = "cellId"
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupCollectionView()
        getImageUser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if userProfile != nil {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            self.navigationItem.title = self.userProfile?.username
        }
    }
    
    func setupCollectionView() {
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(ImageUserCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.register(HeaderProfile.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfile")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        collectionView!.collectionViewLayout = layout
    }
    
    
    
    //MARK:- Support functions
    
    private func getImageUser() {
        Firebase.shared.getChildData(TableName.userPost, (aut?.currentUser?.uid)!, .childAdded) { [weak self] (data, key, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if let value = data {
                    let urlString = value["urlString"] as? String ?? ""
                    strongSelf.arrUrlString.insert(urlString, at: 0)
                    DispatchQueue.main.async {
                        strongSelf.collectionView?.reloadData()
                        ProgressHUD.dismiss()
                    }
                }
            } else {
                ProgressHUD.showError(error)
            }
        }
    }
}


extension InfoViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUrlString.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageUserCell
        let urlString = arrUrlString[indexPath.row]
        cell.imgString = urlString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 88)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfile", for: indexPath) as! HeaderProfile
        if let user = self.userProfile {
            headerViewCell.configHeader(user: user)
        }
        
        headerViewCell.completionEdit = { [weak self] in
            guard let strongSelf = self else { return }
            let editProfile = EditProfileViewController()
            editProfile.userProfile = strongSelf.userProfile
            editProfile.imageView.image = headerViewCell.imgAvatar.image
            editProfile.hidesBottomBarWhenPushed = true
            strongSelf.navigationItem.title = ""
            strongSelf.navigationController?.navigationBar.tintColor = .black
            strongSelf.navigationController?.pushViewController(editProfile, animated: true)
        }
        
        return headerViewCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 150)
    }
    
    
}


