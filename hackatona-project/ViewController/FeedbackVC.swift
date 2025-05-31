//
//  FeedbackViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        segmentedControl.selectionDelegate = self
        
        configureSearchController()

        setupMockData()
        
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
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar (nome, tipo, cargo etc.)"
        searchController.searchBar.autocapitalizationType = .none
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupMockData() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        employees = [
            Employee(
                id: "e1",
                email: "ana.silva@empresa.com",
                password: "••••••",
                name: "Ana Silva",
                cargo: "Desenvolvedora iOS",
                image: "ana_profile.jpg",
                qrCode: "qrcode_ana.png"
            ),
            Employee(
                id: "e2",
                email: "bruno.lima@empresa.com",
                password: "••••••",
                name: "Bruno Lima",
                cargo: "Analista de Dados",
                image: "bruno_profile.jpg",
                qrCode: "qrcode_bruno.png"
            ),
            Employee(
                id: "e3",
                email: "carla.rodrigues@empresa.com",
                password: "••••••",
                name: "Carla Rodrigues",
                cargo: "Product Manager",
                image: "carla_profile.jpg",
                qrCode: "qrcode_carla.png"
            )
        ]
        
        resources = [
            Resource(
                id: "r1",
                type: "Livro",
                name: "Design Patterns Essenciais",
                averageRating: 4.7,
                photo: "design_patterns_cover.jpg"
            ),
            Resource(
                id: "r2",
                type: "Artigo",
                name: "Guia do Combine",
                averageRating: 4.3,
                photo: "combine_article.png"
            ),
            Resource(
                id: "r3",
                type: "Vídeo",
                name: "Ray Wenderlich - SwiftUI",
                averageRating: 4.9,
                photo: "rw_swiftui.png"
            )
        ]
        
        activities = [
            Activity(
                id: "a1",
                name: "Treinamento SwiftUI",
                type: "Workshop",
                averageRating: 4.5,
                date: df.date(from: "2025-06-05")!,
                image: ""
            ),
            Activity(
                id: "a2",
                name: "Palestra NestJS",
                type: "Palestra",
                averageRating: 4.8,
                date: df.date(from: "2025-06-10")!,
                image: ""
            ),
            Activity(
                id: "a3",
                name: "Oficina de UX/UI",
                type: "Oficina",
                averageRating: 4.2,
                date: df.date(from: "2025-06-12")!,
                image: ""
                
            )
        ]
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
            )
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
                    role: employee.cargo,
                    )
            }
            
        case 1:
            let letter = sectionsResources[indexPath.section]
            if let resource = sectionedResources[letter]?[indexPath.row] {
                let _ = "\(resource.type) • \(String(format: "%.1f", resource.averageRating))"
                cell.configure(
                    name: resource.name,
                    role: resource.type,
                    )
            }
            
        case 2:
            let letter = sectionsActivities[indexPath.section]
            if let activity = sectionedActivities[letter]?[indexPath.row] {
                let df = DateFormatter()
                df.dateStyle = .short
                df.timeStyle = .none
                let dateString = df.string(from: activity.date)
                let _ = "\(activity.type) • \(String(format: "%.1f", activity.averageRating)) • \(dateString)"
                cell.configure(
                    name: activity.name,
                    role: activity.type,
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
    
    func sectionIndexTitles(
        for tableView: UITableView
    ) -> [String]? {
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
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 80
    }
}

extension FeedbackViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            filteredActivities = activities
            organizeSectionsForActivities()
        case 1:
            filteredResources = resources
            organizeSectionsForResources()
        case 2:
            filteredEmployees = employees
            organizeSectionsForEmployees()
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
            organizeSectionsForActivities()
            
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
            organizeSectionsForEmployees()
            
        default:
            break
        }
    }
}

extension FeedbackViewController: NativeSegmentedDelegate {
    func didChangeSelection(to index: Int) {
        switch index {
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
