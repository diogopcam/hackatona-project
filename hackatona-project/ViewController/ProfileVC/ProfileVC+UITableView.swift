//
//  ProfileVC+UITableView.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

extension ProfileVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? receivedFeedbacks : sendedFeedbacks).isEmpty ? 1 : (section == 0 ? receivedFeedbacks.count : sendedFeedbacks.count)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return GenericTableViewHeader(
                image: UIImage(systemName: "trophy")!,
                text: "Feedbacks recebidos",
                button: Components.getTextButton(
                    title: "Ver todos",
                    action: #selector(seeAllReceived)
                )
            )
        } else {
            return GenericTableViewHeader(
                image: UIImage(systemName: "paperplane")!,
                text: "Feedbacks enviados",
                button: Components.getTextButton(
                    title: "Ver todos",
                    action: #selector(seeAllSended)
                )
            )
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section

        let feedbacks = section == 0 ? receivedFeedbacks : sendedFeedbacks

        if feedbacks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyTableViewCell
            cell.config(section)
            cell.backgroundColor = .clear
            return cell
        }

        let feedback = feedbacks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackTableViewCell
        let name = "Usuário Exemplo" // TODO: Substituir pelo nome real se disponível
        cell.config(feedback, name: name)
        cell.backgroundColor = .clear
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let feedbacks = indexPath.section == 0 ? receivedFeedbacks : sendedFeedbacks

        guard !feedbacks.isEmpty else { return }

        let feedback = feedbacks[indexPath.row]
        let detailVC = FeedBackDetailsVC(feedback: feedback)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 12
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)

        cell.contentView.layer.cornerRadius = 0
        cell.contentView.layer.maskedCorners = []

        if indexPath.row == 0 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        if indexPath.row == totalRows - 1 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: cell.bounds.width,
                bottom: 0,
                right: 0
            )
        }

        if totalRows == 1 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner,
            ]
        }

        cell.contentView.layer.masksToBounds = true
    }
}
