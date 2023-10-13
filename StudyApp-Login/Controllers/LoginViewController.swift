//
//  LoginViewController.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    // FirebaseAuth
    private let authModel: AuthModel!
    // Validator
    private let validatorModel: ValidatorModel!

    // MARK: - UIs
    
    // titleLabel
    var titleLabel: UILabel!
    // emailTextField
    var emailTextField: UITextField!
    // passwordTextField
    var passwordTextField: UITextField!
    // loginButton
    var loginButton: UIButton!
    // switchViewButton
    var switchViewButton: UIButton!
    // resetPasswordButton
    var resetPasswordButton: UIButton!
    
    // MARK: - Initializer

    init(authModel: AuthModel, validatorModel: ValidatorModel) {
        self.authModel = authModel
        self.validatorModel = validatorModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        // storyboardからの生成は想定しない
        fatalError("Not for Storyboard")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupLayout()
    }
    
    // MARK: - Setup
    
    // setupUI: UIコンポーネントの初期化
    func setupUI() {
        // titleLabel
        // emailTextField
        // passwordTextField
        // loginButton
        // switchViewButton
        // resetPasswordButton
    }
    
    // addSubviews: 初期化したUIコンポーネントをviewに追加
    func addSubviews() {
        // titleLabel
        // emailTextField
        // passwordTextField
        // loginButton
        // switchViewButton
        // resetPasswordButton
    }
    
    // setupLayout: UIコンポーネントのレイアウトを設定
    func setupLayout() {
        NSLayoutConstraint.activate([
            // titleLabel
            // emailTextField
            // passwordTextField
            // loginButton
            // switchViewButton
            // resetPasswordButton
        ])
    }
    
    // MARK: - Actions
    
    // loginButtonのタップ処理
    func tappedloginButton() {
        
    }
    
    // switchViewButtonのタップ処理
    func tappedSwitchViewButton() {
        
    }
    
    // resetPasswordButtonのタップ処理
    func tappedResetPasswordButton() {
        
    }
    
    // MARK: - Delegate: TextField
}
