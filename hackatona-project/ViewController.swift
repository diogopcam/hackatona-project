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
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        // Do any additional setup after loading the view.
    }
}



