//
//  GradientAnimationView.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/18.
//

import UIKit

class GradientAnimationView: UIView {
    
    enum Direction: CaseIterable {
        case right
        case left
        case top
        case bottom
        case rightTop
        case leftTop
        case rightBottom
        case leftBottom
        
        var startPoint: CGPoint {
            switch self {
            case .right:
                return .init(x: 0, y: 0.5)
            case .left:
                return .init(x: 1, y: 0.5)
            case .top:
                return .init(x: 0.5, y: 1)
            case .bottom:
                return .init(x: 0.5, y: 0)
            case .rightTop:
                return .init(x: 0, y: 1)
            case .leftTop:
                return .init(x: 1, y: 1)
            case .rightBottom:
                return .init(x: 0, y: 0)
            case .leftBottom:
                return .init(x: 1, y: 0)
            }
        }
        
        var endPoint: CGPoint {
            switch self {
            case .right:
                return .init(x: 1, y: 0.5)
            case .left:
                return .init(x: 0, y: 0.5)
            case .top:
                return .init(x: 0.5, y: 0)
            case .bottom:
                return .init(x: 0.5, y: 1)
            case .rightTop:
                return .init(x: 1, y: 0)
            case .leftTop:
                return .init(x: 0, y: 0)
            case .rightBottom:
                return .init(x: 1, y: 1)
            case .leftBottom:
                return .init(x: 0, y: 1)
            }
        }
    }
    
    var direction: Direction!
    var startColor: UIColor!
    var endColor: UIColor!
    var fromValue: [Any]?
    var toValue: [Any]?
    
    var gradientLayer: CAGradientLayer!

    init(frame: CGRect,
         startColor: UIColor = UIColor.rt.lightBlue,
         endColor: UIColor = UIColor.rt.navy,
         direction: Direction = .leftTop) {
        super.init(frame: frame)

        self.startColor = startColor
        self.endColor = endColor
        self.direction = direction
        
        self.fromValue = [startColor.cgColor, endColor.cgColor]
        self.toValue = [endColor.cgColor, startColor.cgColor]

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds // frame ではなく bounds を使用
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = direction.startPoint
        gradientLayer.endPoint = direction.endPoint
        gradientLayer.drawsAsynchronously = true
        self.gradientLayer = gradientLayer
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        startAnimation()
    }
    
    func startAnimation() {
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = 4.0
        animation.delegate = self
        gradientLayer.add(animation, forKey: "colorsChange")
    }
}

extension GradientAnimationView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            // アニメーションが終了したら新しい `fromValue` と `toValue` を設定して再度アニメーションを開始
        if flag {
            // 新しい fromValue と toValue を設定
            let tmp = fromValue
            self.fromValue = self.toValue
            self.toValue = tmp
            startAnimation()
        }
    }
}

// MARK: - Preview

import SwiftUI

struct GradientAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView()
                .previewDisplayName("カテゴリー未選択")
                .previewLayout(.sizeThatFits)
                .frame(width: 150, height: 150)
        }
    }
    
    struct ContainerView: UIViewRepresentable {
        typealias UIViewType = GradientAnimationView

        func makeUIView(context: UIViewRepresentableContext<ContainerView>) -> UIViewType {
            let label = GradientAnimationView(frame: .zero)
            
            return label
        }
        
        func updateUIView(_ uiView: GradientAnimationView, context: UIViewRepresentableContext<ContainerView>) {

        }
    }
}
