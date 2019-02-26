//
//  LaunchScreenAnimationViewController.swift
//  iOS
//
//  Created by Aditya Sharma on 2/18/19.
//  Copyright © 2019 MBIENTLAB, INC. All rights reserved.
//

import UIKit

class LaunchScreenAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: <#T##Selector#>, with: <#T##Any?#>)
        //performSelector(onMainThread: "showNavController", with: nil, waitUntilDone: 3)
        //performSelec
        // Do any additional setup after loading the view.
    }
    
    func showNavController () {
        performSegue(withIdentifier: "showSplashScreen", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
