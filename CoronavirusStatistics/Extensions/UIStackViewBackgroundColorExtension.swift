//
//  UIStackViewBackgroundColorExtension.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 20.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

extension UIStackView {
    func setBackgroundColor(with color: UIColor, withRect rect: CGRect, withCornerRadius cornerRadius: CGFloat) {
        let subView = UIView(frame: rect)
        subView.center = self.center
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        subView.layer.cornerRadius = cornerRadius
        insertSubview(subView, at: 0)
    }
}
