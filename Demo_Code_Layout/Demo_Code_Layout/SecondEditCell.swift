//
//  SecondEditCell.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 7/19/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit

class SecondEditCell: UITableViewCell {

    let txtEmail:UITextField = {
        let textField:UITextField = UITextField()
        textField.placeholder = "User Name"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    var completion:((_ textEdit:String)->())?
    
    //MARK:- Init function
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.txtEmail.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupUI() {
        self.contentView.addSubview(self.txtEmail)
        
        self.txtEmail.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.height.equalTo(30)
            make.right.equalTo(self.contentView.snp.right)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        
    }
    
    
}


extension SecondEditCell:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let completion = self.completion else { return }
        completion(textField.text!)
    }
    
}

