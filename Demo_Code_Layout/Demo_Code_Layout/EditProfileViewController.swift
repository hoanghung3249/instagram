//
//  EditProfileViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/8/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit

class EditProfileViewController: UIViewController {
    
    var userProfile:User?

    let vwHeader:UIView =  {
        let view:UIView = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var btnChangePhoto:UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Change Profile Photo", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(changeProfilePhoto), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Edit Profile"
        self.addSubview()
        self.setupUI()
    }
    
    
    //MARK:- Support functions
    private func addSubview() {
        self.view.addSubview(vwHeader)
        self.vwHeader.addSubview(imageView)
        self.vwHeader.addSubview(btnChangePhoto)
    }
    
    
    private func setupUI() {
        
        self.vwHeader.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(200)
        }
        
        self.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(vwHeader.snp.centerX)
            make.centerY.equalTo(vwHeader.snp.centerY).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        self.btnChangePhoto.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(vwHeader.snp.centerX)
            make.width.equalTo(200)
            make.bottom.equalTo(vwHeader.snp.bottom).offset(-10)
        }
        
        self.view.layoutIfNeeded()
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.layer.masksToBounds = true
    }
    
    
    //MARK:- Action button
    func changeProfilePhoto() {
        print("change photo")
    }

}
