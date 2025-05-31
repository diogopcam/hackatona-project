//
//  Components.swift
//  AvoTracker
//
//  Created by João Pedro Teixeira de Caralho on 13/05/25.
//
import UIKit

struct Components {
    
    // MARK: - Get label
    static func getLabel(
        content: String,
        font: UIFont? = .systemFont(ofSize: 17),
        fontSize: Int = 17,
        textColor: UIColor = .white,
        alignment: NSTextAlignment = .justified,
        hiden: Bool = false
    ) -> UILabel {
        
        if font == nil {
            print("Font not found for \(content)")
            
        }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = content
        label.textAlignment = alignment
        label.textColor = textColor
        label.font = font
        label.isHidden = hiden
        
        return label
    }
    
    static func getTextButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(nil, action: action, for: .touchUpInside)
        button.setTitleColor(.mainGreen, for: .normal)
        button.titleLabel?.font = UIFont(name: "subheadline", size: 15)
        return button
    }
    
        // MARK: - Get textField
        static func getTextField(
            placeholder: String = "",
            isPassword: Bool = false,
            height: Int = 46,
            delegate: UITextFieldDelegate? = nil
        ) -> UITextField {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = placeholder
            textField.tintColor = .white
            textField.textColor = .white
            textField.backgroundColor = .systemGray6
            textField.isSecureTextEntry = isPassword
            textField.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            textField.autocapitalizationType = .none
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.cornerRadius = 8
    
            if delegate != nil {
                textField.delegate = delegate
            }
    
            // Add internal padding
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
            textField.leftViewMode = .always
            textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
            textField.rightViewMode = .always
    
            return textField
        }
    
        // MARK: - Get button
        static func getButton(
            content: String = "",
            image: UIImage? = nil,
            action: Selector,
            font: UIFont? = .systemFont(ofSize: 16),
            fontSize: Int = 17,
            textColor: UIColor = .white,
            backgroundColor: UIColor = .systemBackground,
            cornerRadius: Int = 8,
            size: Int = 46
        ) -> UIButton {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = font
            button.setTitleColor(textColor, for: .normal)
    
            if let _ = image {
                button.setImage(image, for: .normal)
                button.tintColor = textColor
            } else {
                button.setTitle(content, for: .normal)
            }
    
            button.addTarget(self, action: action, for: .touchUpInside)
            button.backgroundColor = backgroundColor
            button.layer.cornerRadius = CGFloat(cornerRadius)
    
            button.heightAnchor.constraint(equalToConstant: CGFloat(size)).isActive = true
    
    
            return button
        }
    
    //    // MARK: - Add Button
    //    static func getAddButton(action: Selector) -> UIButton {
    //
    //        let imageButton = UIImage(systemName: "plus.circle.fill", withConfiguration:
    //        UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .medium))!
    //
    //        let button = Components.getButton(image: imageButton, action: action,font: UIFont.systemFont(ofSize: 29, weight: .semibold), textColor: .verdeClaro, backgroundColor: .clear, size: 29)
    //               button.heightAnchor.constraint(equalToConstant: 29).isActive = true
    //               button.widthAnchor.constraint(equalToConstant: 29).isActive = true
    //        return button
    //    }
    //
    //    // MARK: Symptom Button
    //    static func getSymptomButton(
    //        action: Selector,
    //        isSelected: Bool,
    //        content: String = ""
    //    ) -> UIButton {
    //
    //        let dynamicTextColor = UIColor { trait in
    //            return isSelected
    //            ? .white
    //            : (trait.userInterfaceStyle == .dark ? .white : .verdeEscuro)
    //        }
    //
    //        let dynamicBackgroundColor = UIColor { trait in
    //            return isSelected
    //            ? .verdeEscuro
    //            : (trait.userInterfaceStyle == .dark ? .fillsPrimary : .systemGray5)
    //        }
    //
    //        let button = Components.getButton(
    //            content: content,
    //            image: nil,
    //            action: action,
    //            font: Fonts.body,
    //            textColor: dynamicTextColor,
    //            backgroundColor: dynamicBackgroundColor,
    //            cornerRadius: 8
    //        )
    //        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
    //        return button
    //    }
    //
    //    static func getTextButton(title: String, action: Selector) -> UIButton {
    //        let button = UIButton(type: .system)
    //        button.setTitle(title, for: .normal)
    //        button.addTarget(nil, action: action, for: .touchUpInside)
    //        button.setTitleColor(.verdeClaro, for: .normal)
    //        button.titleLabel?.font = UIFont(name: "subheadline", size: 15)
    //        return button
    //    }
    //}
}
