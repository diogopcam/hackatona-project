//
//  FeedbackVC+UITableView.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

extension FeedbackVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            return sectionsEmployees.count
        case 1:
            return sectionsResources.count
        case 2:
            return sectionsActivities.count
        default:
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            let letter = sectionsEmployees[section]
            return sectionedEmployees[letter]?.count ?? 0
        case 1:
            let letter = sectionsResources[section]
            return sectionedResources[letter]?.count ?? 0
        case 2:
            let letter = sectionsActivities[section]
            return sectionedActivities[letter]?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollaboratorTableViewCell.identifier,
            for: indexPath
        ) as? CollaboratorTableViewCell else {
            return UITableViewCell()
        }
        
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            let letter = sectionsEmployees[indexPath.section]
            if let employee = sectionedEmployees[letter]?[indexPath.row] {
                cell.configure(
                    name: employee.name,
                    role: employee.position,
                    imageURL: employee.midia
                )
            }
            
        case 1:
            let letter = sectionsResources[indexPath.section]
            if let resource = sectionedResources[letter]?[indexPath.row] {
                cell.configure(
                    name: resource.name,
                    role: resource.type,
                    imageURL: resource.photo
                )
            }
            
        case 2:
            let letter = sectionsActivities[indexPath.section]
            if let activity = sectionedActivities[letter]?[indexPath.row] {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                let dateString = dateFormatter.string(from: activity.createdAt)
                cell.configure(
                    name: activity.name,
                    role: "\(activity.type) • \(dateString)"
                )
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: AlphabeticalHeaderView.identifier
        ) as? AlphabeticalHeaderView else {
            return nil
        }
        
        let titleForHeader: String
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            titleForHeader = sectionsEmployees[section]
        case 1:
            titleForHeader = sectionsResources[section]
        case 2:
            titleForHeader = sectionsActivities[section]
        default:
            titleForHeader = ""
        }
        
        headerView.configure(with: titleForHeader)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0: // Employees
            let letter = sectionsEmployees[indexPath.section]
            if let employee = sectionedEmployees[letter]?[indexPath.row] {
                let vc = CreateFeedbackVC(employee: employee)
                navigationController?.pushViewController(vc, animated: true)
            }

        case 1: // Resources
            let letter = sectionsResources[indexPath.section]
            if let resource = sectionedResources[letter]?[indexPath.row] {
                let vc = CreateFeedbackVC(resource: resource)
                navigationController?.pushViewController(vc, animated: true)
            }

        case 2: // Activities
            let letter = sectionsActivities[indexPath.section]
            if let activity = sectionedActivities[letter]?[indexPath.row] {
                let vc = CreateFeedbackVC(activity: activity)
                navigationController?.pushViewController(vc, animated: true)
            }

        default:
            break
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 40
    }
    
    func sectionIndexTitles(
        for tableView: UITableView
    ) -> [String]? {
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.sectionIndexColor = .mainGreen
            tableView.sectionIndexBackgroundColor = .backgroundPrimary
            return sectionsEmployees
        case 1:
            tableView.sectionIndexColor = .mainGreen
            tableView.sectionIndexBackgroundColor = .backgroundPrimary
            return sectionsResources
        case 2:
            tableView.sectionIndexColor = .mainGreen
            tableView.sectionIndexBackgroundColor = .backgroundPrimary
            return sectionsActivities
        default:
            return nil
        }
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 80
    }
}
