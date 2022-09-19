//
//  UIView+Extension.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 19.03.22.
//

import Foundation
import UIKit

extension UIView {
    func embed(view: UIView, insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                                     view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
                                     view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
                                     view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)])
    }

    func addCornerRadiusAndShadow(cornerRadius: CGFloat,
                                  shadowColor: UIColor,
                                  shadowOffset: CGSize,
                                  shadowRadius: CGFloat,
                                  shadowOpacity: Float) {
        layer.cornerRadius = cornerRadius
        if shadowColor != .clear {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = shadowOffset
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
        }
    }
}
