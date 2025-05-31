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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Áudios Gravados"
        view.backgroundColor = .white

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        loadAudioFiles()
    }

    func loadAudioFiles() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
            audioFiles = files.filter { $0.hasSuffix(".m4a") }
            tableView.reloadData()
        } catch {
            print("Erro ao listar arquivos:", error)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = audioFiles[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileName = audioFiles[indexPath.row]
        playAudio(fileName: fileName)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func playAudio(fileName: String) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentsPath.appendingPathComponent(fileName)

        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.volume = 1.0
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Erro ao tocar áudio:", error)
        }
    }
}
