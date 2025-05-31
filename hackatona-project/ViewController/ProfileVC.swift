//
//  ProfileViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//
import UIKit
import AVFoundation

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var audioFiles: [String] = []
    let tableView = UITableView()
    var player: AVAudioPlayer?

// <<<<<<< feat/audio-recording
//     override func viewDidLoad() {
//         super.viewDidLoad()
//         title = "Áudios Gravados"
//         view.backgroundColor = .white

//         tableView.frame = view.bounds
//         tableView.dataSource = self
//         tableView.delegate = self
//         view.addSubview(tableView)

//         loadAudioFiles()
//     }

//     func loadAudioFiles() {
//         let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

//         do {
//             let files = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
//             audioFiles = files.filter { $0.hasSuffix(".m4a") }
//             tableView.reloadData()
//         } catch {
//             print("Erro ao listar arquivos:", error)
//         }
//     }

//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         return audioFiles.count
//     }

//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//         cell.textLabel?.text = audioFiles[indexPath.row]
//         return cell
//     }

//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let fileName = audioFiles[indexPath.row]
//         playAudio(fileName: fileName)
//         tableView.deselectRow(at: indexPath, animated: true)
//     }

//     func playAudio(fileName: String) {
//         let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//         let audioURL = documentsPath.appendingPathComponent(fileName)

//         do {
//             player = try AVAudioPlayer(contentsOf: audioURL)
//             player?.volume = 1.0
//             player?.prepareToPlay()
//             player?.play()
//         } catch {
//             print("Erro ao tocar áudio:", error)
//         }
// =======
class ProfileViewController: UIViewController {

    private lazy var headerView = ProfileHeader()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        return table
    }()

    var receivedFeedbacks: [Feedback] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var sendedFeedbacks: [Feedback] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}



extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return receivedFeedbacks.isEmpty ? 1 : receivedFeedbacks.count
        } else {
            return sendedFeedbacks.isEmpty ? 1 : sendedFeedbacks.count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return GenericTableViewHeader(
                image: UIImage(systemName: "trophy")!,
                text: "Feedbacks recebidos",
                button: Components.getTextButton(
                    title: "Ver todos",
                    action: #selector(seeAllReceived)
                    ),
                backgroundColor: .systemBackground
            )
        } else {
            return GenericTableViewHeader(
                image: UIImage(systemName: "paperplane")!,
                text: "Feedbacks enviados",
                button: Components.getTextButton(
                    title: "Ver todos",
                    action: #selector(seeAllSended)
                    ),
                backgroundColor: .systemBackground
            )
        }
    }
    
    @objc func seeAllReceived() {

//        navigationController?.pushViewController(MealHistoryController(), animated: true)

    }
    
    @objc func seeAllSended() {

//        navigationController?.pushViewController(MealHistoryController(), animated: true)

    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            if receivedFeedbacks.isEmpty {
                let cell = EmptyTableViewCell()
                cell.config(0)
                cell.backgroundColor = .clear
                return cell
            }

            let cell = FeedbackTableViewCell()
            cell.config(receivedFeedbacks[indexPath.row])
            cell.backgroundColor = .clear
            return cell
        } else {
            if sendedFeedbacks.isEmpty {
                let cell = EmptyTableViewCell()
                cell.config(1)
                cell.backgroundColor = .clear
                return cell
            }

            let cell = FeedbackTableViewCell()
            cell.config(sendedFeedbacks[indexPath.row])
            cell.backgroundColor = .clear
            return cell
        }
    }
}


// MARK: Table View Delegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let cornerRadius: CGFloat = 12
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)

        cell.contentView.layer.cornerRadius = 0
        cell.contentView.layer.maskedCorners = []

        if indexPath.row == 0 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
            ]
        }

        if indexPath.row == totalRows - 1 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner,
            ]
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: cell.bounds.width,
                bottom: 0,
                right: 0
            )
        }

        if totalRows == 1 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner,
            ]
        }

        cell.contentView.layer.masksToBounds = true
    }

}

extension ProfileViewController: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(headerView)
        view.addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.backgroundColor = .black
        headerView.translatesAutoresizingMaskIntoConstraints = false
    }
}
