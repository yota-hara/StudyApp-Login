//
//  AuthModel.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import Foundation
import FirebaseAuth

// MARK: - AuthError

enum AuthError: Error {
    case networkError
    case internalError
    case weakPassword
    case wrongPassword
    case invalidEmail
    case userNotFound
    case emailAlreadyInUse
    case unknown
    
    var title: String {
        switch self {
        case .networkError:
            return "通信エラーです。"
        case .internalError:
            return "サーバーエラーです。しばらく待ってからやりなおして下さい。"
        case .wrongPassword:
            return "メールアドレス、もしくはパスワードが正しくありません。"
        case .weakPassword:
            return "脆弱なパスワードです。"
        case .userNotFound:
            return "アカウントがありません。"
        case .invalidEmail:
            return "正しくないメールアドレスの形式です。"
        case .emailAlreadyInUse:
            return "既に登録されているメールアドレスです。"
        case .unknown:
            return "失敗しました。"
        }
    }
}

// MARK: - AuthModelInterface

protocol AuthModelInterface {
    // 会員登録（サインアップ）
    func createUser(name: String, email: String, password: String) async throws
    // ログイン
    func login(email: String, password: String) async throws
    // ログアウト
    func logout() async -> Bool
    // パスワード再設定
    func resetPassword(email: String) async -> Bool
    // ログインユーザーのuidの取得
    func getCurrentUID() -> String?
}

// MARK: - AuthModel

struct AuthModel: AuthModelInterface {
        
    let databaseModel: DatabaseModelInterface
    
    init(databaseModel: DatabaseModelInterface = DatabaseModel()) {
        self.databaseModel = databaseModel
    }
    
    // 会員登録（サインアップ）
    func createUser(name: String, email: String, password: String) async throws {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            
            // TODO: - Firestoreにアカウント名（name）を保存する
            await databaseModel.saveUser(uid: uid, name: name, email: email)
                        
        } catch {
            
            let error = error as NSError
            let errorCode = AuthErrorCode.Code(rawValue: error.code)
            
            switch errorCode {
            case .networkError:
                throw AuthError.networkError
            case .internalError:
                throw AuthError.internalError
            case .weakPassword:
                throw AuthError.weakPassword
            case .invalidEmail:
                throw AuthError.invalidEmail
            case .emailAlreadyInUse:
                throw AuthError.emailAlreadyInUse
            case .wrongPassword:
                throw AuthError.wrongPassword
            case .userNotFound:
                throw AuthError.userNotFound
            default:
                throw AuthError.unknown
            }
        }
    }
    
    // ログイン
    func login(email: String, password: String) async throws {
        
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
                        
        } catch {
            
            let error = error as NSError
            let errorCode = AuthErrorCode.Code(rawValue: error.code)
            
            switch errorCode {
            case .networkError:
                throw AuthError.networkError
            case .internalError:
                throw AuthError.internalError
            case .weakPassword:
                throw AuthError.weakPassword
            case .invalidEmail:
                throw AuthError.invalidEmail
            case .emailAlreadyInUse:
                throw AuthError.emailAlreadyInUse
            case .wrongPassword:
                throw AuthError.wrongPassword
            case .userNotFound:
                throw AuthError.userNotFound
            default:
                throw AuthError.unknown
            }
        }
    }
    
    // ログアウト
    func logout() async -> Bool {
        
        do {
            try Auth.auth().signOut()
            print("ログアウト成功")

            return true
        } catch {
            print("\(#function): \(error.localizedDescription)")
            
            return false
        }
    }
    
    // パスワード再設定
    func resetPassword(email: String) async -> Bool {
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("パスワード再設定メール送信成功")

            return true
            
        } catch {
            print("\(#function): \(error.localizedDescription)")
    
            return false
        }
    }
    
    // ログインユーザーのuidの取得
    func getCurrentUID() -> String? {
        
        if let user = Auth.auth().currentUser {
            return user.uid
            
        } else {
            return nil
        }
    }
}
