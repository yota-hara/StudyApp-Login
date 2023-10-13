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
                return "Signup"
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
    // Validator（Interfaceに依存）
    private let validatorModel: ValidatorModelInterface!
    private let type: ViewType!
    
    // MARK: - UIs
    
    // textFieldsStackView（TextFieldをまとめて格納するStackView）
    var textFieldsStackView: UIStackView!
    
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

    init(authModel: AuthModel, validatorModel: ValidatorModelInterface, type: ViewType) {
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
        
        view.backgroundColor = .rt.gray20
        
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
        if type == .signup {
            let nameTextField = UITextField()
            nameTextField.tag = 1
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            nameTextField.placeholder = "アカウント名"
            nameTextField.delegate = self
            nameTextField.borderStyle = .roundedRect
            self.nameTextField = nameTextField
        }
        
        // emailTextField
        let emailTextField = UITextField()
        emailTextField.tag = 2
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "メールアドレス"
        emailTextField.delegate = self
        emailTextField.borderStyle = .roundedRect
        self.emailTextField = emailTextField
        
        // passwordTextField
        let passwordTextField = UITextField()
        passwordTextField.tag = 3
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "パスワード"
        passwordTextField.delegate = self
        passwordTextField.borderStyle = .roundedRect
        self.passwordTextField = passwordTextField
        
        // passwordCheckTextField（signupのみ）
        if type == .signup {
            let passwordCheckTextField = UITextField()
            passwordCheckTextField.tag = 4
            passwordCheckTextField.translatesAutoresizingMaskIntoConstraints = false
            passwordCheckTextField.placeholder = "パスワード（確認用）"
            passwordCheckTextField.delegate = self
            passwordCheckTextField.borderStyle = .roundedRect
            self.passwordCheckTextField = passwordCheckTextField
        }
        
        // textFieldsStackView（TextFieldをまとめて格納するStackView）
        var textFieldsStackView = UIStackView()
        if type == .login {
            textFieldsStackView = UIStackView(arrangedSubviews: [
                emailTextField,
                passwordTextField,
            ])
        } else if type == .signup,
                  let nameTextField = self.nameTextField,
                  let passwordCheckTextField = self.passwordCheckTextField {
            textFieldsStackView = UIStackView(arrangedSubviews: [
                nameTextField,
                emailTextField,
                passwordTextField,
                passwordCheckTextField
            ])
        }
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .equalSpacing
        textFieldsStackView.spacing = 40
        self.textFieldsStackView = textFieldsStackView
        
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
        if type == .login {
            let resetPasswordButton = UIButton(type: .system)
            resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
            resetPasswordButton.setTitle("パスワード再設定", for: .normal)
            resetPasswordButton.tintColor = .rt.lightBlue
            self.resetPasswordButton = resetPasswordButton
        }
    }
    
    // addSubviews: 初期化したUIコンポーネントをviewに追加
    func addSubviews() {
        // titleLabel
        view.addSubview(titleLabel)
        // nameTextField（signupのみ）
        // emailTextField
        // passwordTextField
        // passwordCheckTextField（signupのみ）
        // textFieldsStackView
        view.addSubview(textFieldsStackView)
        // loginButton
        view.addSubview(loginButton)
        // switchViewButton
        view.addSubview(switchViewButton)
        // resetPasswordButton（loginのみ）
        if type == .login,
           let resetPasswordButton = resetPasswordButton {
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
            // passwordTextField
            // passwordCheckTextField（signupのみ）
            // textFieldsStackView
            textFieldsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            textFieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsStackView.widthAnchor.constraint(equalToConstant: 200),
            
            // loginButton
            loginButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            
            // switchViewButton
            switchViewButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            switchViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switchViewButton.heightAnchor.constraint(equalToConstant: 40),
            switchViewButton.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        // resetPasswordButton（loginのみ）
        if type == .login,
           let resetPasswordButton = self.resetPasswordButton {
            NSLayoutConstraint.activate([
                resetPasswordButton.topAnchor.constraint(equalTo: switchViewButton.bottomAnchor, constant: 40),
                resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                resetPasswordButton.heightAnchor.constraint(equalToConstant: 40),
                resetPasswordButton.widthAnchor.constraint(equalToConstant: 200),
            ])
        }
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
        
        let name = nameTextField?.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let passwordForCheck = passwordCheckTextField?.text
        
        if type == .signup {
            let nameResult = validatorModel.validateName(name: name)
            let emailResult = validatorModel.validateEmail(email: email)
            let passwordResult = validatorModel.validatePassword(password: password, passwordForCheck: passwordForCheck)
            
            // TODO: 現段階仕様ではsignupのpasswordResultのみチェックする（改修予定）
            if case .invalid(let error as PasswordError) = passwordResult {
                let message = error.message
                // アラートを表示する
                rt.showOneButtonAlert(title: "", message: message)
                return
            }
            
            // Auth認証
            // 遷移処理（仮）
            let vc = HomeViewController()
            present(vc, animated: true)
        } else {
            // Auth認証
            // 遷移処理（仮）
            let vc = HomeViewController()
            present(vc, animated: true)
        }
    }
    
    // switchViewButtonのタップ処理
    @objc func tappedSwitchViewButton() {
        
        // ログイン画面 <-> サインアップ画面の遷移処理
        if type == .login {
            let vc = LoginViewController(authModel: self.authModel, validatorModel: self.validatorModel, type: .signup)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    // resetPasswordButtonのタップ処理
    @objc func tappedResetPasswordButton() {
        
        // email入力フォーム付きのアラートを表示する
        rt.showAlertWithTextField(title: "パスワード再設定", message: "入力されたメールアドレスに再設定用のメールを送信します", placeholder: "メールアドレス", okButtonTitle: "送信") { email in
            
            // Auth処理
        }
    }
    
    // view上をタップしたときの処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // すべてのキーボードからフォーカスを外してキーボードを閉じる
        for i in 1...4 {
            if let textField = view.viewWithTag(i) {
                textField.resignFirstResponder()
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // returnが押されたtextFieldへのフォーカスを解除（キーボードを閉じる）
        textField.resignFirstResponder()
        
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            // 次のタグの指定するtextFieldがあればフォーカスを設定（キーボードを出す）
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
