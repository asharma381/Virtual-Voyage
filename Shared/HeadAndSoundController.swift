//
//  HeadAndSoundController.swift
//  iOS
//
//  Created by Lekshmi Pillai Chidambarathanu on 7/25/18.
//  Copyright © 2018 MBIENTLAB, INC. All rights reserved.
//


import AVFoundation
import UIKit
import MetaWear

protocol SendXYZAndDevice : class {
    var device: MBLMetaWear! { get set }
}

class HeadAndSoundController: UIViewController {
    
    //var dataRecieverView : DeviceViewController?
    var sendXYZDevice: SendXYZAndDevice? = nil
    
  
    
    let PI : Double = 3.14159265359
    @IBOutlet weak var headView: headViewController!
    var playSoundController: PlaySoundsController!
    
  
    @IBOutlet weak var label1: UILabel!
    
    //var dataRecieverView : DeviceViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getSecondaryFusionValues()
        //headView.setPointerPosition(w: 0.0, x: val1, y: val2, z: val3)
        
        print("view will appear")
        if (self.sendXYZDevice?.device) != nil {
            print("Device ready.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
    }
    
    @IBAction func startPresser(_ sender: AnyObject) {
        
        sendXYZDevice?.device?.sensorFusion?.eulerAngle.startNotificationsAsync { (obj, error) in
            self.getSecondaryFusionValues(obj: obj!)
            }.success { result in
                print("Successfully subscribed")
            }.failure { error in
                print("Error on subscribe: \(error)")
        }
        loadSounds()
        
    }
    
    func getSecondaryFusionValues(obj : MBLEulerAngleData){
        //headView.setPointerPosition(w: 0.0, x: val1, y: val2, z: val3)
        let x = radians((obj.p * -1) + 90)
        let y = radians(abs(365 - obj.y))
        let z = radians(obj.r)
        print(x)
        print(y)
        print(z)
        headView.setPointerPosition(w: 0.0, x: x, y: y, z: z)
        playSoundController.updateAngularOrientation(Float(obj.h), Float(obj.p), Float(obj.r))
    }
    
     //@IBOutlet weak var deviceStatusLabel: UILabel!
    
    //var timer : Timer?
    //var startTime : TimeInterval?
    
   /**
    override func viewWillAppear(_ animated: Bool) {
        
        loadSounds()
    }*/
    /**
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        device.removeObserver(self, forKeyPath: "state")
        device.led?.flashColorAsync(UIColor.red, withIntensity: 1.0, numberOfFlashes: 3)
        device.disconnectAsync()
    }
 *//*
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        OperationQueue.main.addOperation {
            switch (self.device.state) {
            case .connected:
                self.deviceStatusLabel.text = "Connected";
                self.device.sensorFusion?.mode = MBLSensorFusionMode.imuPlus
                print("Connected")
            case .connecting:
                self.deviceStatusLabel.text = "Connecting";
                print("Connected")
            case .disconnected:
                self.deviceStatusLabel.text = "Disconnected";
                print("disconnected")
            case .disconnecting:
                self.deviceStatusLabel.text = "Disconnecting";
                print("disconnected")
            case .discovery:
                self.deviceStatusLabel.text = "Discovery";
                print("disconnected")
            }
        }
    }*/
    /**
    func getFusionValues(obj: MBLEulerAngleData){
        
        let xS =  String(format: "%.02f", (obj.p))
        let yS =  String(format: "%.02f", (obj.y))
        let zS =  String(format: "%.02f", (obj.r))
        
        let x = radians((obj.p * -1) + 90)
        let y = radians(abs(365 - obj.y))
        let z = radians(obj.r)
        headView.setPointerPosition(w: 0.0, x : x, y: y, z: z)
        playSoundController.updateAngularOrientation(abs(Float(365 - obj.y)))
        
        // Send OSC here
    }*/
    /**
    func getSecondaryFusionValues(){
        headView.setPointerPosition(w: 0.0, x: val1, y: val2, z: val3)
        playSoundController.updateAngularOrientation(abs(Float(val2)))
    }*/
    func radians(_ degree: Double) -> Double {
        return ( PI/180 * degree)
    }
    func degrees(_ radian: Double) -> Double {
        return (180 * radian / PI)
    }
    /*
    @IBAction func startPressed(sender: AnyObject) {
        
        device.sensorFusion?.eulerAngle.startNotificationsAsync { (obj, error) in
            self.getFusionValues(obj: obj!)
            }.success { result in
                print("Successfully subscribed")
            }.failure { error in
                print("Error on subscribe: \(error)")
        }
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        device.sensorFusion?.eulerAngle.stopNotificationsAsync().success { result in
            print("Successfully unsubscribed")
            }.failure { error in
                print("Error on unsubscribe: \(error)")
        }
    }*/
    func loadSounds(){
        var soundArray : [String] = []
        for index in 0...3{
            soundArray.append(String(index) + ".wav")
            
        }
        playSoundController = PlaySoundsController(file: soundArray)
        
        playSoundController.updatePosition(index: 0, position: AVAudio3DPoint(x: 0, y: 0, z: -15))
        playSoundController.updatePosition(index: 1, position: AVAudio3DPoint(x: 7.5, y: 10, z: 7.5 * sqrt(2.0)))
        playSoundController.updatePosition(index: 2, position: AVAudio3DPoint(x: 0, y: -2, z: 0))
        playSoundController.updatePosition(index: 3, position: AVAudio3DPoint(x: -100, y: 10, z: -5))
        
        for sounds in soundArray.enumerated(){
            // skip seagguls
            if sounds.offset != 3 {
                playSoundController.play(index: sounds.offset)
            }
        }
        
    }/*
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }*/
 
}

