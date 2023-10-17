//
//  HomeViewController.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties

    // authModel
    let authModel: AuthModelInterface
    // databaseModel
    let databaseModel: DatabaseModelInterface
    var accountName: String = ""

    // MARK: - UIs
    
    // titleLabel
    var titleLabel: UILabel!
    // nameLabel
    var nameLabel: UILabel!
    // logoutButton
    var logoutButton: UIButton!
    
    // MARK: - Initializer

    init(authModel: AuthModelInterface, databaseModel: DatabaseModelInterface) {
        self.authModel = authModel
        self.databaseModel = databaseModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        // storyboardからの生成は想定しない
        fatalError("Not for Storyboard")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.rt.lightBlue

        
        setupUI()
        addSubviews()
        setupLayout()

        logoutButton.addTarget(self, action: #selector(tappedLogoutButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // auth認証の確認
        checkAuthStatus()
    }

    // MARK: - Setup
    
    // setupUI
    func setupUI() {
        // titleLabel
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Home"
        titleLabel.textColor = .rt.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 60)
        self.titleLabel = titleLabel
        
        // nameLabel
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = accountName
        nameLabel.textColor = .rt.white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        self.nameLabel = nameLabel
        
        // logoutButton
        let logoutButton = UIButton(type: .system)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("ログアウト", for: .normal)
        logoutButton.backgroundColor = .rt.navy
        logoutButton.tintColor = .rt.white
        logoutButton.layer.cornerRadius = 8
        self.logoutButton = logoutButton
    }
    
    // addSubviews
    func addSubviews() {
        // titleLabel
        view.addSubview(titleLabel)
        // nameLabel
        view.addSubview(nameLabel)
        // logoutButton
        view.addSubview(logoutButton)
    }
    
    // setupLayout
    func setupLayout() {
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            // nameLabel
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.widthAnchor.constraint(equalToConstant: 200),
            // logoutButton
            logoutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 40),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    // MARK: - Other Functions
    
    // auth認証の確認
    func checkAuthStatus() {
        if let uid = authModel.getCurrentUID() {
            Task {
                accountName = await databaseModel.getUserName(uid: uid) ?? ""
                nameLabel.text = accountName
            }
        } else {
            // ログイン画面へ遷移
            moveToLoginVC()
        }
    }
    
    // logoutButtonタップ処理
    @objc func tappedLogoutButton() {
        Task {
            if await authModel.logout() {
                moveToLoginVC()
            }
        }
    }
    
    // ログイン画面への遷移
    func moveToLoginVC() {
        let vc = LoginViewController(authModel: authModel, validatorModel: ValidatorModel(), type: .login)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }

}

// MARK: - Preview

import SwiftUI

struct HomeProvider: PreviewProvider {
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

        let homeVC = HomeViewController(authModel: AuthModel(), databaseModel: DatabaseModel())

        func makeUIViewController(context: UIViewControllerRepresentableContext<HomeProvider.ContainerView>) -> HomeViewController {
            return homeVC
        }

        func updateUIViewController(_ uiViewController: HomeProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HomeProvider.ContainerView>) {

        }
    }
}
