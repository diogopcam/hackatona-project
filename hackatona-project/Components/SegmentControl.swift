//
//  SegmentControl.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import UIKit

protocol NativeSegmentedDelegate: AnyObject {
    func didChangeSelection(to index: Int)
}

class SegmentedControl: UIView {

    weak var selectionDelegate: NativeSegmentedDelegate?

    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            "Employes", "Locals", "Events",
        ])
        control.selectedSegmentIndex = 0


        control.backgroundColor =
            UIColor(named: "background-secondary") ?? .systemGray6
        control.selectedSegmentTintColor = .mainGreen

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "label-primary") ?? .black,
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "label-primary") ?? .black,
            .font: UIFont.systemFont(ofSize: 13, weight: .bold),
        ]

        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)

        control.translatesAutoresizingMaskIntoConstraints = false

        return control
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(
            self,
            action: #selector(segmentChanged(_:)),
            for: .valueChanged
        )
        setup()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        selectionDelegate?.didChangeSelection(to: sender.selectedSegmentIndex)
    }

}

extension SegmentedControl: ViewCodeProtocol {
    func addSubViews() {
        self.addSubview(segmentedControl)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor
            ),
            segmentedControl.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor
            ),
            segmentedControl.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor
            ),
            segmentedControl.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor
            ),
        ])
    }
}
