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
        
        var loginButtonTitle: String {
            switch self {
            case .login:
                return "ログイン"
            case .signup:
                return "会員登録"
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
    private let authModel: AuthModelInterface!
    // Validator（Interfaceに依存）
    private let validatorModel: ValidatorModelInterface!
    private let type: ViewType!
    
    // 編集中のTextFieldを保持する変数
    private var _activeTextField: UITextField? = nil
    
    // MARK: - UIs
    
    // textFieldsStackView（TextFieldをまとめて格納するStackView）
    var textFieldsStackView: UIStackView!
    // backgroundView
    var backgroundView: UIView!
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
    
    init(authModel: AuthModelInterface, validatorModel: ValidatorModelInterface, type: ViewType) {
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
        
        view.backgroundColor = .rt.navy
        
        setupUI()
        addSubviews()
        setupLayout()
        addTargets()
        
        #if DEBUG
        addDebugButton()
        #endif
        
        // 通知の追加
        addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let gradientAnimationView = backgroundView as? GradientAnimationView {
            gradientAnimationView.startAnimation()
        }
    }
    
    // 通知の追加
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 通知の削除
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // キーボード表示通知の処理
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        guard let textField = _activeTextField,
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else {
            return
        }
        
        let stackViewTop = textFieldsStackView.frame.minY
        let textFieldBottom = stackViewTop + textField.frame.maxY
        let keyboardTop = UIScreen.main.bounds.height - keyboardFrame.height

        if keyboardTop <= textFieldBottom {
            let transitionLength = textFieldBottom - keyboardTop
            UIView.animate(withDuration: duration) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -transitionLength)
            }
        }
    }
    
    // キーボード非表示通知の処理
    @objc func keyboardWillHideNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Setup
    
    // setupUI: UIコンポーネントの初期化
    func setupUI() {
        // backgroundView
        let backgroundView = GradientAnimationView(frame: view.frame)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView = backgroundView
        
        // titleLabel
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = type.title
        titleLabel.textColor = .rt.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 60)
        self.titleLabel = titleLabel
        
        // nameTextField（signupのみ）
        if type == .signup {
            let nameTextField = RichTextField(placeholder: "アカウント名")
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            nameTextField.tag = 1
            nameTextField.delegate = self
            nameTextField.returnKeyType = .next
            self.nameTextField = nameTextField
        }
        
        // emailTextField
        let emailTextField = RichTextField(placeholder: "メールアドレス")
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.tag = 2
        emailTextField.delegate = self
        emailTextField.returnKeyType = .next
        self.emailTextField = emailTextField
        
        // passwordTextField
        let passwordTextField = RichTextField(placeholder: "パスワード")
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.tag = 3
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = type == .login ? .done : .next
        self.passwordTextField = passwordTextField
        
        // passwordCheckTextField（signupのみ）
        if type == .signup {
            let passwordCheckTextField = RichTextField(placeholder: "パスワード（確認用）")
            passwordCheckTextField.translatesAutoresizingMaskIntoConstraints = false
            passwordCheckTextField.tag = 4
            passwordCheckTextField.delegate = self
            passwordCheckTextField.returnKeyType = .done
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
        let loginButton = TapAnimationButton(frame: .zero, title: type.loginButtonTitle)
        self.loginButton = loginButton
        
        // switchViewButton
        let switchViewButton = UIButton(type: .system)
        switchViewButton.translatesAutoresizingMaskIntoConstraints = false
        switchViewButton.setTitle(type.switchViewTitle, for: .normal)
        switchViewButton.tintColor = .rt.gray10
        self.switchViewButton = switchViewButton
        
        // resetPasswordButton（loginのみ）
        if type == .login {
            let resetPasswordButton = UIButton(type: .system)
            resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
            resetPasswordButton.setTitle("パスワード再設定", for: .normal)
            resetPasswordButton.tintColor = .rt.gray10
            self.resetPasswordButton = resetPasswordButton
        }
    }
    
    // addSubviews: 初期化したUIコンポーネントをviewに追加
    func addSubviews() {
        // backgroundView
        view.addSubview(backgroundView)
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
    
    // DEBUG時の簡易入力ボタンの設置
    func addDebugButton() {
        
        let debugButton = DebugFloatingButton(frame: .zero, title: "簡易入力")
        view.addSubview(debugButton)
        
        NSLayoutConstraint.activate([
            debugButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            debugButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            debugButton.widthAnchor.constraint(equalToConstant: 150),
            debugButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        debugButton.addTarget(self, action: #selector(tappedDebugButton), for: .touchUpInside)
    }
    
    // debugButtonタップ時の簡易入力処理
    @objc func tappedDebugButton() {
        let password = "test1234"
        
        if type == .login {
            // ログイン用のアカウントデータはAuthentificationで作成しておく
            emailTextField.text = "test@example.com"
            passwordTextField.text = password
        } else {
            let name = "test" + String.rt.generateRandomAlphanumerics(length: 4)
            let domain = "@example.com"
            let email = name + domain
            
            nameTextField?.text = name
            emailTextField.text = email
            passwordTextField.text = password
            passwordCheckTextField?.text = password
        }
        nameTextField?.sendActions(for: .valueChanged)
        emailTextField.sendActions(for: .valueChanged)
        passwordTextField.sendActions(for: .valueChanged)
        passwordCheckTextField?.sendActions(for: .valueChanged)
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
            Task {
                do {
                    rt.startIndicator()
                    try await self.authModel.createUser(name: name ?? "", email: email ?? "", password: password ?? "")
                    rt.stopIndicator()
                    
                    let vc = HomeViewController(authModel: authModel, databaseModel: DatabaseModel())
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .coverVertical
                    present(vc, animated: true)
                    
                } catch let error as AuthError {
                    rt.stopIndicator()
                    
                    let message = error.title
                    rt.showOneButtonAlert(title: "会員登録失敗", message: message)
                }
            }
            
        } else {
            // Auth認証
            Task {
                do {
                    rt.startIndicator()
                    try await self.authModel.login(email: email ?? "", password: password ?? "")
                    rt.stopIndicator()
                    
                    let vc = HomeViewController(authModel: authModel, databaseModel: DatabaseModel())
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .coverVertical
                    present(vc, animated: true)
                    
                } catch let error as AuthError {
                    rt.stopIndicator()
                    
                    let message = error.title
                    rt.showOneButtonAlert(title: "ログイン失敗", message: message)
                }
            }
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
            
            guard let email = email else {
                return self.rt.showOneButtonAlert(title: "パスワード再設定", message: "メールの送信に失敗しました")
            }
            // Auth処理
            Task {
                self.rt.startIndicator()
                if await self.authModel.resetPassword(email: email)  {
                    self.rt.stopIndicator()
                    
                    self.rt.showOneButtonAlert(title: "パスワード再設定", message: "メールを送信しました")
                } else {
                    self.rt.stopIndicator()

                    self.rt.showOneButtonAlert(title: "パスワード再設定", message: "メールの送信に失敗しました")
                }
            }
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
    
    // TextFieldの編集直後に呼ばれる
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 編集対象のTextFieldを保存する
        _activeTextField = textField
        return true;
    }
    
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

// MARK: - Preview

import SwiftUI

struct LoginProvider: PreviewProvider {
    static var previews: some View {
        let devices = ["iPhone SE3", "iPhone 14 Pro"]
        ForEach(devices, id: \.self) { device in
            ContainerView()
                .previewDevice(.init(rawValue: device))
                .previewDisplayName(device)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let loginVC = LoginViewController(authModel: AuthModel(), validatorModel: ValidatorModel(), type: .signup)
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginProvider.ContainerView>) -> LoginViewController {
            return loginVC
        }
        
        func updateUIViewController(_ uiViewController: LoginProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginProvider.ContainerView>) {
            
        }
    }
}
