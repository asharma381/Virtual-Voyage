//
//  AudioTutorialViewController.swift
//  iOS
//
//  Created by Aditya Sharma on 2/16/19.
//  Copyright © 2019 MBIENTLAB, INC. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTutorialViewController: UIViewController {

    @IBOutlet weak var Audio: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func speech(_ sender: Any) {
        let speech = AVSpeechUtterance(string: "Hello World! I am your personal assistant. Today I will be giving you a tour of the world!")
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        speech.rate = 0.50;
        
        let synthesizer = AVSpeechSynthesizer();
        synthesizer.speak(speech)
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
