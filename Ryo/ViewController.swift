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

	let backgroundAnimationImage = FLAnimatedImageView()

	override func viewDidLoad() {

		//effectNodeの用意
		var reverb = AVAudioUnitReverb()
		var distortion = AVAudioUnitDistortion()
		var eq = AVAudioUnitEQ()

		var input = engine.inputNode
		var output = engine.outputNode
		var format = input.inputFormatForBus(0)
		var error:NSError?

		super.viewDidLoad()
		// self.view.backgroundColor = UIColor.blackColor()
		//self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        
        let backgroundImage = UIImageView(image: UIImage(named: "bg.jpg")!)
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(backgroundImage)

		let path = NSBundle.mainBundle().pathForResource("fan", ofType: "gif")!
		let url = NSURL(fileURLWithPath: path)!
		let animatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfURL: url))

		backgroundAnimationImage.animatedImage = animatedImage
//		backgroundAnimationImage.frame = view.bounds
        backgroundAnimationImage.frame = CGRectMake(0,0,130,272)
        backgroundAnimationImage.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 200)

//		view.insertSubview(backgroundAnimationImage, atIndex: 0)
        self.view.addSubview(backgroundAnimationImage)

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

		engine.connect(input, to: reverb, format: format)
		engine.connect(reverb, to: distortion, format: format)
		engine.connect(distortion, to: eq, format: format)
		engine.connect(eq, to: output, format: format)

		// engineを実行
		engine.startAndReturnError(&error)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
