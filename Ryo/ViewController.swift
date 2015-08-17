//
//  ViewController.swift
//  Ryo
//
//  Created by 駒田悠 on 2015/08/16.
//  Copyright (c) 2015年 Butanosuke. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    var engine = AVAudioEngine()
    var audioFilePlayer: AVAudioPlayerNode!
    let backgroundAnimationImage = FLAnimatedImageView()
    var audioFile: AVAudioFile!

	override func viewDidLoad() {
        
        audioFile = AVAudioFile(forReading: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("semi", ofType: "mp3")!), error: nil)
        audioFilePlayer = AVAudioPlayerNode()
        
        
        //effectNodeの用意
        var reverb = AVAudioUnitReverb()
        var distortion = AVAudioUnitDistortion()
        var eq = AVAudioUnitEQ()
        var input = engine.inputNode
        var output = engine.mainMixerNode
        var format = input.inputFormatForBus(0)
        var error:NSError?
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let path = NSBundle.mainBundle().pathForResource("fan", ofType: "gif")!
        let url = NSURL(fileURLWithPath: path)!
        let animatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfURL: url))
        
        backgroundAnimationImage.animatedImage = animatedImage
        backgroundAnimationImage.frame = view.bounds
        view.insertSubview(backgroundAnimationImage, atIndex: 0)
        
        //reverbの設定
        reverb.loadFactoryPreset(.SmallRoom)
        reverb.wetDryMix = 10
        
        //distortionの設定
        distortion.preGain = 0
        distortion.wetDryMix = 60
        
        //eqの設定
        eq.globalGain = 20
        
        //engineにdelayとreverbを追加
        engine.attachNode(reverb)
        engine.attachNode(distortion)
        engine.attachNode(eq)
        engine.attachNode(audioFilePlayer)
        
        engine.connect(input, to: reverb, format: format)
        engine.connect(reverb, to: distortion, format: format)
        engine.connect(distortion, to: eq, format: format)
        engine.connect(eq, to: output, format: format)
        engine.connect(audioFilePlayer, to: engine.mainMixerNode, format: audioFile.processingFormat)
        
        let formata = audioFile.processingFormat
        let lengtha = AVAudioFrameCount(audioFile.length)
        let buffera = AVAudioPCMBuffer(PCMFormat: formata, frameCapacity: lengtha)
        audioFile.readIntoBuffer(buffera, error: nil)
        
        // engineを実行
        engine.startAndReturnError(nil)
        
        audioFilePlayer.scheduleBuffer(buffera, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops) { () -> Void in
            
        }
        audioFilePlayer.play()
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
