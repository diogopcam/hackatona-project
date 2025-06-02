//
//  RankingViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//
import UIKit
import Combine

class RankingVC: UIViewController, NativeSegmentedDelegate {
    private let employeeViewModel = EmployeeViewModel()
    private let resourceViewModel = ResourceViewModel()
    private let activityViewModel = ActivityViewModel()
    
    func didChangeSelection(to index: Int) {
        switch index {
        case 0:
            fetchEmployeeRanking()
        case 1:
            fetchResourceRanking()
        case 2:
            fetchActivityRanking()
        default:
            currentRankings = employeeRankings
        }
        
        configurePodium()
        tableView.reloadData()
    }
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .mainGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var segmentedControl: SegmentedControl = {
        var segmentedControl: SegmentedControl = SegmentedControl()
        segmentedControl.selectionDelegate = self
        return segmentedControl
    }()
    
    private lazy var podiumView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundSecondary
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secondPlaceView = createPodiumPlayerView()
    private lazy var firstPlaceView = createPodiumPlayerView()
    private lazy var thirdPlaceView = createPodiumPlayerView()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(RankingCell.self, forCellReuseIdentifier: RankingCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var employeeRankings: [(name: String, position: Int, imageURL: String?)] = []
    private var resourceRankings: [(name: String, position: Int, imageURL: String?)] = []
    private var activityRankings: [(name: String, position: Int, imageURL: String?)] = []
    private var currentRankings: [(name: String, position: Int, imageURL: String?)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ranking"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupObservers()
        fetchEmployeeRanking()
        setup()
        view.backgroundColor = .backgroundPrimary
    }
    
    private func setupObservers() {
        employeeViewModel.$employees
            .receive(on: DispatchQueue.main)
            .sink { [weak self] employees in
                self?.updateEmployeeRankings(employees)
            }
            .store(in: &cancellables)
            
        // Resource observers
        resourceViewModel.$resources
            .receive(on: DispatchQueue.main)
            .sink { [weak self] resources in
                self?.updateResourceRankings(resources)
            }
            .store(in: &cancellables)
            
        // Activity observers
        activityViewModel.$activities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] activities in
                self?.updateActivityRankings(activities)
            }
            .store(in: &cancellables)
            
        // Loading state observers
        employeeViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
            
        resourceViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
            
        activityViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
            
        // Error observers
        employeeViewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let errorMessage = error {
                    self?.showError(message: errorMessage)
                }
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
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func fetchEmployeeRanking() {
        employeeViewModel.fetchEmployeeRanking()
    }
    
    private func fetchResourceRanking() {
        resourceViewModel.fetchResources()
    }
    
    private func fetchActivityRanking() {
        activityViewModel.fetchActivities()
    }
    
    private func updateEmployeeRankings(_ employees: [Employee]) {
        employeeRankings = employees.enumerated().map { index, employee in
            (
                name: employee.name,
                position: index + 1,
                imageURL: employee.midia
            )
        }
        
        if segmentedControl.segmentedControl.selectedSegmentIndex == 0 {
            currentRankings = employeeRankings
            configurePodium()
            tableView.reloadData()
        }
    }
    
    private func updateResourceRankings(_ resources: [Resource]) {
        resourceRankings = resources.enumerated().map { index, resource in
            (
                name: resource.name,
                position: index + 1,
                imageURL: resource.photo
            )
        }
        
        if segmentedControl.segmentedControl.selectedSegmentIndex == 1 {
            currentRankings = resourceRankings
            configurePodium()
            tableView.reloadData()
        }
    }
    
    private func updateActivityRankings(_ activities: [Activity]) {
        activityRankings = activities.enumerated().map { index, activity in
            (
                name: activity.name,
                position: index + 1,
                imageURL: nil
            )
        }
        
        if segmentedControl.segmentedControl.selectedSegmentIndex == 2 {
            currentRankings = activityRankings
            configurePodium()
            tableView.reloadData()
        }
    }
    
    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()
    
    private func createPodiumPlayerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .mainGreen
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let positionLabel = UILabel()
        positionLabel.font = .systemFont(ofSize: 20, weight: .bold)
        positionLabel.textColor = .labelPrimary
        positionLabel.textAlignment = .center
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.tag = 200
        positionLabel.isHidden = true
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .labelPrimary
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let crownImage = UIImageView()
        crownImage.image = UIImage(systemName: "crown.fill")
        crownImage.tintColor = .systemYellow
        crownImage.translatesAutoresizingMaskIntoConstraints = false
        crownImage.tag = 100
        crownImage.isHidden = true
        
