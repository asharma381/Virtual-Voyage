//
//  DeviceViewController.swift
//  SwiftStarter
//
//  Created by Stephen Schiffli on 10/20/15.
//  Copyright © 2015 MbientLab Inc. All rights reserved.
//

import UIKit
import MetaWear
import AVFoundation
import MapKit

class DeviceViewController: UIViewController, UISearchBarDelegate, SendXYZAndDevice {
    /**
    var transportX : Double = 0.0
    var transportY : Double = 0.0
    var transportZ : Double = 0.0
    
    func sendXYZHeadPosition(value: Double, value1: Double, value2: Double){
        
    }*/
    
    weak var valuesDelegate : SendXYZAndDevice?
    
    @IBOutlet weak var deviceStatus: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    let PI : Double = 3.14159265359
    
    var device: MBLMetaWear!
    var timer : Timer?
    var startTime : TimeInterval?
    
    var playSoundsController : PlaySoundsController!
    
    var seagullX : Float = -50
    var seagullY : Float = 20
    var seagullZ : Float = -5
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        device.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.new, context: nil)
        device.connectAsync().success { _ in
            self.device.led?.flashColorAsync(UIColor.green, withIntensity: 1.0, numberOfFlashes: 3)
            NSLog("We are connected")
        }
       /**
        var sensorTimer = Timer()
         let aSelector : Selector = #selector(self.getDataFromSensor)
        sensorTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: aSelector,     userInfo: nil, repeats: false)
        */
        //loadSounds()
        //loadSounds()
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let headAndSoundController = segue.destination as? HeadAndSoundController {
            print("Preparing for HeadAndSoundController")
            headAndSoundController.sendXYZDevice = self
        }
    }
    /*
    func getDataFromSensor(){
        device.sensorFusion?.eulerAngle.startNotificationsAsync { (obj, error) in
            self.getFusionValues(obj: obj!)
            }.success { result in
                print("Successfully subscribed")
            }.failure { error in
                print("Error on subscribe: \(error)")
        }
    }*/
    @IBAction func search(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start{(response, Error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("ERROR")
            }
            else{
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                //SEARCHBAR.TEXT IS THE STRING THE USER ENTERS
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
               // self.labeler.text = annotation.title! + ""
               // self.publicText = annotation.title!
            }
        }
    }
    /**
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        device.removeObserver(self, forKeyPath: "state")
        device.led?.flashColorAsync(UIColor.red, withIntensity: 1.0, numberOfFlashes: 3)
        device.disconnectAsync()
    }
    */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        OperationQueue.main.addOperation {
            switch (self.device.state) {
            case .connected:
                self.deviceStatus.text = "Connected";
                self.device.sensorFusion?.mode = MBLSensorFusionMode.imuPlus
            case .connecting:
                self.deviceStatus.text = "Connecting";
            case .disconnected:
                self.deviceStatus.text = "Disconnected";
            case .disconnecting:
                self.deviceStatus.text = "Disconnecting";
            case .discovery:
                self.deviceStatus.text = "Discovery";
            }
        }
    }
    
    /**
    func getFusionValues(obj: MBLEulerAngleData){
        
        let xS =  String(format: "%.02f", (obj.p))
        let yS =  String(format: "%.02f", (obj.y))
        let zS =  String(format: "%.02f", (obj.r))
    
        let x = radians((obj.p * -1) + 90)
        let y = radians(abs(365 - obj.y))
        let z = radians(obj.r)
        let theAngularOrientation = abs(Float(365 - obj.y))
        //headView.setPointerPosition(w: 0.0, x : x, y: y, z: z)
        //playSoundsController.updateAngularOrientation(abs(Float(365 - obj.y)))
        //print(x)
       // print(y)
       // print(z)
            self.valuesDelegate?.sendXYZHeadPosition(value1: x, value2: y, value3: z, value4: theAngularOrientation)
        
        // Send OSC here
    }
    */
    func radians(_ degree: Double) -> Double {
        return ( PI/180 * degree)
    }
    func degrees(_ radian: Double) -> Double {
        return (180 * radian / PI)
    }
    
    /**
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
    /**
    func loadSounds(){
        var soundArray : [String] = []
        for index in 0...3{
            soundArray.append(String(index) + ".wav")
        }
        playSoundsController = PlaySoundsController(file: soundArray)
        
        playSoundsController.updatePosition(index: 0, position: AVAudio3DPoint(x: 0, y: 0, z: -15))
        playSoundsController.updatePosition(index: 1, position: AVAudio3DPoint(x: 7.5, y: 10, z: 7.5 * sqrt(2.0)))
        playSoundsController.updatePosition(index: 2, position: AVAudio3DPoint(x: 0, y: -2, z: 0))
        playSoundsController.updatePosition(index: 3, position: AVAudio3DPoint(x: -100, y: 10, z: -5))
        
        for sounds in soundArray.enumerated(){
            // skip seagguls
            if sounds.offset != 3 {
                playSoundsController.play(index: sounds.offset)
            }
        }
    
    }
    */
    /**
    @IBAction func seagulls(_ sender: UIButton) {
        timer = Timer()
        //startTime = TimeInterval()
        let aSelector : Selector = #selector(self.moveSoundsLinearPath)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector,     userInfo: nil, repeats: true)
        //startTime = Date.timeIntervalSinceReferenceDate
        //play seagulls here
        playSoundsController.play(index: 3)
    }
    
    func moveSoundsLinearPath(){
        
        playSoundsController.updatePosition(index: 3, position: AVAudio3DPoint(x: seagullX, y: seagullY, z: seagullZ))
        seagullX += 0.1
        if seagullX > 100.0 {
            playSoundsController.stop(index: 3)
            stopTimer()
            seagullX = -100
        }
    }
 
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }*/
}
