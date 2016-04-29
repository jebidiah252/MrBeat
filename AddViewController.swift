//
//  AddViewController.swift
//  HW04
//
//  Created by Student User on 2/19/16.
//  Copyright © 2016 usu. All rights reserved.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var myTextField: UITextField!
    
    @IBOutlet weak var accentSwitch: UISwitch!
    @IBOutlet weak var quarterSwitch: UISwitch!
    @IBOutlet weak var eighthSwitch: UISwitch!
    @IBOutlet weak var sixteenthSwitch: UISwitch!
    @IBOutlet weak var tripletSwitch: UISwitch!
    @IBOutlet weak var bpbLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    
    var bpm = 120
    var bpb = 4
    
    var accentOn = true
    var quarterOn = false
    var eighthOn = false
    var sixteenthOn = false
    var tripletOn = false
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bpmLabel.text = String(bpm)
        bpbLabel.text = String(bpb)
    }
    
    @IBAction func incrementBPB(sender: AnyObject) {
        bpb += 1
        bpbLabel.text = String(bpb)
    }
    @IBAction func incrementBPM(sender: AnyObject) {
        bpm += 1
        bpmLabel.text = String(bpm)
    }
    @IBAction func decrementBPB(sender: AnyObject) {
        bpb -= 1
        bpbLabel.text = String(bpb)
    }
    @IBAction func decrementBPM(sender: AnyObject) {
        bpm -= 1
        bpmLabel.text = String(bpm)
    }
    
    @IBAction func accentChanged(sender: AnyObject) {
        if accentSwitch.on{
            accentOn = true
        }else{
            accentOn = false
        }
    }
    @IBAction func quarterChanged(sender: AnyObject) {
        if quarterSwitch.on{
            quarterOn = true
        }else{
            quarterOn = false
        }
    }
    @IBAction func eighthChanged(sender: AnyObject) {
        if eighthSwitch.on{
            
            if tripletSwitch.on{
                tripletSwitch.setOn(false, animated: true)
                tripletOn = false
            }
            
            eighthOn = true
        }else{
            eighthOn = false
        }
    }
    @IBAction func sixteenthChanged(sender: AnyObject) {
        if sixteenthSwitch.on{
            
            if tripletSwitch.on{
                tripletSwitch.setOn(false, animated: true)
                tripletOn = false
            }
            
            sixteenthOn = true
        }else{
            sixteenthOn = false
        }
    }
    @IBAction func tripletChanged(sender: AnyObject) {
        if tripletSwitch.on{
            
            if eighthSwitch.on{
                eighthSwitch.setOn(false, animated: true)
                eighthOn = false
            }
            
            if sixteenthSwitch.on{
                sixteenthSwitch.setOn(false, animated: true)
                sixteenthOn = false
            }
            
            tripletOn = true
        }else{
            tripletOn = false
        }
    }
}
