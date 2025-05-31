//
//  FeedbackViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit
import Combine

class FeedbackViewController: UIViewController {
    private var activities: [Activity] = []
    private var resources: [Resource] = []
    private var employees: [Employee] = []
    
    private var filteredActivities: [Activity] = []
    private var filteredResources: [Resource] = []
    private var filteredEmployees: [Employee] = []
    
    private var sectionedActivities: [String: [Activity]] = [:]
    private var sectionsActivities: [String] = []
    
    private var sectionedResources: [String: [Resource]] = [:]
    private var sectionsResources: [String] = []
    
    private var sectionedEmployees: [String: [Employee]] = [:]
    private var sectionsEmployees: [String] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let segmentedControl: SegmentedControl = {
        let control = SegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let tableView: UITableView = {
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
    
    private let employeeViewModel = EmployeeViewModel()
    private let resourceViewModel = ResourceViewModel()
    private let activityViewModel = ActivityViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .mainGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        searchController.searchBar.placeholder = "Buscar (nome, tipo, cargo etc.)"
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
            
        // Activity observers
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
    
    private func organizeSectionsForActivities() {
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
    
    private func organizeSectionsForResources() {
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
    
    private func organizeSectionsForEmployees() {
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
    
    private func switchToActivities() {
        filteredActivities = activities
        organizeSectionsForActivities()
    }
    
    private func switchToResources() {
        filteredResources = resources
        organizeSectionsForResources()
    }
    
    private func switchToEmployees() {
        filteredEmployees = employees
        organizeSectionsForEmployees()
    }
}

extension FeedbackViewController: ViewCodeProtocol {
    func addSubViews() {
        title = "Feedback"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            segmentedControl.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            segmentedControl.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(
                equalTo: segmentedControl.bottomAnchor,
                constant: 8
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FeedbackViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        tableView.sectionIndexColor = .mainGreen
        tableView.sectionIndexBackgroundColor = .backgroundPrimary
        
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            return sectionsEmployees
        case 1:
            return sectionsResources
        case 2:
            return sectionsActivities
        default:
            return nil
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
                    role: resource.type
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
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 40
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 80
    }
}

extension FeedbackViewController: UISearchBarDelegate {
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

extension FeedbackViewController: UISearchResultsUpdating {
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

extension FeedbackViewController: NativeSegmentedDelegate {
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
