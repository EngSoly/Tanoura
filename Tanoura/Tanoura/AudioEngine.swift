//
//  AudioEngine.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 12/8/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import Foundation
import AVFoundation



class AudioEngine : NSObject {
  
  let internalEngine = AVAudioEngine()
  let audioSession = AVAudioSession.sharedInstance()
  var audioNodes : [AVAudioPlayerNode] = []
  
  class var shared : AudioEngine {
    struct Static {
      static let instance = AudioEngine()
    }
    return Static.instance
  }
  
  override init() { }
  
  func attach (track:Track){
    
    let audioFile = try! AVAudioFile(forReading: URL(fileURLWithPath: track.path))
    let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: UInt32(audioFile.length))
    try! audioFile.read(into: audioFileBuffer)
    
    let audioNode = AVAudioPlayerNode()

    internalEngine.attach(audioNode)
    internalEngine.connect(audioNode, to: internalEngine.mainMixerNode, format: audioFileBuffer.format)
    
    audioNode.scheduleBuffer(audioFileBuffer, at: nil, options:.loops, completionHandler: nil)
    
    audioNodes.append(audioNode)
  }
  
  
  func start(){
    do{
      internalEngine.reset()
      try internalEngine.start()
    }catch{
      print("Can't Start Audio Engine")
    }
    
  }
  
  func stop(){
    internalEngine.stop()
  }
  
  
  
  
  
}
