//
//  FeedbackViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit
import Combine

class FeedbackVC: UIViewController {
    var activities: [Activity] = []
    var resources: [Resource] = []
    var employees: [Employee] = []
    
    var filteredActivities: [Activity] = []
    var filteredResources: [Resource] = []
    var filteredEmployees: [Employee] = []
    
    var sectionedActivities: [String: [Activity]] = [:]
    var sectionsActivities: [String] = []
    var sectionedResources: [String: [Resource]] = [:]
    
    var sectionsResources: [String] = []
    var sectionedEmployees: [String: [Employee]] = [:]
    var sectionsEmployees: [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var segmentedControl: SegmentedControl = {
        let control = SegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(
            CollaboratorTableViewCell.self,
            forCellReuseIdentifier: CollaboratorTableViewCell.identifier
        )
        table.register(
            AlphabeticalHeaderView.self,
            forHeaderFooterViewReuseIdentifier: AlphabeticalHeaderView.identifier
        )
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var employeeViewModel = EmployeeViewModel()
    lazy var resourceViewModel = ResourceViewModel()
    lazy var activityViewModel = ActivityViewModel()
    
    lazy var cancellables = Set<AnyCancellable>()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .mainGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .mainGreen

        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        segmentedControl.selectionDelegate = self
        
        configureSearchController()

        setupObservers()
        
        filteredActivities = activities
        organizeSectionsForActivities()
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch segmentedControl.segmentedControl.selectedSegmentIndex {
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
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search (name, type, role etc.)"
        searchController.searchBar.autocapitalizationType = .none
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupObservers() {
        // Employee observers
        employeeViewModel.$employees
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newEmployees in
                self?.employees = newEmployees
                self?.filteredEmployees = newEmployees
                self?.organizeSectionsForEmployees()
            }
            .store(in: &cancellables)
            
        employeeViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
            
        employeeViewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let errorMessage = error {
                    self?.showError(message: errorMessage)
                }
            }
            .store(in: &cancellables)
            
        // Resource observers
        resourceViewModel.$resources
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newResources in
                self?.resources = newResources
                self?.filteredResources = newResources
                self?.organizeSectionsForResources()
            }
            .store(in: &cancellables)
            
        resourceViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
            
        resourceViewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let errorMessage = error {
                    self?.showError(message: errorMessage)
                }
            }
            .store(in: &cancellables)
            
        activityViewModel.$activities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newActivities in
                self?.activities = newActivities
                self?.filteredActivities = newActivities
                self?.organizeSectionsForActivities()
            }
            .store(in: &cancellables)
            
        activityViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
            
        activityViewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let errorMessage = error {
                    self?.showError(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            tableView.alpha = 0.5
        } else {
            loadingIndicator.stopAnimating()
            tableView.alpha = 1.0
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(
            title: "Erro",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func organizeSectionsForActivities() {
        sectionedActivities.removeAll()
        sectionsActivities.removeAll()
        
        for item in filteredActivities {
            let letter = item.firstLetter
            if sectionedActivities[letter] == nil {
                sectionedActivities[letter] = []
            }
            sectionedActivities[letter]?.append(item)
        }
        
        sectionsActivities = Array(sectionedActivities.keys).sorted()
        for key in sectionedActivities.keys {
            sectionedActivities[key]?.sort(by: { $0.name < $1.name })
        }
        
        tableView.reloadData()
    }
    
    func organizeSectionsForResources() {
        sectionedResources.removeAll()
        sectionsResources.removeAll()
        
        for item in filteredResources {
            let letter = item.firstLetter
            if sectionedResources[letter] == nil {
                sectionedResources[letter] = []
            }
            sectionedResources[letter]?.append(item)
        }
        
        sectionsResources = Array(sectionedResources.keys).sorted()
        for key in sectionedResources.keys {
            sectionedResources[key]?.sort(by: { $0.name < $1.name })
        }
        
        tableView.reloadData()
    }
    
    func organizeSectionsForEmployees() {
        sectionedEmployees.removeAll()
        sectionsEmployees.removeAll()
        
        for item in filteredEmployees {
            let letter = item.firstLetter
            if sectionedEmployees[letter] == nil {
                sectionedEmployees[letter] = []
            }
            sectionedEmployees[letter]?.append(item)
        }
        
        sectionsEmployees = Array(sectionedEmployees.keys).sorted()
        for key in sectionedEmployees.keys {
            sectionedEmployees[key]?.sort(by: { $0.name < $1.name })
        }
        
        tableView.reloadData()
    }
    
    func switchToActivities() {
        filteredActivities = activities
        organizeSectionsForActivities()
    }
    
    func switchToResources() {
        filteredResources = resources
        organizeSectionsForResources()
    }
    
    func switchToEmployees() {
        filteredEmployees = employees
        organizeSectionsForEmployees()
    }
}
