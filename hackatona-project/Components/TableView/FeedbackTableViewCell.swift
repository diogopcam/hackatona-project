//
//  FeedbackTableViewCell.swift
//  hackatona-project
//
//  Created by Diogo on 31/05/25.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .labelPrimary
        return label
    }()
    
    private lazy var starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var mediaIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .mainGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, starsStackView, mediaIcon])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .backgroundSecondary
        stack.spacing = 12
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerStack)

        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            mediaIcon.widthAnchor.constraint(equalToConstant: 24),
            mediaIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func config(_ feedback: Feedback, name: String) {
        nameLabel.text = name
        setupStars(feedback.stars)

        if let midia = feedback.midia {
            if midia.hasSuffix(".m4a") {
                mediaIcon.image = UIImage(systemName: "waveform.circle.fill")
            } else {
                mediaIcon.image = UIImage(systemName: "text.bubble.fill")
            }
        } else {
            if !feedback.description.isEmpty {
                mediaIcon.image = UIImage(systemName: "text.bubble")
            } else {
                mediaIcon.image = UIImage(systemName: "questionmark.circle")
            }
        }
    }

    private func setupStars(_ count: Int) {
        starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for _ in 0..<count {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.tintColor = .systemYellow
            star.contentMode = .scaleAspectFit
            starsStackView.addArrangedSubview(star)
        }

        for _ in count..<5 {
            let star = UIImageView(image: UIImage(systemName: "star"))
            star.tintColor = .systemGray
            star.contentMode = .scaleAspectFit
            starsStackView.addArrangedSubview(star)
        }
    }
}
