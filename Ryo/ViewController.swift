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

		let backgroundImage = UIImageView(image: UIImage(named: "bg.jpg")!)
		backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
		backgroundImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
		self.view.addSubview(backgroundImage)

		// let path = NSBundle.mainBundle().pathForResource("fan", ofType: "gif")!
		// let url = NSURL(fileURLWithPath: path)!
		// let animatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfURL: url))

		// backgroundAnimationImage.animatedImage = animatedImage
		// backgroundAnimationImage.frame = CGRectMake(0,0,290,580)
		// backgroundAnimationImage.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 240)
		// self.view.addSubview(backgroundAnimationImage)

		let fanBack = UIImageView(image: UIImage(named: "fan_back.png")!)
		fanBack.frame = CGRectMake(0, 0, 290, 580)
		fanBack.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 240)
		let fanFan = UIImageView(image: UIImage(named: "fan_fan.png")!)
		fanFan.frame = CGRectMake(0, 0, 212, 212)
		fanFan.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2 - 52)

		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
		rotationAnimation.toValue = (M_PI / 180) * 360
		rotationAnimation.duration = 0.2
		rotationAnimation.repeatCount = HUGE
		fanFan.layer.addAnimation(rotationAnimation, forKey: "rotateAnimation")

		let fanFront = UIImageView(image: UIImage(named: "fan_front.png")!)
		fanFront.frame = CGRectMake(0, 0, 290, 580)
		fanFront.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 240)
		self.view.addSubview(fanBack)
		self.view.addSubview(fanFan)
		self.view.addSubview(fanFront)


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
