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
    
    var accentOn = true
    var quarterOn = true
    var eighthOn = false
    var sixteenthOn = false
    var tripletOn = false
    var metronomeOn = false
    
    var bpm:Int = 0
    let bpb = 4
    var sleep = 0.0
    var counter = 0
    
    var timer = NSTimer()
    
    var accentSound : AVAudioPlayer?
    var quarterSound : AVAudioPlayer?
    
    @IBOutlet weak var startButton: UIButton!

    

    func setupAudioPlaerWithFile(file: NSString, type: NSString) -> AVAudioPlayer? {
        
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
        makeBPM()
        
        if let accentSound = self.setupAudioPlaerWithFile("2", type: "wav"){
            self.accentSound = accentSound
        }
        if let quarterSound = self.setupAudioPlaerWithFile("1", type: "wav"){
            self.quarterSound = quarterSound
        }
    }
    @IBOutlet weak var accentSwitchMe: UISwitch!
    
    @IBOutlet weak var QuarterSwitchMe: UISwitch!
    
    @IBOutlet weak var EighthSwitchMe: UISwitch!
    
    @IBOutlet weak var TripletSwitchMe: UISwitch!
    
    @IBOutlet weak var SixteenthSwitchMe: UISwitch!
    
    @IBAction func switchAccentOnOff(sender: AnyObject) {
        if accentSwitchMe.on{
            print("You Made it")
            accentSwitchMe.setOn(false, animated: true)
        }else{
            print("You done goofed")
            accentSwitchMe.setOn(true, animated: true)
        }
    }
    
    @IBAction func accentSwitch(sender: AnyObject) {
    }

    @IBAction func quarterSwitch(sender: AnyObject) {
    }
    
    @IBAction func eighthSwitch(sender: AnyObject) {
    }
    
    @IBAction func sixteenthSwitch(sender: AnyObject) {
    }
    
    @IBAction func tripletSwitch(sender: AnyObject) {
    }
    
    @IBAction func incrementBPM(sender: AnyObject) {
        bpm += 1
        bpmLabel.text = String(bpm)
        sleep = 60 / Double(bpm)
    }
    @IBAction func decrementBPM(sender: AnyObject) {
        bpm -= 1
        bpmLabel.text = String(bpm)
        sleep = 60 / Double(bpm)
    }
    @IBAction func startMetronome(sender: AnyObject) {
        metronomeOn = !metronomeOn
        sleep = (60.0 / Double(bpm))
        
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
        if (counter % bpb > 0){
            print("tick")
            quarterSound?.play()
        }else{
            print("TICK")
            accentSound?.play()
        }
        timer.fireDate = timer.fireDate.dateByAddingTimeInterval(sleep)
    }
    func makeBPM(){
        bpm = Int(bpmLabel.text!)!
    }
}

