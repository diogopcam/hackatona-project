//
//  FeedbackVC+SearchDelegate.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

extension FeedbackVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            filteredEmployees = employees
            organizeSectionsForEmployees()
        case 1:
            filteredResources = resources
            organizeSectionsForResources()
        case 2:
            filteredActivities = activities
            organizeSectionsForActivities()
        default:
            break
        }
    }
}

extension FeedbackVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if text.isEmpty {
            switch segmentedControl.segmentedControl.selectedSegmentIndex {
            case 0:
                filteredEmployees = employees
                organizeSectionsForEmployees()
            case 1:
                filteredResources = resources
                organizeSectionsForResources()
            case 2:
                filteredActivities = activities
                organizeSectionsForActivities()
            default:
                break
            }
            return
        }
        
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            filteredEmployees = employees.filter { employee in
                employee.name.lowercased().contains(text) ||
                employee.cargo.lowercased().contains(text)
            }
            organizeSectionsForEmployees()
            
        case 1:
            filteredResources = resources.filter { resource in
                resource.name.lowercased().contains(text) ||
                resource.type.lowercased().contains(text)
            }
            organizeSectionsForResources()
            
        case 2:
            filteredActivities = activities.filter { activity in
                activity.name.lowercased().contains(text) ||
                activity.type.lowercased().contains(text)
            }
            organizeSectionsForActivities()
            
        default:
            break
        }
    }
}

extension FeedbackVC: NativeSegmentedDelegate {
    func didChangeSelection(to index: Int) {
        switch index {
        case 0:
            employeeViewModel.fetchEmployees()
        case 1:
            resourceViewModel.fetchResources()
        case 2:
            activityViewModel.fetchActivities()
        default:
            break
        }
    }
}
