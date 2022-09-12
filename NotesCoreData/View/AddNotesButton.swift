//
//  AddNotesButton.swift
//  NotesCoreData
//
//  Created by Kiran on 12/09/22.
//

import Foundation
import UIKit

class AddNotesButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(systemName: "rectangle.stack.badge.plus"), for: .normal) //used SF Symbols
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setButtonConstraints(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45).isActive = true
    }

}
