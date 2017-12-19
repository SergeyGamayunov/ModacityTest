//
//  MDRecordButton.swift
//  Mena Test Project
//
//  Created by Сергей Гамаюнов on 19/12/2017.
//  Copyright © 2017 modacity. All rights reserved.
//

import UIKit
@IBDesignable
class MDStateButton: UIButton {
    enum State {
        case active(String)
        case nonActive(String)
    }
    
    var activeState: State! {
        didSet {
            guard let state = activeState else { return }
            switch state {
            case .nonActive(let title):
                backgroundColor = MDColor.green
                setTitle(title, for: .normal)
            case .active(let title):
                backgroundColor = MDColor.red
                setTitle(title, for: .normal)
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue; layer.masksToBounds = newValue > 0 }
    }
}
