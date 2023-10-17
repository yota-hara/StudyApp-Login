//
//  String+.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/18.
//

import Foundation

// UIColorに名前空間rtを適用
extension String: RingTechCompatible {
    typealias rt = RingTech<String>
}

// UIColorの拡張を名前空間rtに実装する
extension RingTech where Base == String {
    
    // 指定長さのランダムな英数文字列を生成する
    static func generateRandomAlphanumerics(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyz0123456789"

        var randomString = ""

        for _ in 0..<length {
            if let char = characters.randomElement() {
                randomString.append(char)
            }
        }

        return randomString
    }
}

