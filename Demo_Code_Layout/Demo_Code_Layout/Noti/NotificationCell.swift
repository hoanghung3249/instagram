//
//  NotificationCell.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/13/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit

class NotificationCell: UITableViewCell {

    let imgAvatar:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "placeholder")
//        image.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let imgStatus:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "placeholder")
//        image.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let lblState:UILabel = {
        let label:UILabel = UILabel()
        label.text = "Label"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorView:UIView =  {
        let view:UIView = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubView()
        self.setupUI()
    }
    
    
    func addSubView() {
        self.contentView.addSubview(imgAvatar)
        self.contentView.addSubview(imgStatus)
        self.contentView.addSubview(lblState)
        self.contentView.addSubview(separatorView)
    }
    
    func setupUI() {
        self.imgAvatar.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        self.lblState.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.left.equalTo(imgAvatar.snp.right).offset(5)
//            make.height.equalTo(40)
        }
        
        self.imgStatus.snp.makeConstraints { (make) in
            make.top.equalTo(lblState.snp.top)
            make.left.equalTo(lblState.snp.right).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        self.separatorView.snp.makeConstraints { (make) in
            make.top.equalTo(lblState.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(0.5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
        }
        
        self.layoutIfNeeded()
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width / 2
        self.imgAvatar.layer.masksToBounds = true
        self.imgStatus.layer.cornerRadius = 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
