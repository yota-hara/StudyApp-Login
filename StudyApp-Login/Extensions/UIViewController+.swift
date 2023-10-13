//
//  UIViewController+.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import UIKit

// UIViewControllerに名前空間rtを適用
extension UIViewController: RingTechCompatible { }

// UIViewControllerの拡張を名前空間rtに実装する
extension RingTech where Base: UIViewController {
    
    func showOneButtonAlert(title: String, message: String, buttonTitle: String = "OK", completion: @escaping (UIAlertAction) -> Void = { _ in }) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: completion)
        alert.addAction(action)
        
        base.present(alert, animated: true)
    }
    
    func showAlertWithTextField(title: String, message: String, placeholder: String, okButtonTitle: String = "OK", cancelButtonTitle: String = "キャンセル", completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField()
        alert.textFields?.first?.placeholder = placeholder

        let okAction: UIAlertAction = UIAlertAction(title: okButtonTitle, style: UIAlertAction.Style.default) { _ in
            
            let text = alert.textFields?.first?.text
            
            completion(text)
        }
        alert.addAction(okAction)

        let cancelAction: UIAlertAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        base.present(alert, animated: true, completion: nil)
    }
}