        view.addSubview(imageView)
        view.addSubview(positionLabel)
        view.addSubview(nameLabel)
        view.addSubview(crownImage)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            positionLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            positionLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 2),
            
            crownImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            crownImage.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 2),
            crownImage.widthAnchor.constraint(equalToConstant: 24),
            crownImage.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.tag = 0
        return view
    }
    
    private func configurePodium() {
        if let firstPlace = currentRankings.first {
            configurePosition(view: firstPlaceView, name: firstPlace.name, tag: 1, imageURL: firstPlace.imageURL)
            (firstPlaceView.viewWithTag(100) as? UIImageView)?.isHidden = false
        }
        
        if currentRankings.count > 1 {
            let secondPlace = currentRankings[1]
            configurePosition(view: secondPlaceView, name: secondPlace.name, tag: 2, imageURL: secondPlace.imageURL)
        }
        
        if currentRankings.count > 2 {
            let thirdPlace = currentRankings[2]
            configurePosition(view: thirdPlaceView, name: thirdPlace.name, tag: 3, imageURL: thirdPlace.imageURL)
        }
    }
    
    private func configurePosition(view: UIView, name: String, tag: Int, imageURL: String? = nil) {
        view.tag = tag
        let nameLabel = view.subviews.first { $0 is UILabel && $0.tag != 200 } as? UILabel
        let crownImage = view.subviews.first { $0 is UIImageView && $0.tag == 100 } as? UIImageView
        let positionLabel = view.subviews.first { $0 is UILabel && $0.tag == 200 } as? UILabel
        let imageView = view.subviews.first { $0 is UIImageView && $0.tag != 100 } as? UIImageView
        
        nameLabel?.text = name
        crownImage?.isHidden = tag != 1
        
        if tag > 1 {
            positionLabel?.isHidden = false
            positionLabel?.text = "\(tag)"
            crownImage?.isHidden = true
        } else {
            positionLabel?.isHidden = true
        }
        
        imageView?.subviews.forEach { $0.removeFromSuperview() }
        
        if let imageURLString = imageURL,
           let url = URL(string: imageURLString),
           let imageView = imageView {
            let firstLetter = String(name.prefix(1)).uppercased()
            let label = UILabel()
            label.text = firstLetter
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.frame = imageView.bounds
            imageView.image = nil
            imageView.addSubview(label)
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data,
                      let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    imageView.subviews.forEach { $0.removeFromSuperview() }
                    imageView.image = image
                }
            }.resume()
        } else if let imageView = imageView {
            let firstLetter = String(name.prefix(1)).uppercased()
            let label = UILabel()
            label.text = firstLetter
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.frame = imageView.bounds
            imageView.image = nil
            imageView.addSubview(label)
        }
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // Implement segment control logic here
        tableView.reloadData()
    }
}

// MARK: - ViewCodeProtocol
extension RankingVC: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(segmentedControl)
        view.addSubview(podiumView)
        podiumView.addSubview(secondPlaceView)
        podiumView.addSubview(firstPlaceView)
        podiumView.addSubview(thirdPlaceView)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            podiumView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            podiumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            podiumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            podiumView.heightAnchor.constraint(equalToConstant: 180),
            
            firstPlaceView.centerXAnchor.constraint(equalTo: podiumView.centerXAnchor),
            firstPlaceView.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: -48),
            firstPlaceView.widthAnchor.constraint(equalToConstant: 100),
            
            secondPlaceView.rightAnchor.constraint(equalTo: firstPlaceView.leftAnchor, constant: -16),
            secondPlaceView.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: -32),
            secondPlaceView.widthAnchor.constraint(equalToConstant: 100),
            
            thirdPlaceView.leftAnchor.constraint(equalTo: firstPlaceView.rightAnchor, constant: 16),
            thirdPlaceView.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: -32),
            thirdPlaceView.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension RankingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRankings.count - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingCell.identifier, for: indexPath) as? RankingCell else {
            return UITableViewCell()
        }
        
        let ranking = currentRankings[indexPath.row + 3]
        cell.configure(
            name: ranking.name,
            position: ranking.position,
            imageURL: ranking.imageURL
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
