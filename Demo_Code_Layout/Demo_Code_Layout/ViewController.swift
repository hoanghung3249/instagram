//
//  ViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 5/31/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import Pastel

class ViewController: UIViewController {
    
    let aut = FIRAuth.auth()
    
    let labelHeader:UILabel = {
        let label:UILabel = UILabel()
        label.text = "Instagram"
        label.font = UIFont(name: "Billabong", size: 50)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    let textFieldEmail:UITextField = {
        let textField:UITextField = UITextField()
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let viewTxtEmail:UIView = {
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
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textField.textColor = UIColor.white
        textField.isSecureTextEntry = true
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
    
    
    lazy var buttonLogin:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
        button.setTitle("LOG IN", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 0.2)
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonRegister:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 0.2)
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionRegister), for: .touchUpInside)
        return button
    }()
    
    let boundView:UIView = {
        let view:UIView = UIView()
        //188, 42, 141
        view.backgroundColor = UIColor(red: 188.0/255.0, green: 42.0/255.0, blue: 141.0/255.0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupPastelView()
        self.addSubView()
        self.setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Support function
    func addSubView() {
        self.view.addSubview(boundView)
        self.boundView.addSubview(viewTxtEmail)
        self.boundView.addSubview(viewTxtPass)
        self.boundView.addSubview(buttonLogin)
        self.boundView.addSubview(buttonRegister)
        self.viewTxtEmail.addSubview(textFieldEmail)
        self.viewTxtPass.addSubview(textFieldPass)
        self.boundView.addSubview(labelHeader)
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
        boundView.insertSubview(pastelView, at: 0)
    }
    
    func setupUI() {
        self.boundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        self.viewTxtEmail.snp.makeConstraints { (make) in
            make.top.equalTo(boundView).offset(200)
            make.left.equalTo(boundView).offset(30)
            make.right.equalTo(boundView).offset(-30)
            make.height.equalTo(45)
        }
        self.viewTxtPass.snp.makeConstraints { (make) in
            make.top.equalTo(viewTxtEmail.snp.bottom).offset(10)
            make.left.equalTo(viewTxtEmail)
            make.width.equalTo(viewTxtEmail)
            make.height.equalTo(viewTxtEmail)
        }
        self.textFieldEmail.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewTxtEmail.snp.centerY)
            make.left.equalTo(viewTxtEmail).offset(10)
            make.right.equalTo(viewTxtEmail)
            make.height.equalTo(30)
        }
        self.textFieldPass.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewTxtPass.snp.centerY)
            make.left.equalTo(viewTxtPass).offset(10)
            make.right.equalTo(viewTxtPass)
            make.height.equalTo(30)
        }
        self.buttonLogin.snp.makeConstraints { (make) in
            make.top.equalTo(viewTxtPass.snp.bottom).offset(10)
            make.left.equalTo(viewTxtEmail)
            make.width.equalTo(viewTxtEmail)
            make.height.equalTo(30)
        }
        self.buttonRegister.snp.makeConstraints { (make) in
            make.bottom.equalTo(boundView.snp.bottom).offset(-20)
            make.left.equalTo(viewTxtEmail)
            make.width.equalTo(viewTxtEmail)
            make.height.equalTo(30)
        }
        
        self.labelHeader.snp.makeConstraints { (make) in
            make.top.equalTo(boundView.snp.top).offset(100)
            make.bottom.equalTo(viewTxtEmail.snp.top).offset(-20)
            make.centerX.equalTo(viewTxtEmail.snp.centerX)
            make.width.equalTo(viewTxtEmail.snp.width)
        }
    }
    
    
    //MARK:- Action Button
    func actionLogin() {
        guard let email = self.textFieldEmail.text, let pass = self.textFieldPass.text else { return }
        self.view.endEditing(true)
        ProgressHUD.show("Login...")
        self.signInWith(email, pass)
    }
    
    func actionRegister() {
        let registerVC = RegisterViewController()
        self.present(registerVC, animated: true, completion: nil)
    }
    
    
    
    //MARK:- Firebase functions
    private func signInWith(_ email:String, _ password:String) {
        aut?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                ProgressHUD.dismiss()
                let tabBarVC = TabBarController()
                strongSelf.present(tabBarVC, animated: true, completion: nil)
            } else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        })
    }
    


}

