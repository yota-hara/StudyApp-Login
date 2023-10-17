//
//  HomeViewController.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import UIKit

class RootViewController: UIViewController {

    // MARK: - Properties

    // authModel
    let authModel: AuthModelInterface
    let databaseModel: DatabaseModelInterface
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


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // auth認証の確認
        checkAuthStatus()
    }
    // auth認証の確認
    func checkAuthStatus() {
        if let uid = authModel.getCurrentUID() {
            Task {
                let accountName = await databaseModel.getUserName(uid: uid) ?? ""
                let homeVC = HomeViewController(authModel: authModel, databaseModel: databaseModel)
                homeVC.modalPresentationStyle = .fullScreen
                homeVC.modalTransitionStyle = .coverVertical
                
                homeVC.accountName = accountName
                present(homeVC, animated: true)
            }
        } else {
            // ログイン画面へ遷移
            moveToLoginVC()
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
