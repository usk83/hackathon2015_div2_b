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

	var _buttonFlag:Bool! = true
	var avRecorder:AVAudioRecorder?
	var avPlayer:AVAudioPlayer?

	let RecButton = UIButton(frame: CGRectMake(0,0,120,50))
	let PlayButton = UIButton(frame: CGRectMake(0,0,120,50))

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.whiteColor()

		RecButton.backgroundColor = UIColor.redColor();
		RecButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
		RecButton.setTitle("録音", forState: UIControlState.Normal)
		RecButton.layer.masksToBounds = true
		RecButton.layer.cornerRadius = 20.0
		RecButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		RecButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-150)
		RecButton.addTarget(self, action: "onTouch1:", forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(RecButton)

		PlayButton.backgroundColor = UIColor.redColor();
		PlayButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
		PlayButton.setTitle("再生", forState: UIControlState.Normal)
		PlayButton.layer.masksToBounds = true
		PlayButton.layer.cornerRadius = 20.0
		PlayButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		PlayButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
		PlayButton.addTarget(self, action: "play", forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(PlayButton)
	}

	func onTouch1(pSender:UIButton) {
		if(_buttonFlag == true) {
			record()
			RecButton.setTitle("停止", forState: UIControlState.Normal)
		}
		else {
			stop()
			RecButton.setTitle("録音", forState: UIControlState.Normal)
		}
		_buttonFlag = !_buttonFlag
	}

	func stop() {
		avRecorder?.stop()
	}
	func record() {
		let audioSession = AVAudioSession.sharedInstance()
		audioSession.requestRecordPermission { (granted) -> Void in
			if (granted) {
				if audioSession.inputAvailable {
					var error:NSError?
					audioSession.setCategory(AVAudioSessionCategoryRecord, withOptions: AVAudioSessionCategoryOptions.allZeros, error: &error)
					if ((error) != nil) {
						return
					}

					audioSession.setActive(true, error: &error)
					if ((error) != nil) {
						return
					}

					let filePaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
					let documentDir: AnyObject = filePaths[0]
					let path = documentDir.stringByAppendingPathComponent("rec.caf")
					let recordingUrl = NSURL.fileURLWithPath(path)

					self.avRecorder = AVAudioRecorder(URL: recordingUrl, settings: nil, error: &error)
					self.avRecorder?.delegate = self
					if ((error) != nil) {
						return
					}
					self.avRecorder?.record()
				}
			}
		}
	}

	func play() {
		var error:NSError?
		let audioSession = AVAudioSession.sharedInstance()
		audioSession.setCategory(AVAudioSessionCategoryAmbient, withOptions: AVAudioSessionCategoryOptions.allZeros, error: &error)

		let filePaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
		let documentDir: AnyObject = filePaths[0]
		let path = documentDir.stringByAppendingPathComponent("rec.caf")
		let recordingUrl = NSURL.fileURLWithPath(path)

		avPlayer = AVAudioPlayer(contentsOfURL: recordingUrl, error: &error)
		avPlayer?.delegate = self
		avPlayer?.volume = 1.0
		avPlayer?.play()
	}
}
