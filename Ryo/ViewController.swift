//
//  ViewController.swift
//  Ryo
//
//  Created by 駒田悠 on 2015/08/16.
//  Copyright (c) 2015年 Butanosuke. All rights reserved.
//

import UIKit
import AVFoundation

enum Power {
	case low
	case middle
	case high
}

class ViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
		var engine = AVAudioEngine()
		var audioFilePlayer_semi: AVAudioPlayerNode!
		var audioFilePlayer_wind: AVAudioPlayerNode!
		var audioFilePlayer_furin: AVAudioPlayerNode!
		let backgroundAnimationImage = FLAnimatedImageView()
		var audioFile_semi: AVAudioFile!
		var audioFile_wind: AVAudioFile!
		var audioFile_furin: AVAudioFile!

		var power = Power.middle
		let fanSwitch = UIButton(frame: CGRectMake(0,0,50,50))
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
		let fanFan = UIImageView(image: UIImage(named: "fan_fan_.png")!)

		override func viewDidLoad() {
			super.viewDidLoad()

			let backgroundImage = UIImageView(image: UIImage(named: "bg.png")!)
			backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
			backgroundImage.frame = CGRectMake(50, 0, self.view.frame.size.width, self.view.frame.size.height)
			self.view.addSubview(backgroundImage)

			let fanBack = UIImageView(image: UIImage(named: "fan_back_.png")!)
			fanBack.frame = CGRectMake(0, 0, 290, 580)
			fanBack.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 240)

			fanFan.frame = CGRectMake(0, 0, 212, 212)
			fanFan.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2 - 52)
			rotationAnimation.toValue = (M_PI / 180) * 360
			rotationAnimation.duration = 0.2
			rotationAnimation.repeatCount = HUGE
			fanFan.layer.addAnimation(rotationAnimation, forKey: "rotateAnimation")

			let fanFront = UIImageView(image: UIImage(named: "fan_front_.png")!)
			fanFront.frame = CGRectMake(0, 0, 290, 580)
			fanFront.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 240)
			self.view.addSubview(fanBack)
			self.view.addSubview(fanFan)
			self.view.addSubview(fanFront)

			audioFile_semi = AVAudioFile(forReading: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("semi", ofType: "mp3")!), error: nil)
			audioFile_wind = AVAudioFile(forReading: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("senpuki", ofType: "mp3")!), error: nil)
			audioFile_furin = AVAudioFile(forReading: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("furin", ofType: "mp3")!), error: nil)
			audioFilePlayer_semi = AVAudioPlayerNode()
			audioFilePlayer_wind = AVAudioPlayerNode()
			audioFilePlayer_furin = AVAudioPlayerNode()

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
			distortion.wetDryMix = 40

			//eqの設定
			eq.globalGain = 20

			//engineにdelayとreverbを追加
			engine.attachNode(reverb)
			engine.attachNode(distortion)
			engine.attachNode(eq)
			engine.attachNode(audioFilePlayer_semi)
			engine.attachNode(audioFilePlayer_wind)
			engine.attachNode(audioFilePlayer_furin)

			engine.connect(input, to: reverb, format: format)
			engine.connect(reverb, to: distortion, format: format)
			engine.connect(distortion, to: eq, format: format)
			engine.connect(eq, to: output, format: format)
			engine.connect(audioFilePlayer_semi, to: engine.mainMixerNode, format: audioFile_semi.processingFormat)
			engine.connect(audioFilePlayer_wind, to: engine.mainMixerNode, format: audioFile_wind.processingFormat)
			engine.connect(audioFilePlayer_furin, to: engine.mainMixerNode, format: audioFile_furin.processingFormat)

			// engineを実行
			engine.startAndReturnError(nil)

			let formata_semi = audioFile_semi.processingFormat
			let lengtha_semi = AVAudioFrameCount(audioFile_semi.length)
			let buffera_semi = AVAudioPCMBuffer(PCMFormat: formata_semi, frameCapacity: lengtha_semi)
			audioFile_semi.readIntoBuffer(buffera_semi, error: nil)

			audioFilePlayer_semi.scheduleBuffer(buffera_semi, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops) { () -> Void in

			}
			audioFilePlayer_semi.play()

			let formata_wind = audioFile_wind.processingFormat
			let lengtha_wind = AVAudioFrameCount(audioFile_wind.length)
			let buffera_wind = AVAudioPCMBuffer(PCMFormat: formata_wind, frameCapacity: lengtha_wind)
			audioFile_wind.readIntoBuffer(buffera_wind, error: nil)

			audioFilePlayer_wind.scheduleBuffer(buffera_wind, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops) { () -> Void in

			}
			audioFilePlayer_wind.play()

			let formata_furin = audioFile_furin.processingFormat
			let lengtha_furin = AVAudioFrameCount(audioFile_furin.length)
			let buffera_furin = AVAudioPCMBuffer(PCMFormat: formata_furin, frameCapacity: lengtha_furin)
			audioFile_furin.readIntoBuffer(buffera_furin, error: nil)

			audioFilePlayer_furin.scheduleBuffer(buffera_furin, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops) { () -> Void in

			}
			audioFilePlayer_furin.play()

			fanSwitch.layer.masksToBounds = true
			fanSwitch.layer.cornerRadius = 25.0
			fanSwitch.layer.position = CGPoint(x: self.view.bounds.width / 2, y:self.view.bounds.height-20)
			fanSwitch.addTarget(self, action: "clickSwitch:", forControlEvents: .TouchUpInside)
			self.view.addSubview(fanSwitch)
		}

	func clickSwitch(sender: UIButton) {
		if (power == Power.high) {
			power = Power.low
			println("low")
			rotationAnimation.duration = 0.5
			fanFan.layer.addAnimation(rotationAnimation, forKey: "rotateAnimation")
			audioFilePlayer_wind.volume = 0.1
		}
		else if (power == Power.middle) {
			power = Power.high
			println("high")
			rotationAnimation.duration = 0.1
			fanFan.layer.addAnimation(rotationAnimation, forKey: "rotateAnimation")

            audioFilePlayer_wind.volume = 2
		}
		else if (power == Power.low) {
			power = Power.middle
			println("middle")
			rotationAnimation.duration = 0.3
			fanFan.layer.addAnimation(rotationAnimation, forKey: "rotateAnimation")

            audioFilePlayer_wind.volume = 1
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
