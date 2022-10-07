//
//  LoginViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/23/22.
//

import UIKit
import ProgressHUD


class LoginViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    /// Label
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var signupLabel: UILabel!
    
    ///TextField
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    ///Button
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var repeatPasswordSeparationView: UIView!
    
    
    // MARK: - Vars
    
    var isLogin: Bool = true
    
    
    // MARK: - IBActions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: isLogin ? "Login" : "Register") {
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.showFailed("모든 항목이 작성되어야 합니다.")
        }
    }
    
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "Default") {
            resetPassword()
        } else {
            ProgressHUD.showFailed("이메일 항목이 작성되어야 합니다.")
        }
    }
    
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "Default") {
            resendVerificationEmail()
        } else {
            ProgressHUD.showFailed("이메일 항목이 작성되어야 합니다.")
        }
    }
    
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    
    // MARK: - Setup TextField
    
    private func setupTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        updatePlaceholderLabels(textField: textField)
    }
    
    
    // MARK: - Setup Background Tap
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc
    private func backgroundTap() {
        view.endEditing(true)
    }
    
    
    // MARK: - Update UI
    
    private func updatePlaceholderLabels(textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabel.text = emailTextField.hasText ? "Email" : ""
        case passwordTextField:
            passwordLabel.text = passwordTextField.hasText ? "Password" : ""
        default:
            repeatPasswordLabel.text = repeatPasswordTextField.hasText ? "Repeat Password" : ""
        }
    }
    
    
    private func updateUIFor(login: Bool) {
        loginButton.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signupButton.setTitle(login ? "SignUp" : "Login", for: .normal)
        signupLabel.text = login ? "계정이 없으신가요?" : "계정이 있으신가요?"
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabel.isHidden = login
            self.repeatPasswordSeparationView.isHidden = login
        }
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginButton.setTitle("", for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        updateUIFor(login: true)
        setupBackgroundTap()
    }
    
    
    // MARK: - Check Data Check For Login
    
    private func isDataInputedFor(type: String) -> Bool {
        switch type {
        case "Login":
            return emailTextField.hasText && passwordTextField.hasText
        case "Register":
            return emailTextField.hasText && passwordTextField.hasText && repeatPasswordTextField.hasText
        default:
            return emailTextField.hasText
        }
    }
    
    
    // MARK: - Register User
    
    private func registerUser() {
        if passwordTextField.text == repeatPasswordTextField.text {
            
            guard let email = emailTextField.text,
                  let password = passwordTextField.text else { return }
            
            FirebaseUser.shared.registerUserWith(email: email, password: password) { [weak self] (error) in
                guard let self = self else { return }
                
                if error == nil {
                    ProgressHUD.showSuccess("확인 이메일을 전송했습니다.")
                    self.resendEmailButton.isHidden = false
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                    self.updateUIFor(login: true)
                } else {
                    self.gotoAppMain()
                }
            }
        } else {
            ProgressHUD.showFailed("비밀번호가 일치하지 않습니다.")
        }
    }
    
    
    // MARK: - Login User
    
    private func loginUser() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        FirebaseUser.shared.loginUserWith(email: email, password: password) { [weak self] (error, isEmailVerified) in
            guard let self = self else { return }
            
            if error == nil {
                if isEmailVerified {
                    self.gotoAppMain()
                } else {
                    ProgressHUD.showFailed("이메일 인증 후 로그인 하십시오.")
                    self.resendEmailButton.isHidden = false
                }
            } else {
                ProgressHUD.showFailed("인증되지 않은 이메일입니다.")
            }
        }
    }
    
    
    // MARK: - Reset Password
    
    private func resetPassword() {
        guard let email = emailTextField.text else { return }
        
        FirebaseUser.shared.resetPasswordFor(email: email) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("비밀번호 재 설정 이메일을 전송했습니다.")
            } else {
                ProgressHUD.showFailed("비밀번호 재 설정 이메일을 전송하지 못했습니다.")
            }
        }
    }
    
    
    // MARK: - Resend Verification Email
    private func resendVerificationEmail() {
        guard let email = emailTextField.text else { return }
        
        FirebaseUser.shared.resendVerificationEmail(email: email) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("인증 이메일을 다시 전송했습니다.")
            } else {
                ProgressHUD.showFailed("인증 이메일을 전송하지 못했습니다.")
            }
        }
    }
    
    
    // MARK: - Go To App Main View
    
    private func gotoAppMain() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
        
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
}

