//
//  StoreVC+UITableViewDataSource.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

extension StoreVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return benefits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BenefitCell.identifier, for: indexPath) as? BenefitCell else {
            return UITableViewCell()
        }
        
        let benefit = benefits[indexPath.row]
        let category = getCategoryForBenefit(benefit)
        let icon = getIconForBenefit(benefit)
        
        cell.configure(with: benefit, category: category, icon: icon)
        return cell
    }
}
