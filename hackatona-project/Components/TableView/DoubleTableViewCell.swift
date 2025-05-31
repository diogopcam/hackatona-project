//
//  MealTableViewCell.swift
//  AvoTracker
//
//  Created by João Pedro Teixeira de Caralho on 13/05/25.
//
import UIKit

class DoubleTableViewCell: UITableViewCell {
    
    // MARK: - Reuse ID
    static let reuseIdentifier = "double-cell"
    
    
    // MARK: - Title label
    lazy var titleLabel = Components.getLabel(content: "", font: Fonts.body)
    lazy var titleLabel2 = Components.getLabel(content: "", font: Fonts.body)
    
    
    // MARK: - Description label
    lazy var descriptionLabel = Components.getLabel(content: "", font: Fonts.subheadline, textColor: .labelsSecondary)
    lazy var descriptionLabel2 = Components.getLabel(content: "", font: Fonts.subheadline, textColor: .labelsSecondary)
    
    
    // MARK: - Title-Description stack
    lazy var titleDescriptionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()
    
    lazy var titleDescriptionStack2: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel2, descriptionLabel2])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()
    
    // MARK: - Main stack
    lazy var mainStack1: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleDescriptionStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.backgroundColor = .backgroundPrimary
        stack.alignment = .center
        stack.layer.cornerRadius = 13
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        return stack
    }()
    
    lazy var mainStack2: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleDescriptionStack2])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.backgroundColor = .backgroundPrimary
        stack.alignment = .center
        stack.layer.cornerRadius = 13
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        return stack
    }()
    
    lazy var doubleMainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainStack1, mainStack2])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 21
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    
    // MARK: - Config
    func config(_ food1: (String, [Symptom]), _ food2: (String, [Symptom])) {
        titleLabel.text = food1.0
        if food1.1.count == 1 {
            descriptionLabel.text = "Sintoma \(food1.1.count) vez"
        } else {
            descriptionLabel.text = "Sintomas \(food1.1.count) vezes"
        }
       
        
        titleLabel2.text = food2.0
        if food2.1.count == 1 {
            descriptionLabel2.text = "Sintoma \(food2.1.count) vez"
        } else {
            descriptionLabel2.text = "Sintomas \(food2.1.count) vezes"
        }
       
        
    }
    
    func configSymptom(_ symptom1: SymptomOccurrence, _ symptom2: SymptomOccurrence) {
        titleLabel.text = symptom1.symptom.name.capitalizingFirstLetter()
        descriptionLabel.text = "Mais comum"
        
        titleLabel2.text = symptom2.symptom.name.capitalizingFirstLetter()
        descriptionLabel2.text = "Comum"
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundPrimary
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Code Protocol
extension DoubleTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        contentView.addSubview(doubleMainStack)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            doubleMainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            doubleMainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            doubleMainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            doubleMainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            doubleMainStack.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    
}
