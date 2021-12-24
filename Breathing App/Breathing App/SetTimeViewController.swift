//
//  SetTimeViewController.swift
//  Breathing App
//
//  Created by Kevin Salamanca
//

import UIKit

class SetTimeViewController: UIViewController {
 
    var timeselected: String = "0"
    
    @IBOutlet weak var LabelStepper: UILabel!
    @IBOutlet weak var StepperOutlet: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StepperOutlet.wraps = true
        StepperOutlet.autorepeat = true
        StepperOutlet.maximumValue = 60
    }
    
    //MARK: - COLLECTING DATA FROM STEPPER
    @IBAction func stepper(_ sender: UIStepper) {
        LabelStepper.text = Int(sender.value).description
        timeselected = Int(sender.value).description
    }
    
    //MARK: - CHECKS FOR MINUTES BREATHING > 0
    @IBAction func StartPossibility(_ sender: Any) {
        if timeselected == "0" {
            self.performSegue(withIdentifier: "didnotselecttime", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "didselecttime", sender: self)
        }
    }

    //MARK: - TRANSFER MINUTES TO BREATHINGVIEWCONTROLLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc = segue.destination as? BreathingViewController
        {
            vc.timeremaining = timeselected
        }
    }
}
