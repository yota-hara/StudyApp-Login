//
//  IndicatorView.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/18.
//

import UIKit

class IndicatorView: UIView {
    
    var indicator: UIActivityIndicatorView!
    var blurView: UIVisualEffectView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicator.startAnimating()
    }
    
    func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20

        // 背景のblur
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 20
        blurView.layer.masksToBounds = true
        self.blurView = blurView
        // インジケータ
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        self.indicator = indicator
        
        // ラベル
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "通信中"
        label.textColor = UIColor.rt.gray70
        label.font = UIFont.boldSystemFont(ofSize: 16)
        self.label = label
    }
    
    func addSubviews() {
        addSubview(blurView)
        addSubview(indicator)
        addSubview(label)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5),
            
            label.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

}

// MARK: - Preview

import SwiftUI

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView()
                .previewDisplayName("カテゴリー未選択")
                .previewLayout(.sizeThatFits)
                .frame(width: 150, height: 150)
        }
    }
    
    struct ContainerView: UIViewRepresentable {
        typealias UIViewType = IndicatorView

        func makeUIView(context: UIViewRepresentableContext<ContainerView>) -> UIViewType {
            let label = IndicatorView(frame: .zero)
            
            return label
        }
        
        func updateUIView(_ uiView: IndicatorView, context: UIViewRepresentableContext<ContainerView>) {

        }
    }
}
