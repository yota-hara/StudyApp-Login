//
//  RichTextField.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/18.
//

import UIKit

class RichTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)
    var placeholderLabel: UILabel!
    var messageLabel: UILabel!
    var secureButton: UIButton?
    
    var useSecureText: Bool = false
    var labelColor: UIColor!
    
    init(placeholder: String, labelColor: UIColor = .white, useSecureText: Bool = false) {
        super.init(frame: .zero)
        
        self.labelColor = labelColor
        self.useSecureText = useSecureText

        setupUI(placeholder: placeholder)
        addSubviews()
        setupLayout()
        addTargets()
    }
    
    func setupUI(placeholder: String) {
        textColor = .black
        font = .boldSystemFont(ofSize: 18)
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.white.cgColor
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true

        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = .gray.withAlphaComponent(0.9)
        placeholderLabel.font = .systemFont(ofSize: 18)
        self.placeholderLabel = placeholderLabel
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = ""
        messageLabel.textColor = .yellow
        messageLabel.font = .systemFont(ofSize: 14)
        self.messageLabel = messageLabel
        
        if useSecureText {
            let secureButton = UIButton()
            secureButton.translatesAutoresizingMaskIntoConstraints = false
            secureButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            secureButton.frame.size = .init(width: 40, height: 40)
            secureButton.tintColor = .darkGray
            self.isSecureTextEntry = true
            self.secureButton = secureButton
        }
    }
    
    func addSubviews() {
        addSubview(placeholderLabel)
        addSubview(messageLabel)
        if let secureButton = secureButton {
            addSubview(secureButton)
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 18),
            
            messageLabel.topAnchor.constraint(equalTo: bottomAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        if let secureButton = secureButton {
            NSLayoutConstraint.activate([
                secureButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                secureButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ])
        }
    }
    
    func addTargets() {
        addTarget(self, action: #selector(upShiftPlaceholder), for: .editingDidBegin)
        addTarget(self, action: #selector(downShiftPlaceholder), for: .editingDidEnd)
        secureButton?.addTarget(self, action: #selector(tappedSecureButton), for: .touchUpInside)
    }
    
    func updateMessage(text: String) {
        self.messageLabel.text = text
    }
    
    @objc private func upShiftPlaceholder() {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.transform = CGAffineTransform(translationX: -10, y: -self.frame.height + 10)
            self.placeholderLabel.textColor = self.labelColor
        }
    }
    
    @objc private func downShiftPlaceholder() {
        UIView.animate(withDuration: 0.3) {
            if let text = self.text, !text.isEmpty {

            } else {
                self.placeholderLabel.transform = .identity
                self.placeholderLabel.textColor = .gray.withAlphaComponent(0.9)
            }
        }
    }
    
    @IBAction func tappedSecureButton() {
        if isSecureTextEntry {
            isSecureTextEntry = false
            secureButton?.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            isSecureTextEntry = true
            secureButton?.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

// MARK: - Preview

import SwiftUI

struct RichTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Rectangle().frame(width: 300, height: 200)

                ContainerView()
                    .previewDisplayName("カテゴリー未選択")
                    .previewLayout(.sizeThatFits)
                    .frame(width: 200, height: 40)
            }

        }
    }
    
    struct ContainerView: UIViewRepresentable {
        typealias UIViewType = RichTextField

        func makeUIView(context: UIViewRepresentableContext<ContainerView>) -> UIViewType {
            let label = RichTextField(placeholder: "メールアドレス")
            
            return label
        }
        
        func updateUIView(_ uiView: RichTextField, context: UIViewRepresentableContext<ContainerView>) {

        }
    }
}
