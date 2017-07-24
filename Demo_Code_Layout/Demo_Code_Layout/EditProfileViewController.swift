//
//  EditProfileViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/8/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class EditProfileViewController: UIViewController {
    
    var userProfile:User?
    
    var arrSection = ["", "PRIVATE INFORMATION"]
    var arrInforSection = [["UserName"], ["Email","Phone","Gender"]]
    
    
    fileprivate let firstCell = "firstCell"
    fileprivate let secondCell = "secondCell"

    lazy var tableView:UITableView = {
        let tbv:UITableView = UITableView()
        tbv.backgroundColor = .white
        tbv.dataSource = self
        tbv.delegate = self
        tbv.register(FirstEditCell.self, forCellReuseIdentifier: "firstCell")
        tbv.register(SecondEditCell.self, forCellReuseIdentifier: "secondCell")
        tbv.estimatedRowHeight = 150
        tbv.isScrollEnabled = false
        tbv.separatorStyle = .none
        tbv.translatesAutoresizingMaskIntoConstraints = false
        return tbv
    }()
    
    let vwHeader:UIView =  {
        let view:UIView = UIView()
        view.backgroundColor = .lightGray
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
    
    let containtView:UIView =  {
        let view:UIView = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Edit Profile"
        self.addSubview()
        self.setupUI()
        self.setupNavigation()
    }
    
    
    //MARK:- Support functions
    private func addSubview() {
        self.view.addSubview(vwHeader)
        self.view.addSubview(containtView)
        self.containtView.addSubview(tableView)
        self.vwHeader.addSubview(imageView)
        self.vwHeader.addSubview(btnChangePhoto)
    }
    
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveInfo))
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
        
        self.containtView.snp.makeConstraints { (make) in
            make.top.equalTo(self.vwHeader.snp.bottom).offset(0)
            make.left.equalTo(self.vwHeader.snp.left)
            make.right.equalTo(self.vwHeader.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.containtView.snp.top)
            make.bottom.equalTo(self.containtView.snp.bottom)
            make.left.equalTo(self.containtView.snp.left)
            make.right.equalTo(self.containtView.snp.right)
        }
        
        self.view.layoutIfNeeded()
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.layer.masksToBounds = true
    }
    
    
    //MARK:- Action button
    func changeProfilePhoto() {
        print("change photo")
    }
    
    
    func saveInfo() {
        self.navigationController?.popViewController(animated: true)
    }

}


extension EditProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInforSection[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.setupCellInTable(indexPath: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrSection[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Verdana", size: 10)
        headerLabel.textColor = UIColor.black
        headerLabel.text = self.arrSection[section]
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
    fileprivate func setupCellInTable(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: firstCell, for: indexPath) as! FirstEditCell
            cell.selectionStyle = .none
            cell.txtName.placeholder = arrInforSection[indexPath.section][indexPath.row]
            if indexPath.row == 0 {
                cell.txtName.text = self.userProfile?.username
            }
            cell.completion = { [weak self] textEdit in
                guard let strongSelf = self else { return }
                if indexPath.row == 0 {
                    cell.txtName.text = textEdit
                    strongSelf.userProfile?.username = textEdit
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: secondCell, for: indexPath) as! SecondEditCell
            cell.txtEmail.placeholder = arrInforSection[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.txtEmail.text = self.userProfile?.email
            } else if indexPath.row == 1 {
                cell.txtEmail.keyboardType = .namePhonePad
                cell.txtEmail.text = self.userProfile?.phoneNumber
            } else {
                cell.txtEmail.text = self.userProfile?.gender
            }
            
            cell.completion = { [weak self] textEdit in
                guard let strongSelf = self else { return }
                if indexPath.row == 0 {
                    cell.txtEmail.text = textEdit
                    strongSelf.userProfile?.email = textEdit
                } else if indexPath.row == 1 {
                    cell.txtEmail.keyboardType = .namePhonePad
                    cell.txtEmail.text = textEdit
                    strongSelf.userProfile?.phoneNumber = textEdit
                } else {
                    cell.txtEmail.text = textEdit
                    strongSelf.userProfile?.gender = textEdit
                }
            }
            
            return cell
        }
    }
    
}

