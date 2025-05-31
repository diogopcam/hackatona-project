//
//  AlphabeticalHeaderView.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import UIKit

class AlphabeticalHeaderView: UITableViewHeaderFooterView {
    static let identifier = "AlphabeticalHeaderView"
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with letter: String) {
        letterLabel.text = letter
    }
}

extension AlphabeticalHeaderView: ViewCodeProtocol {
    func addSubViews() {
        contentView.addSubview(letterLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            letterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            letterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            letterLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
