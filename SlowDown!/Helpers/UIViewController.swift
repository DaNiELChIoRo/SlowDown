//
//  ViewController.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/8/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { (_view) in
            self.addSubview(_view)
        }
    }
}
