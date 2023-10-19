//
//  DebugFloatingButton.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/17.
//

import UIKit

class DebugFloatingButton: UIButton {
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        backgroundColor = UIColor.rt.red.withAlphaComponent(0.7)
        tintColor = UIColor.rt.gray70
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.rt.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowOpacity = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        startAnimation()
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 2.5, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction]) {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.layer.shadowRadius = 15
        }
    }
}

// MARK: - Preview

import SwiftUI

struct DebugFloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView()
                .previewDisplayName("カテゴリー未選択")
                .previewLayout(.sizeThatFits)
                .frame(width: 200, height: 40)
        }
    }
    
    struct ContainerView: UIViewRepresentable {
        typealias UIViewType = DebugFloatingButton

        func makeUIView(context: UIViewRepresentableContext<ContainerView>) -> UIViewType {
            let label = DebugFloatingButton(frame: .zero, title: "Debug用ボタン")
            
            return label
        }
        
        func updateUIView(_ uiView: DebugFloatingButton, context: UIViewRepresentableContext<ContainerView>) {

        }
    }
}
