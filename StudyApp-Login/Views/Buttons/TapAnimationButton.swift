//
//  TapAnimationButton.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/18.
//

import UIKit

class TapAnimationButton: UIButton {
    
    init(frame: CGRect, title: String, textColor: UIColor = UIColor.rt.white, backgroundColor: UIColor = UIColor.rt.blue) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        self.tintColor = textColor
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 8

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchStartAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEndAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEndAnimation()
    }
    
    private func touchStartAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn]) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func touchEndAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn]) {
            self.transform = .identity
        }
    }
}

// MARK: - Preview
import SwiftUI

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView()
                .previewDisplayName("カテゴリー未選択")
                .previewLayout(.sizeThatFits)
                .frame(width: 200, height: 40)
        }
    }
    
    struct ContainerView: UIViewRepresentable {
        typealias UIViewType = TapAnimationButton

        func makeUIView(context: UIViewRepresentableContext<ContainerView>) -> UIViewType {
            let label = TapAnimationButton(frame: .zero, title: "会員登録")
            
            return label
        }
        
        func updateUIView(_ uiView: TapAnimationButton, context: UIViewRepresentableContext<ContainerView>) {

        }
    }
}
