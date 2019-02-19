//
//  GameViewController.swift
//  SoundOrbit
//
//  Created by Martin Jaroszewicz on 6/7/16.
//  Copyright (c) 2016 Martin Jaroszewicz. All rights reserved.

import AVFoundation


class PlaySoundsController {
    
    var file : [String]
    
    init(file:[String]) {
        self.file = file
        loadFileIntoBuffer()
    }
    
    private var buffer = AVAudioPCMBuffer()
    private var player = [AVAudioPlayerNode()]
    private var mixer3d = AVAudioEnvironmentNode()
    private var audioFile = AVAudioFile()
    private var engine = AVAudioEngine()
    
    let loop = AVAudioPlayerNodeBufferOptions.loops
    
    private func loadFileIntoBuffer(){
        
        var fileExtensionCount : Int
        var fileExtension : String = ""
        var fileName : String =  ""
        
        var counter = 0
        
        let mixer = engine.mainMixerNode
        engine.attach(mixer3d)
        mixer3d.renderingAlgorithm = AVAudio3DMixingRenderingAlgorithm.sphericalHead
        engine.connect(mixer3d, to: mixer, format: mixer3d.outputFormat(forBus: 0))
        for _ in 0..<file.count {
            player.append(AVAudioPlayerNode())
        }
        for index in file {
            
            fileExtensionCount = 0
            fileExtension = ""
            fileName =  ""
            fileExtensionCount = index.count - 3
            fileExtension = (fileExtension.padding(toLength: 3, withPad: index, startingAt: fileExtensionCount))
            fileName = (fileName.padding(toLength: (fileExtensionCount-1), withPad: index, startingAt: 0))
            print("\(fileName).\(fileExtension)")
            
            guard let filePath = Bundle.main.url(forResource: fileName, withExtension: fileExtension, subdirectory: "Sounds")
           
                else {
                    print("Cannot find file")
                    return
            }
            
            do {
                audioFile = try AVAudioFile(forReading: filePath)
            }
            catch {
                print("Cannot load audiofile!")
            }
            //Second: we need to load the sound into a buffer
            
            buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
            
            do {
                try audioFile.read(into: buffer)
                print("File loaded")
                print(buffer.frameLength)
            }
            catch{
                print("Could not load file into buffer")
            }
            engine.attach(player[counter])
            engine.connect(player[counter], to: mixer3d, format: audioFile.processingFormat)
            //player[counter].renderingAlgorithm = AVAudio3DMixingRenderingAlgorithm(rawValue: 1)!
            player[counter].scheduleBuffer(buffer, at: nil, options: loop, completionHandler: nil)
            counter += 1
        }
        print("Players OK")
        initEngine()
    }
    
    private func initEngine(){
        
        if engine.isRunning{
            engine.stop() }
        else {
            do {
                try engine.start()
            }
            catch {
                print("Cannot initialize engine")
            }
        initPositions()//(mixer3d, playerPosition: player)
        }
    }
    
    func play(index: Int){
        
        player[index].play()
    }
    
    func volume(index: Int, vol: Float){
        
        player[index].volume = vol
    }

    
    func stop(index: Int){
        player[index].stop()
        player[index].scheduleBuffer(buffer, at: nil, options: loop, completionHandler: nil)
    }
    
    private func initPositions(){
        
        mixer3d.listenerPosition.x = 0 //center
        mixer3d.listenerPosition.y = 0 //center
        mixer3d.listenerPosition.z = 0 //center

    }
    
    func updatePosition(index: Int, position: AVAudio3DPoint){
        
        player[index].position = position
    }
    
    func updateAngularOrientation(_ degreesYaw: Float, _ rPart: Float, _ pPart: Float){
        mixer3d.listenerAngularOrientation.yaw = degreesYaw
        mixer3d.listenerAngularOrientation.roll = rPart
        mixer3d.listenerAngularOrientation.pitch = pPart
    }
    
    func updateListenerPosition(_ x: Float, _ y: Float, _ z: Float){
        mixer3d.listenerPosition.x = x
        mixer3d.listenerPosition.y = y
        mixer3d.listenerPosition.z = z
    }
    
}


