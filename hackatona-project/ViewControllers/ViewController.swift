//
//  ViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 30/05/25.
//

import UIKit

class ViewController: UIViewController {
    
    var label: UILabel = {
        var text = UILabel()
        text.text = "Hello world"
        text.textColor = .red
        return text
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        super.view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
}
extension ViewController: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(label)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}



