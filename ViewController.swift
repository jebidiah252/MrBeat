//
//  ViewController.swift
//  Mr. Beat
//
//  Created by Student User on 4/1/16.
//  Copyright © 2016 Gordon Fjeldsted. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var quarterSwitch: UISwitch!
    @IBOutlet weak var eighthSwitch: UISwitch!
    @IBOutlet weak var sixteenthSwitch: UISwitch!
    @IBOutlet weak var tripletSwitch: UISwitch!
    @IBOutlet weak var bpbLabel: UILabel!
    @IBOutlet weak var accentSwitch: UISwitch!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var measuresLabel: UILabel!
    
    var accentOn = true
    var quarterOn = false
    var eighthOn = false
    var sixteenthOn = false
    var tripletOn = false
    var metronomeOn = false
    var yes = true
    var loop = false
    
    var bpm:Int = 0
    var adjustedBPM:Int = 0
    var eighthAdjust = 1
    var sixteenthAdjust = 1
    var tripletAdjust = 1
    var bpb = 4
    var adjustedBPB = 4
    var sleep = 0.0
    var counter = 0
    var myMeasures = 0
    
    var timer = NSTimer()
    
    var accentSound : AVAudioPlayer?
    var quarterSound : AVAudioPlayer?
    var quarterSound2: AVAudioPlayer?
    var eighthSound : AVAudioPlayer?
    var eighthSound2: AVAudioPlayer?
    var sixteenthSound : AVAudioPlayer?
    var sixteenthSound2 : AVAudioPlayer?
    var tripletSound : AVAudioPlayer?
    var laSound : AVAudioPlayer?
    var leSound : AVAudioPlayer?
    
    @IBOutlet weak var startButton: UIButton!

    @IBAction func accentAction(sender: AnyObject) {
        if accentSwitch.on{
            accentOn = true
        }else{
            accentOn = false
        }
        
        if timer.valid{
            counter = -1
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
    }
    @IBAction func eighthAction(sender: AnyObject) {
        if eighthSwitch.on{
            eighthAdjust = 2
            eighthOn = true
            
            if sixteenthOn{
                sixteenthAdjust = 2
            }
            
            if tripletOn{
                tripletOn = false
                tripletSwitch.setOn(false, animated: true)
                tripletAdjust = 1
            }
            
        }else{
            eighthAdjust = 1
            eighthOn = false
            
            if sixteenthOn{
                sixteenthAdjust = 4
            }
        }
        adjustForSwitches()
        
        if timer.valid{
            counter = -1
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue){
        let sourceVC = sender.sourceViewController as! AddViewController
        if let measures = Int(sourceVC.myTextField.text!){
            if measures == 0{
                loop = false
                return
            }
            myMeasures = measures
            metronomeOn = true
            accentOn = sourceVC.accentOn
            quarterOn = sourceVC.quarterOn
            eighthOn = sourceVC.eighthOn
            sixteenthOn = sourceVC.sixteenthOn
            tripletOn = sourceVC.tripletOn
            
            accentSwitch.on = sourceVC.accentSwitch.on
            quarterSwitch.on = sourceVC.quarterSwitch.on
            eighthSwitch.on = sourceVC.eighthSwitch.on
            sixteenthSwitch.on = sourceVC.sixteenthSwitch.on
            tripletSwitch.on = sourceVC.tripletSwitch.on
            
            bpm = sourceVC.bpm
            bpb = sourceVC.bpb
            
            loop = true
            
            if eighthOn{
                eighthAdjust = 2
            }
            if sixteenthOn{
                if eighthOn{
                    sixteenthAdjust = 2
                }else{
                    sixteenthAdjust = 4
                }
            }
            if tripletOn{
                tripletAdjust = 3
            }
            adjustForSwitches()
            self.view.userInteractionEnabled = false
            counter = -1
            measuresLabel.text = String(myMeasures)
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)

        }
    }

    func setupAudioPlayerWithFile(file: NSString, type: NSString) -> AVAudioPlayer? {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bpmLabel.text = "120"
        bpbLabel.text = "4/4"
        countLabel.text = ""
        measuresLabel.text = ""
        makeBPM()
        
        if let accentSound = self.setupAudioPlayerWithFile("2", type: "wav"){
            self.accentSound = accentSound
        }
        if let quarterSound = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.quarterSound = quarterSound
        }
        if let quarterSound2 = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.quarterSound2 = quarterSound2
        }
        if let eighthSound = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.eighthSound = eighthSound
        }
        if let eighthSound2 = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.eighthSound2 = eighthSound2
        }
        if let sixteenthSound = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.sixteenthSound = sixteenthSound
        }
        if let sixteenthSound2 = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.sixteenthSound2 = sixteenthSound2
        }
        if let tripletSound = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.tripletSound = tripletSound
        }
        if let leSound = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.leSound = leSound
        }
        if let laSound = self.setupAudioPlayerWithFile("1", type: "wav"){
            self.laSound = laSound
        }
    }
    
    @IBAction func quarterChanged(sender: AnyObject) {
        if quarterSwitch.on{
            quarterOn = true
        }else{
            quarterOn = false
        }
        adjustForSwitches()
        
        if timer.valid{
            counter = -1
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
    }
    @IBAction func incrementBPB(sender: AnyObject) {
        bpb += 1
        adjustedBPB += 1
        adjustForSwitches()
        
        if timer.valid{
            counter = -1
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
    }
    
    @IBAction func decrementBPB(sender: AnyObject) {
        bpb -= 1
        adjustedBPB -= 1
        adjustForSwitches()
        
        if timer.valid{
            counter = -1
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
    }
    
    @IBAction func tripletAction(sender: AnyObject) {
        if tripletSwitch.on{
            if eighthOn{
                eighthOn = false
                eighthSwitch.setOn(false, animated: true)
                eighthAdjust = 1
            }
        
            if sixteenthOn{
                sixteenthOn = false
                sixteenthSwitch.setOn(false, animated: true)
                sixteenthAdjust = 1
            }
            
            tripletOn = true
            tripletAdjust = 3
        }else{
            tripletOn = false
            tripletAdjust = 1
        }
        adjustForSwitches()
        
        if timer.valid{
            counter = -1
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
    }
    @IBAction func sixteenthAction(sender: AnyObject) {
        
        
        if sixteenthSwitch.on{
            if eighthOn == true{
                sixteenthAdjust = 2
            }else{
                sixteenthAdjust = 4
            }
            
            if tripletOn{
                tripletOn = false
                tripletSwitch.setOn(false, animated: true)
                tripletAdjust = 1
            }
            sixteenthOn = true
        }else{
            sixteenthAdjust = 1
            sixteenthOn = false
        }
        adjustForSwitches()
        
        if timer.valid{
            counter = -1
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
    }
    
    @IBAction func incrementBPM(sender: AnyObject) {
        bpm += 1
        adjustedBPM += 1
        adjustForSwitches()
        sleep = 60 / Double(adjustedBPM)
    }
    
    @IBAction func decrementBPM(sender: AnyObject) {
        bpm -= 1
        adjustedBPM -= 1
        adjustForSwitches()
        sleep = 60 / Double(adjustedBPM)
    }
    
    @IBAction func startMetronome(sender: AnyObject) {
        metronomeOn = !metronomeOn
        adjustForSwitches()
        sleep = (60.0 / Double(adjustedBPM))
        timer.invalidate()
        if(metronomeOn){
            counter = -1
            timer = NSTimer.scheduledTimerWithTimeInterval(sleep, target: self, selector: "startThat", userInfo: nil, repeats: true)
            startButton.setTitle("Stop", forState: .Normal)
        }else{
            timer.invalidate()
            startButton.setTitle("Start", forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startThat(){
        counter += 1
        if (counter % adjustedBPB > 0){
            
            if sixteenthOn{
                if(counter % 4 == 0){
                    if quarterOn{
                        countLabel.text = String((counter / 4) + 1)
                        if yes{
                            quarterSound?.play()
                        }else{
                            quarterSound2?.play()
                        }
                    }
                }
                else if(counter % 2 == 0){
                    if eighthOn{
                        countLabel.text = "&"
                        if yes{
                            eighthSound?.play()
                        }else{
                            eighthSound2?.play()
                        }
                    }
                }else if(counter % 2 == 1){
                    if yes{
                        countLabel.text = "e"
                        sixteenthSound?.play()
                        
                    }else{
                        countLabel.text = "a"
                        sixteenthSound2?.play()
                    }
                    yes = !yes
                }
            }else if eighthOn{
                if(counter % 2 == 0){
                    if quarterOn{
                        countLabel.text = String((counter / 2) + 1)
                        if yes{
                            quarterSound?.play()
                        }else{
                            quarterSound2?.play()
                        }
                    }
                }else if(counter % 2 == 1){
                    countLabel.text = "&"
                    if yes{
                        eighthSound?.play()
                    }else{
                        eighthSound2?.play()
                    }
                    yes = !yes
                }
            }else if tripletOn{
                if(counter % 3 == 0){
                    if quarterOn{
                        countLabel.text = String(counter / 3 + 1)
                        if yes{
                            quarterSound?.play()
                        }else{
                            quarterSound2?.play()
                        }
                    }
                }else if(counter % 3 == 1){
                    laSound?.play()
                    countLabel.text = "la"
                }else if(counter % 3 == 2){
                    leSound?.play()
                    countLabel.text = "le"
                }
            }else if quarterOn{
                countLabel.text = String(counter + 1)
                if yes{
                    quarterSound?.play()
                }else{
                    quarterSound?.play()
                }
            }
            
        }else{
            if accentOn{
                accentSound?.play()
            }else{
                quarterSound?.play()
            }
            counter = 0
            countLabel.text = "1"
            
            if loop{
                myMeasures -= 1
            }
            
            
        }
        sleep = (60.0 / Double(adjustedBPM))
        timer.fireDate = timer.fireDate.dateByAddingTimeInterval(sleep)
        if myMeasures < 0 && loop{
            loop = false
            measuresLabel.text = ""
            self.view.userInteractionEnabled = true
            metronomeOn = false
            timer.invalidate()
        }else{
            if myMeasures < 0{
                myMeasures = 0
            }
            measuresLabel.text = String(myMeasures)
        }
    }
    
    func makeBPM(){
        bpm = Int(bpmLabel.text!)!
        adjustedBPM = bpm
    }
    
    func adjustForSwitches(){
        adjustedBPM = bpm * eighthAdjust * sixteenthAdjust * tripletAdjust
        adjustedBPB = bpb * eighthAdjust * sixteenthAdjust * tripletAdjust
        sleep = (60.0 / Double(adjustedBPM))
        bpmLabel.text = String(bpm)
        bpbLabel.text = String(bpb) + "/4"
    }
}

