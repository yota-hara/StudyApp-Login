//
//  StorageModel.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import Foundation
import FirebaseFirestore

protocol DatabaseModelInterface {
    
    func saveUser(uid: String, name: String, email: String) async
    
    func getUserName(uid: String) async -> String?
}

struct DatabaseModel: DatabaseModelInterface {
    
    func saveUser(uid: String, name: String, email: String) async {
        
        let dictionary = ["name": name, "email": email]
        
        do {
            try await Firestore.firestore().collection("Users").document(uid).setData(dictionary)

            print("ユーザー情報の保存に成功")
        } catch {
            print("ユーザー情報の保存に失敗")
        }
    }
    
    func getUserName(uid: String) async -> String? {
        
        do {
            let data = try await Firestore.firestore().collection("Users").document(uid).getDocument()
            let name = data["name"] as? String
            print("ユーザー名の取得に成功")
            return name
        } catch {
            print("ユーザー名の取得に失敗")
            return nil
        }
    }
    
    
    
}
