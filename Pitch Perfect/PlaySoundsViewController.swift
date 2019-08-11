//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ender Güzel on 2.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    enum ButtonType: Int {
        case slow = 0, fast, highPitch, lowPitch, echo, reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
        configureUI(.notPlaying)
    }
    
    // since the aspect fit did not work properly in the storyboard, it is included programatically
    func setupButtons() {
        let buttonArray = [slowButton, fastButton, highPitchButton, lowPitchButton, echoButton, reverbButton]
        let imageDictionary = [slowButton: "Slow", fastButton: "Fast", highPitchButton: "HighPitch", lowPitchButton: "LowPitch", echoButton: "Echo", reverbButton: "Reverb"]
        
        for button in buttonArray {
            button?.imageView?.contentMode = .scaleAspectFit
            button?.setImage(UIImage(named: imageDictionary[button]!), for: .normal)
        }
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!){
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopAudio()
        configureUI(.notPlaying)
    }
    
    @IBAction func recordNewSoundPressed(_ sender: UIButton) {
        stopAudio()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
