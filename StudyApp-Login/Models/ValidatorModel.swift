//
//  ValidatorModel.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import Foundation

// 各エラーにエラーケースとエラーメッセージを定義
enum NameError: Error {
    case empty
    case length
    
    var message: String {
        switch self {
        case .empty:
            return "名前を入力してください。"
        case .length:
            return "名前は2文字以上8文字以下で入力してください。"
        }
    }
}

enum EmailError: Error {
    case empty
    case format
    
    var message: String {
        switch self {
        case .empty:
            return "メールアドレスを入力してください。"
        case .format:
            return "メールアドレスの形式が正しくありません。"
        }
    }
}

enum PasswordError: Error {
    case empty
    case length
    case notSame
    
    var message: String {
        switch self {
        case .empty:
            return "パスワードを入力してください。"
        case .length:
            return "パスワードは6文字以上で入力してください。"
        case .notSame:
            return "確認用パスワードが一致しません。"
        }
    }
}

// 利用する側が実装に依存しないように、Interfaceとして切り出す
protocol ValidatorModelInterface {
    
    func validateName(name: String?) -> Result<String, NameError>
    func validateEmail(email: String?) -> Result<String, EmailError>
    func validatePassword(password: String?) -> Result<String, PasswordError>
    func validatePasswordForCheck(password: String?, passwordForCheck: String?) -> Result<String, PasswordError>
}

class ValidatorModel: ValidatorModelInterface {
    
    func validateName(name: String?) -> Result<String, NameError> {
        
        guard let name = name, !name.isEmpty else {
            // nilまたは空のとき
            return .failure(.empty)
        }
                
        if name.count < 2 || name.count > 8 {
            // 2文字未満または8文字を超えるとき
            return .failure(.length)
        }

        return .success("OK")
    }
    
    func validateEmail(email: String?) -> Result<String, EmailError> {
        
        guard let email = email, !email.isEmpty else {
            // nilまたは空のとき
            return .failure(.empty)
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isEmailFormat = emailPredicate.evaluate(with: email)
        
        if !isEmailFormat {
            // メールアドレスのフォーマットに一致しないとき
            return .failure(.format)
        }
        
        return .success("OK")
    }

    func validatePassword(password: String?) -> Result<String, PasswordError> {

        guard let password = password,
              !password.isEmpty else {
            // passwordがnilまたは空のとき
            return .failure(.empty)
        }
        
        if password.count < 6 {
            // 6文字未満のとき
            return.failure(.length)
        }

        return.success("OK")
    }
    
    func validatePasswordForCheck(password: String?, passwordForCheck: String?) -> Result<String, PasswordError> {
        
        guard let password = password,
              let passwordForCheck = passwordForCheck,
              !password.isEmpty,
              !passwordForCheck.isEmpty else {
            // passwordとpasswordForCheckのいずれかがnilまたは空のとき
            return .failure(.empty)
        }

        if password != passwordForCheck {
            // 確認用パスワードが一致しないとき
            return .failure(.notSame)
        }
        
        if password.count < 6 {
            // 6文字未満のとき
            return.failure(.length)
        }

        return.success("OK")
    }
}
