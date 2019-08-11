//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Ender Güzel on 2.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordOrStopButton: UIButton!
    var notRecording: Bool = true
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @IBAction func recordOrStopPressed(_ sender: UIButton) {
        setButtonStatus()
    }
    
    func setButtonStatus() {
        if notRecording {
            recordOrStopButton.setImage(UIImage(named: "Stop"), for: .normal)
            recordAudio()
            animateButton()
        } else {
            recordOrStopButton.setImage(UIImage(named: "Record"), for: .normal)
            stopRecording()
            recordOrStopButton.layer.removeAllAnimations()
        }
        notRecording = !notRecording
    }
    
    func recordAudio() {
        // MARK: to save an audio file before manipulation, we need a directory.
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let filePath = URL(string: (dirPath + "/" + recordingName))
        
        // MARK: to use recording hardware, an instance of AudioSession should be created.
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        // MARK: to start the recording, the app should be delegated
        do {
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
        } catch {
            print("Creating an Audio Recorder failed.")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Stoping the AudioSession failed.")
        }
    }
    
    // MARK: This will be automatically triggered when the audio recording finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "playSounds", sender: audioRecorder.url)
        } else {
            print("Recording audio failed.")
        }
    }
    
    // MARK: Sending the recorded Audio's URL to PlaySoundsVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSounds" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: Pulse Animation
    func animateButton() {
        recordOrStopButton.isUserInteractionEnabled = true
        
        let pulseAnimation = CASpringAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.6
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.12
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        pulseAnimation.initialVelocity = 0.8
        pulseAnimation.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.7
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulseAnimation]
        
        recordOrStopButton.layer.add(animationGroup, forKey: "pulse")
    }
    
}

