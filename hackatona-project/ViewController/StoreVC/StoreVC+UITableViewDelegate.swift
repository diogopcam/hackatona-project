//
//  StoreVC+UITableViewDelegate.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

extension StoreVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let benefit = benefits[indexPath.row]
        showPurchaseAlert(for: benefit)
    }
    
    private func showPurchaseAlert(for benefit: Benefit) {
        let alert = UIAlertController(
            title: "Confirm Purchase",
            message: "Do you want to exchange for '\(benefit.name)'?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
            self.showSuccessAlert(for: benefit)
        })
        
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(for benefit: Benefit) {
        let alert = UIAlertController(
            title: "Purchase Complete!",
            message: "You exchanged for '\(benefit.name)'. Check your email for details.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
