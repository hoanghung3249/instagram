//
//  HeaderProfile.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/8/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import Kingfisher

class HeaderProfile: UICollectionReusableView {
    
    
    var completionEdit:(()->())?
    
    let lblName:UILabel = {
        let label:UILabel = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgAvatar:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let viewBound:UIView =  {
        let view:UIView = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var btnEditProfile:UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupUI()
        self.layoutIfNeeded()
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width / 2.0
        self.imgAvatar.layer.masksToBounds = true
    }
    
    func addSubview() {
        self.addSubview(viewBound)
        self.viewBound.addSubview(imgAvatar)
        self.viewBound.addSubview(lblName)
        self.viewBound.addSubview(btnEditProfile)
    }
    
    
    func setupUI() {
        
        self.viewBound.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.width.equalTo(self.snp.width)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        self.imgAvatar.snp.makeConstraints { (make) in
            make.top.equalTo(viewBound.snp.top).offset(20)
            make.left.equalTo(viewBound.snp.left).offset(30)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        self.lblName.snp.makeConstraints { (make) in
            make.top.equalTo(imgAvatar.snp.bottom).offset(10)
            make.left.equalTo(viewBound.snp.left).offset(30)
            make.width.equalTo(300)
            make.height.equalTo(18)
        }
        
        self.btnEditProfile.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgAvatar.snp.centerY).offset(15)
            make.left.equalTo(imgAvatar.snp.right).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
    }
    
    
    func configHeader(user:User) {
        self.lblName.text = user.username
        let imgAvatar = URL(string: (user.avatarUrl))
        DispatchQueue.main.async {
            self.imgAvatar.kf.setImage(with: imgAvatar)
        }
    }
    
    
    func editProfile() {
        guard let completion = completionEdit else { return }
        completion()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
