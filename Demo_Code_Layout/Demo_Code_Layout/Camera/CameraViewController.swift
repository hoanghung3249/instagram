//
//  CameraViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/3/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit
import Sharaku
import Firebase

class CameraViewController: UIViewController {
    
    let auth = FIRAuth.auth()
    let storage = FIRStorage.storage().reference(forURL: "gs://instagram-8a16d.appspot.com/")
    let ref = FIRDatabase.database().reference()
    var userName:String?
    var urlAvatar:String?
    
    lazy var imgStatus:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 2
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        let imagePlaceHolder = UIImage(named: "placeholder")
        image.image = imagePlaceHolder
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showLibrary))
        image.addGestureRecognizer(tapGesture)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var buttonShare:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
        button.setTitle("Share", for: .normal)
//        button.layer.cornerRadius = 5
//        button.backgroundColor = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 0.2)
        button.backgroundColor = UIColor.gray
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        return button
    }()
    
    
    let textViewInput:UITextView = {
        let textView:UITextView = UITextView()
        textView.layer.cornerRadius = 2
        textView.text = "What do you think?"
        textView.textColor = UIColor.gray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    let viewContainer:UIView = {
        let view:UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1)
        return view
    }()
    
    var imageSelected:UIImage?
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupNavigation()
        self.addSubview()
        self.setupDelegate()
        self.setupUI()
        self.tapToHideKeyboard()
        self.view.backgroundColor = UIColor.white
    }

    
    
    //MARK:- Support Functions
    func setupNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Billabong", size: 30)!]
        self.navigationItem.title = "Camera"
    }
    
    
    func addSubview() {
        self.view.addSubview(viewContainer)
        self.viewContainer.addSubview(imgStatus)
        self.viewContainer.addSubview(textViewInput)
        self.view.addSubview(buttonShare)
    }
    
    
    
    func setupUI() {
        self.viewContainer.snp.makeConstraints { (make) in
            make.top.equalTo((self.navigationController?.navigationBar.frame.height)!).offset(64)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(200)
        }
        
        self.imgStatus.snp.makeConstraints { (make) in
            make.left.equalTo(viewContainer.snp.left).offset(10)
            make.top.equalTo(viewContainer.snp.top).offset(10)
            
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        self.textViewInput.snp.makeConstraints { (make) in
            make.top.equalTo(viewContainer.snp.top).offset(10)
            make.left.equalTo(imgStatus.snp.right).offset(10)
            make.right.equalTo(viewContainer.snp.right).offset(-10)
            make.bottom.equalTo(viewContainer.snp.bottom).offset(-80)
        }
        
        self.buttonShare.snp.makeConstraints { (make) in
            make.bottom.equalTo((self.tabBarController?.tabBar.frame.height)!).offset(0)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(50)
        }
    }
    
    func setupDelegate() {
        self.textViewInput.delegate = self
    }
    
    //MARK:- Action functions
    func showLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    

    func share() {
        if imgStatus.image == UIImage(named: "placeholder") || textViewInput.text == "What do you think?" {
            ProgressHUD.showError("Please input the status and select your image!", interaction: true)
        } else {
            guard let imgSelect = self.imgStatus.image, let status = self.textViewInput.text else { return }
            ProgressHUD.show()
            uploadImage(imgSelect, status)
        }
    }
    
    //MARK:- Private Method
    fileprivate func editPhoto(imageEdit:UIImage)  {
        let vc = SHViewController(image: imageEdit)
        vc.delegate = self
        self.present(vc, animated:true, completion: nil)
    }
    
    fileprivate func uploadImage(_ imgSelect:UIImage,_ status:String) {
        Firebase.shared.uploadImage(imgSelect, "ImageStatus/") { [weak self] (urlString, imgName, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                strongSelf.uploadData(urlString!, imgName!, status)
            } else {
                ProgressHUD.showError(error!)
            }
        }
    }
    
    
    private func uploadData(_ urlString:String,_ imgName:String,_ status:String) {
        var param:Dictionary<String,AnyObject> = Dictionary()
        param.updateValue(urlString as AnyObject, forKey: "url")
        param.updateValue(self.auth?.currentUser?.uid as AnyObject, forKey: "uid")
        param.updateValue(self.userName as AnyObject, forKey: "username")
        param.updateValue(status as AnyObject, forKey: "status")
        param.updateValue(self.urlAvatar as AnyObject, forKey: "urlAvatar")
        Firebase.shared.addNewData(TableName.post, nil, param) { [unowned self] (data, error) in
            if error == nil {
                self.uploadDataUser(urlString, imgName)
            } else {
                ProgressHUD.showError(error!)
            }
        }
    }
    
    
    private func uploadDataUser(_ urlString:String,_ imgName:String) {
        let userPost = ref.child("UserPost").child((self.auth?.currentUser?.uid)!).child(imgName)
        var param:Dictionary<String,AnyObject> = Dictionary()
        param.updateValue(urlString as AnyObject, forKey: "urlString")
        userPost.setValue(param) { (error, data) in
            if error == nil {
                ProgressHUD.showSuccess()
                DispatchQueue.main.async {
                    self.imgStatus.image = UIImage(named: "placeholder")
                    self.textViewInput.text = "What do you think?"
                    self.textViewInput.textColor = UIColor.gray
                    self.tabBarController?.selectedIndex = 0
                }
                
            } else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    
}


extension CameraViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What do you think?" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "What do you think?"
            textView.textColor = UIColor.gray
        }
    }
    
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageSelected = image.resized(toWidth: 414)
            
        }
        
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.editPhoto(imageEdit: strongSelf.imageSelected!)
        }
    }
    
    
}


extension CameraViewController: SHViewControllerDelegate {
    func shViewControllerImageDidFilter(image: UIImage) {
        self.imgStatus.image = image
    }
    
    func shViewControllerDidCancel() {
        self.imageSelected = nil
    }
}

