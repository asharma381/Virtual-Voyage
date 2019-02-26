//
//  TransitionViewController.swift
//  iOS
//
//  Created by Aditya Sharma on 2/19/19.
//  Copyright © 2019 MBIENTLAB, INC. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var startTutorialLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTutorialLabel.layer.masksToBounds = true
        startTutorialLabel.layer.cornerRadius = 10
        startTutorialLabel.backgroundColor = UIColor.gray
        
        dismissButton.backgroundColor = UIColor.white
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.transform = dismissButton.transform.rotated(by: CGFloat(M_PI_4))
        dismissButton.layer.shadowOpacity = 0.25
        dismissButton.layer.shadowRadius = 5
        dismissButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    @IBAction func dismissSecondVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutorialCollectionViewCell
        cell.title.text = "Audio Tutorial"
        cell.desc.text = "This is the description text!"
        //cell.button.setTitle(<#T##title: String?##String?#>, for: <#T##UIControlState#>)
        //cell.button.buttonType = UIButtonType.roundedRect
        
        cell.contentView.layer.cornerRadius = 4
        cell.contentView.layer.borderWidth = 1.0;
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.opacity = 1.0
        cell.layer.masksToBounds = false
        
        
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        print("hi")
        return cell
    }
}
