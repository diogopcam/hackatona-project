//
//  RankingViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//
import UIKit

class RankingViewController: UIViewController, NativeSegmentedDelegate {
    func didChangeSelection(to index: Int) {
        print("Selected index: \(index)")
    }
    
    // MARK: - UI Components
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
    
    // MARK: - Properties
    private var rankings: [(name: String, points: Int, position: Int)] = [
        ("Bryan Wolf", 43, 1),
        ("Meghan Jes", 40, 2),
        ("Alex Turner", 38, 3),
        ("Marsha Fisher", 36, 4),
        ("Juanita Cormier", 35, 5),
        ("You", 34, 6),
        ("Tamara Schmidt", 33, 7),
        ("Ricardo Veum", 32, 8),
        ("Gary Sanford", 31, 9),
        ("Becky Bartell", 30, 10)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configurePodium()
        view.backgroundColor = .backgroundPrimary
    }
    
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
        positionLabel.tag = 200 // Tag para identificar o label de posição
        positionLabel.isHidden = true // Inicialmente escondido, só mostraremos para 2º e 3º
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .labelPrimary
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let pointsLabel = UILabel()
        pointsLabel.font = .systemFont(ofSize: 14, weight: .bold)
        pointsLabel.textColor = .mainGreen
        pointsLabel.textAlignment = .center
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let crownImage = UIImageView()
        crownImage.image = UIImage(systemName: "crown.fill")
        crownImage.tintColor = .systemYellow
        crownImage.translatesAutoresizingMaskIntoConstraints = false
        crownImage.tag = 100
        crownImage.isHidden = true
        
        view.addSubview(imageView)
        view.addSubview(positionLabel)
        view.addSubview(nameLabel)
        view.addSubview(pointsLabel)
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
            
            pointsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            pointsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.tag = 0 // Will be set later for identification
        return view
    }
    
    private func configurePodium() {
        // Configure First Place
        if let firstPlace = rankings.first {
            configurePosition(view: firstPlaceView, name: firstPlace.name, points: firstPlace.points, tag: 1)
            (firstPlaceView.viewWithTag(100) as? UIImageView)?.isHidden = false
        }
        
        // Configure Second Place
        if rankings.count > 1 {
            let secondPlace = rankings[1]
            configurePosition(view: secondPlaceView, name: secondPlace.name, points: secondPlace.points, tag: 2)
        }
        
        // Configure Third Place
        if rankings.count > 2 {
            let thirdPlace = rankings[2]
            configurePosition(view: thirdPlaceView, name: thirdPlace.name, points: thirdPlace.points, tag: 3)
        }
    }
    
    private func configurePosition(view: UIView, name: String, points: Int, tag: Int) {
        view.tag = tag
        let nameLabel = view.subviews.first { $0 is UILabel && $0.tag != 200 } as? UILabel
        let pointsLabel = view.subviews.last { $0 is UILabel } as? UILabel
        let crownImage = view.subviews.first { $0 is UIImageView && $0.tag == 100 } as? UIImageView
        let positionLabel = view.subviews.first { $0 is UILabel && $0.tag == 200 } as? UILabel
        
        nameLabel?.text = name
        pointsLabel?.text = "\(points) pts"
        crownImage?.isHidden = tag != 1
        
        // Configura o label de posição apenas para 2º e 3º lugares
        if tag > 1 {
            positionLabel?.isHidden = false
            positionLabel?.text = "\(tag)"
            crownImage?.isHidden = true
        } else {
            positionLabel?.isHidden = true
        }
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // Implement segment control logic here
        tableView.reloadData()
    }
}

// MARK: - ViewCodeProtocol
extension RankingViewController: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(segmentedControl)
        view.addSubview(podiumView)
        podiumView.addSubview(secondPlaceView)
        podiumView.addSubview(firstPlaceView)
        podiumView.addSubview(thirdPlaceView)
        view.addSubview(tableView)
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
            
            // First Place (Center)
            firstPlaceView.centerXAnchor.constraint(equalTo: podiumView.centerXAnchor),
            firstPlaceView.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: -48),
            firstPlaceView.widthAnchor.constraint(equalToConstant: 100),
            
            // Second Place (Left)
            secondPlaceView.rightAnchor.constraint(equalTo: firstPlaceView.leftAnchor, constant: -16),
            secondPlaceView.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: -32),
            secondPlaceView.widthAnchor.constraint(equalToConstant: 100),
            
            // Third Place (Right)
            thirdPlaceView.leftAnchor.constraint(equalTo: firstPlaceView.rightAnchor, constant: 16),
            thirdPlaceView.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: -32),
            thirdPlaceView.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankings.count - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingCell.identifier, for: indexPath) as? RankingCell else {
            return UITableViewCell()
        }
        
        let ranking = rankings[indexPath.row + 3]
        cell.configure(name: ranking.name, points: ranking.points, position: ranking.position)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
