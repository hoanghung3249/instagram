//
//  SearchCell.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/10/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class SearchCell: UITableViewCell {

    let imgAvatar:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "placeholder")
//        image.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    let lblName:UILabel = {
        let label:UILabel = UILabel()
        label.text = "Label"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorView:UIView =  {
        let view:UIView = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupUI()
    }
    
    
    func configCell(user:User) {
        self.lblName.text = user.username
        let imgUrl = URL(string: user.avatarUrl)
        DispatchQueue.main.async {
            self.imgAvatar.kf.setImage(with: imgUrl)
        }
    }
    
    func addSubview(){
        self.contentView.addSubview(imgAvatar)
        self.contentView.addSubview(lblName)
        self.contentView.addSubview(separatorView)
    }
    
    func setupUI() {
        
        self.imgAvatar.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        self.lblName.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.left.equalTo(imgAvatar.snp.right).offset(10)
            make.width.equalTo(contentView.snp.width)
        }
        
        self.separatorView.snp.makeConstraints { (make) in
            make.top.equalTo(lblName.snp.bottom).offset(25)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(0.5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
        }
        
        self.layoutIfNeeded()
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width / 2
        self.imgAvatar.layer.masksToBounds = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
