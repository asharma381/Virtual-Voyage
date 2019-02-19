//
//  InitialController.swift
//  iOS
//
//  Created by Aditya Sharma on 2/16/19.
//  Copyright © 2019 MBIENTLAB, INC. All rights reserved.
//

import UIKit

class InitialController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.backgroundColor = UIColor.red
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
       // transform = CGAffine
    }
    

}
