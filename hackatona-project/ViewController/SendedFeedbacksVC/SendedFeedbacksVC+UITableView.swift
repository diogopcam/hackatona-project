//
//  SendedFeedbacksVC+UITableView.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//

import UIKit

extension SendedFeedbacksVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sendedFeedbacks.isEmpty ? 1 : sendedFeedbacks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sendedFeedbacks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyTableViewCell
            cell.config(1) // seção 1 = enviados
            cell.backgroundColor = .clear
            return cell
        }

        let feedback = sendedFeedbacks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackTableViewCell
        let name = "Usuário Exemplo" // TODO: pegar nome real
        cell.config(feedback, name: name)
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return GenericTableViewHeader(
            image: UIImage(systemName: "paperplane")!,
            text: "Feedbacks enviados",
            button: nil
        )
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
