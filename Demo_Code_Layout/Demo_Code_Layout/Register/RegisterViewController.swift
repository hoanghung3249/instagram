//
//  RegisterViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 5/31/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import ACProgressHUD_Swift
import Pastel
class RegisterViewController: UIViewController {
    
    
    let auth = FIRAuth.auth()
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage().reference(forURL: "gs://instagram-8a16d.appspot.com/")
    var selectedProfilePhoto:UIImage?
    let indicator = ACProgressHUD.shared
    
    
    lazy var imgAvatar:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        let imagePlaceHolder = UIImage(named: "placeholder")
        image.image = imagePlaceHolder
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showLibrary))
        image.addGestureRecognizer(tapGesture)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let viewTxt:UIView = {
        let view:UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1)
        return view
    }()
    
    let textFieldEmail:UITextField = {
        let textField:UITextField = UITextField()
        textField.textColor = UIColor.white
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let viewTxtPass:UIView = {
        let view:UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1)
        return view
    }()
    
    let textFieldPass:UITextField = {
        let textField:UITextField = UITextField()
        textField.textColor = UIColor.white
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let viewTxtName:UIView = {
        let view:UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1)
        return view
    }()
    
    let textFieldName:UITextField = {
        let textField:UITextField = UITextField()
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    lazy var buttonRegister:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 0.2)
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonBack:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
        button.setTitle("<   Back", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    deinit {
        print("deinit register")
    }
    
    
//MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 188.0/255.0, green: 42.0/255.0, blue: 141.0/255.0, alpha: 1)
        self.addSubview()
        self.setupUI()
        self.setupPastelView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        
        self.imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
        self.imgAvatar.layer.masksToBounds = true
    }
    
    
    
    //MARK:- Support functions
    
    func addSubview() {
        self.view.addSubview(imgAvatar)
        self.view.addSubview(viewTxt)
        self.view.addSubview(viewTxtPass)
        self.view.addSubview(viewTxtName)
        self.viewTxt.addSubview(textFieldEmail)
        self.viewTxtPass.addSubview(textFieldPass)
        self.viewTxtName.addSubview(textFieldName)
        self.view.addSubview(buttonRegister)
        self.view.addSubview(buttonBack)
    }
    
    
    func setupUI() {
        
        self.imgAvatar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(70)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        self.viewTxt.snp.makeConstraints { (make) in
            make.top.equalTo(imgAvatar.snp.bottom).offset(50)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.height.equalTo(45)
        }
        
        self.viewTxtPass.snp.makeConstraints { (make) in
            make.top.equalTo(viewTxt.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.height.equalTo(viewTxt.snp.height)
        }
        
        self.viewTxtName.snp.makeConstraints { (make) in
            make.top.equalTo(viewTxtPass.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.height.equalTo(viewTxt.snp.height)
        }

        
        self.textFieldEmail.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewTxt.snp.centerY)
            make.left.equalTo(viewTxt.snp.left).offset(10)
            make.right.equalTo(viewTxt.snp.right)
            make.height.equalTo(30)
        }
        
        self.textFieldPass.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewTxtPass.snp.centerY)
            make.left.equalTo(viewTxt.snp.left).offset(10)
            make.right.equalTo(viewTxt.snp.right)
            make.height.equalTo(30)
        }
        
        self.textFieldName.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewTxtName.snp.centerY)
            make.left.equalTo(viewTxt.snp.left).offset(10)
            make.right.equalTo(viewTxt.snp.right)
            make.height.equalTo(30)
        }
        
        self.buttonRegister.snp.makeConstraints { (make) in
            make.top.equalTo(viewTxtName.snp.bottom).offset(20)
            make.width.equalTo(viewTxt.snp.width)
            make.height.equalTo(40)
            make.left.equalTo(viewTxt.snp.left)
        }
        
        self.buttonBack.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(10)
            make.left.equalTo(self.view.snp.left).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupPastelView() {
        let pastelView = PastelView(frame: view.bounds)
        // Custom Direction
        pastelView.startPoint = .bottomLeft
        pastelView.endPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors(colors: [UIColor(red: 138/255, green: 58/255, blue: 185/255, alpha: 1.0),
                                      UIColor(red: 76/255, green: 104/255, blue: 215/255, alpha: 1.0),
                                      UIColor(red: 205/255, green: 72/255, blue: 107/255, alpha: 1.0),
                                      UIColor(red: 251/255, green: 173/255, blue: 80/255, alpha: 1.0),
                                      UIColor(red: 252/255, green: 204/255, blue: 99/255, alpha: 1.0),
                                      UIColor(red: 188/255, green: 42/255, blue: 141/255, alpha: 1.0),
                                      UIColor(red: 233/255, green: 89/255, blue: 80/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        self.view.insertSubview(pastelView, at: 0)
    }
    
    //MARK:- Action button
    func register() {
        ProgressHUD.show("Loading...")
        guard let email = textFieldEmail.text, let pass = textFieldPass.text, let name = textFieldName.text else { return }
        self.createUser(email, pass, name)
    }

    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func showLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    
    //MARK:- Firebase Functions
    private func upLoadImage(completion:@escaping ((_ urlString:String?,_ error:String?)->(Void))){
        var downloadURL = ""
        if let profileImage = self.selectedProfilePhoto, let imageData = UIImagePNGRepresentation(profileImage) {
            let imgName = UUID().uuidString
            let profileImgStorage = self.storage.child("Avatar/")
            let newImg = profileImgStorage.child(imgName)
            newImg.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error == nil {
                    downloadURL = (metadata?.downloadURL()?.absoluteString)!
                    completion(downloadURL,nil)
                } else {
                    completion(nil,(error?.localizedDescription)!)
                }
            })
        }
    }
    
    
    private func createUser(_ email:String,_ pass:String,_ name:String) {
        self.auth?.createUser(withEmail: email, password: pass, completion: { [unowned self] (user, error) in
            if error == nil {
                self.upLoadImage(completion: { (urlString, err) -> (Void) in
                    if err == nil {
                        var value:Dictionary<String,AnyObject> = Dictionary()
                        value.updateValue(email as AnyObject, forKey: "email")
                        value.updateValue(name as AnyObject, forKey: "username")
                        value.updateValue(urlString as AnyObject, forKey: "avatar")
                        let user = self.ref.child("User").child((user?.uid)!)
                        user.setValue(value, withCompletionBlock: { (error, data) in
                            if error == nil {
                                ProgressHUD.showSuccess()
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                ProgressHUD.showError(error?.localizedDescription)
                            }
                        })
                    } else {
                        ProgressHUD.showError(err)
                    }
                })
            } else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        })
    }

}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgAvatar.image = image
            selectedProfilePhoto = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
