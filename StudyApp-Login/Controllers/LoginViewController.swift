//
//  LoginViewController.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum ViewType {
        case login
        case signup
        
        var title: String {
            switch self {
            case .login:
                return "Login"
            case .signup:
                return "signup"
            }
        }
        var switchViewTitle: String {
            switch self {
            case .login:
                return "会員登録はコチラ"
            case .signup:
                return "会員の方はコチラ"
            }
        }
    }
    
    // MARK: - Properties
    
    // FirebaseAuth
    private let authModel: AuthModel!
    // Validator
    private let validatorModel: ValidatorModel!
    private let type: ViewType!
    // MARK: - UIs
    
    // titleLabel
    var titleLabel: UILabel!
    // nameTextField（signupのみ）
    var nameTextField: UITextField?
    // emailTextField
    var emailTextField: UITextField!
    // passwordTextField
    var passwordTextField: UITextField!
    // passwordCheckTextField（signupのみ）
    var passwordCheckTextField: UITextField?
    // loginButton
    var loginButton: UIButton!
    // switchViewButton
    var switchViewButton: UIButton!
    // resetPasswordButton（loginのみ）
    var resetPasswordButton: UIButton?
    
    // MARK: - Initializer

    init(authModel: AuthModel, validatorModel: ValidatorModel, type: ViewType) {
        self.authModel = authModel
        self.validatorModel = validatorModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        // storyboardからの生成は想定しない
        fatalError("Not for Storyboard")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rt.white
        
        setupUI()
        addSubviews()
        setupLayout()
        addTargets()
    }
    
    // MARK: - Setup
    
    // setupUI: UIコンポーネントの初期化
    func setupUI() {
        // titleLabel
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = type.title
        titleLabel.textColor = .rt.blue
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 60)
        self.titleLabel = titleLabel
        
        // nameTextField（signupのみ）
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "アカウント名"
//        nameTextField.delegate = self
        nameTextField.borderStyle = .roundedRect
        self.nameTextField = nameTextField
        
        // emailTextField
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "メールアドレス"
//        emailTextField.delegate = self
        emailTextField.borderStyle = .roundedRect
        self.emailTextField = emailTextField
        
        // passwordTextField
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "パスワード"
//        passwordTextField.delegate = self
        passwordTextField.borderStyle = .roundedRect
        self.passwordTextField = passwordTextField
        
        // passwordCheckTextField（signupのみ）
        let passwordCheckTextField = UITextField()
        passwordCheckTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordCheckTextField.placeholder = "パスワード"
//        passwordTextField.delegate = self
        passwordCheckTextField.borderStyle = .roundedRect
        self.passwordCheckTextField = passwordCheckTextField
        
        // loginButton
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("ログイン", for: .normal)
        loginButton.backgroundColor = .rt.lightBlue
        loginButton.tintColor = .rt.white
        loginButton.layer.cornerRadius = 8
        self.loginButton = loginButton
        
        // switchViewButton
        let switchViewButton = UIButton(type: .system)
        switchViewButton.translatesAutoresizingMaskIntoConstraints = false
        switchViewButton.setTitle(type.switchViewTitle, for: .normal)
        switchViewButton.tintColor = .rt.lightBlue
        self.switchViewButton = switchViewButton
        
        // resetPasswordButton（loginのみ）
        let resetPasswordButton = UIButton(type: .system)
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.setTitle("パスワード再設定", for: .normal)
        resetPasswordButton.tintColor = .rt.lightBlue
        self.resetPasswordButton = resetPasswordButton
    }
    
    // addSubviews: 初期化したUIコンポーネントをviewに追加
    func addSubviews() {
        // titleLabel
        view.addSubview(titleLabel)
        // nameTextField（signupのみ）

        // emailTextField
        view.addSubview(emailTextField)
        // passwordTextField
        view.addSubview(passwordTextField)
        // passwordCheckTextField（signupのみ）

        // loginButton
        view.addSubview(loginButton)
        // switchViewButton
        view.addSubview(switchViewButton)
        // resetPasswordButton（loginのみ）
        if let resetPasswordButton = resetPasswordButton {
            view.addSubview(resetPasswordButton)
        }
    }
    
    // setupLayout: UIコンポーネントのレイアウトを設定
    func setupLayout() {
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            // nameTextField（signupのみ）

            // emailTextField
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.widthAnchor.constraint(equalToConstant: 200),
            
            // passwordTextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            
            // passwordCheckTextField（signupのみ）
            
            // loginButton
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            
            // switchViewButton
            switchViewButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            switchViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switchViewButton.heightAnchor.constraint(equalToConstant: 40),
            switchViewButton.widthAnchor.constraint(equalToConstant: 200),
            
            // resetPasswordButton（loginのみ）
//            resetPasswordButton.topAnchor.constraint(equalTo: switchViewButton.bottomAnchor, constant: 40),
//            resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            resetPasswordButton.heightAnchor.constraint(equalToConstant: 40),
//            resetPasswordButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func addTargets() {
        // loginButtonのタップ処理
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        // switchViewButtonのタップ処理
        switchViewButton.addTarget(self, action: #selector(tappedSwitchViewButton), for: .touchUpInside)
        // resetPasswordButtonのタップ処理（loginのみ）
        resetPasswordButton?.addTarget(self, action: #selector(tappedResetPasswordButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    // loginButtonのタップ処理
    @objc func tappedLoginButton() {
        print(#function)
    }
    
    // switchViewButtonのタップ処理
    @objc func tappedSwitchViewButton() {
        print(#function)
    }
    
    // resetPasswordButtonのタップ処理
    @objc func tappedResetPasswordButton() {
        print(#function)
    }
    
    // MARK: - Delegate: TextField
}
