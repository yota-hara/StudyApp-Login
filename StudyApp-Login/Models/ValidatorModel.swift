//
//  ValidatorModel.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import Foundation

// ValidationErrorを定義して各エラーに準拠させる
protocol ValidationError: Error {}

// 各エラーにエラーケースとエラーメッセージを定義
enum NameError: ValidationError {
    case empty
    
    var message: String {
        switch self {
        case .empty:
            return "アカウント名が未入力です"
        }
    }
}

enum EmailError: ValidationError, CaseIterable {
    case empty
    
    var message: String {
        switch self {
        case .empty:
            return "メールアドレスが未入力です"
        }
    }
}

enum PasswordError: ValidationError, CaseIterable {
    case notSame
    case empty

    var message: String {
        switch self {
        case .notSame:
            return "確認用パスワードが一致しません"
        case .empty:
            return "パスワードが未入力です"
        }
    }
}

// validation結果を返す型を定義
enum ValidationResult {
    case valid
    // 不正時にはValidationError型の値をラップして返す
    case invalid(ValidationError)
    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
}

// 利用する側が実装に依存しないように、Interfaceとして切り出す
protocol ValidatorModelInterface {
    
    func validateName(name: String?) -> ValidationResult
    func validateEmail(email: String?) -> ValidationResult
    func validatePassword(password: String?, passwordForCheck: String?) -> ValidationResult
}

class ValidatorModel: ValidatorModelInterface {
    
    func validateName(name: String?) -> ValidationResult {
        
        guard let name = name else {
            return .invalid(NameError.empty)
        }
        
        return !name.isEmpty ? .valid : .invalid(NameError.empty)
    }
    
    func validateEmail(email: String?) -> ValidationResult {
        
        guard let email = email else {
            return .invalid(NameError.empty)
        }
        
        return !email.isEmpty ? .valid : .invalid(EmailError.empty)
    }
    
    func validatePassword(password: String?, passwordForCheck: String?) -> ValidationResult {
        
        guard let password = password,
              let passwordForCheck = passwordForCheck,
              !password.isEmpty,
              !passwordForCheck.isEmpty else {
            return .invalid(PasswordError.empty)
        }
        
        return password == passwordForCheck ? .valid : .invalid(PasswordError.notSame)
    }
}
