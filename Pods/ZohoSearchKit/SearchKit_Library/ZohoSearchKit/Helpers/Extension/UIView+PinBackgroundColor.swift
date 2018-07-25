//
//  UIView+PinBackgroundColor.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 13/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

public extension UIView {
    public func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
