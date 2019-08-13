//
//  UILabel.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit

class defaulLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(text title: String, textColor color: UIColor = UIColor.black, textAlignment alignment: NSTextAlignment, fontSize: CGFloat) {
        self.init()
        text = title
        textColor = color
        numberOfLines = 0
        textAlignment = alignment
        font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: fontSize)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
