//
//  Components.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import UIKit

struct Components {
    static func getTextButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(nil, action: action, for: .touchUpInside)
        button.setTitleColor(.mainGreen, for: .normal)
        button.titleLabel?.font = UIFont(name: "subheadline", size: 15)
        return button
    }
    
    static func getTextField(
        placeholder: String = "",
        isPassword: Bool = false,
        height: Int = 46,
        delegate: UITextFieldDelegate? = nil
    ) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.tintColor = .labelPrimary
        textField.textColor = .labelPrimary
        textField.backgroundColor = .systemGray6
        textField.isSecureTextEntry = isPassword
        textField.heightAnchor.constraint(equalToConstant: CGFloat(height))
            .isActive = true
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 8
        
        if delegate != nil {
            textField.delegate = delegate
        }
        
        textField.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 12, height: 0)
        )
        textField.leftViewMode = .always
        textField.rightView = UIView(
            frame: CGRect(x: 0, y: 0, width: 12, height: 0)
        )
        textField.rightViewMode = .always
        
        return textField
    }
    
    static func getButton(
        content: String = "",
        image: UIImage? = nil,
        action: Selector,
        font: UIFont? = .systemFont(ofSize: 16),
        fontSize: Int = 17,
        textColor: UIColor = .labelPrimary,
        backgroundColor: UIColor = .backgroundPrimary,
        cornerRadius: Int = 8,
        size: Int = 46
    ) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = font
        button.setTitleColor(textColor, for: .normal)
        
        if image != nil {
            button.setImage(image, for: .normal)
            button.tintColor = textColor
        } else {
            button.setTitle(content, for: .normal)
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = CGFloat(cornerRadius)
        
        button.heightAnchor.constraint(equalToConstant: CGFloat(size))
            .isActive = true
        
        return button
    }
}
