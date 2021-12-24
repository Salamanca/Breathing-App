//
//  ViewController.swift
//  Breathing App
//
//  Created by Kevin Salamanca
//

import UIKit
import AVFoundation
import CoreHaptics

class BreathingViewController: UIViewController {

    var timeremaining: String = ""
    var timer: Timer?
    var timeTransfered: Int = 0
    var totalTime: Int = 0
    var timecompleted: Int = 0
    var animationTime: Int = 0
    var counterInt: Int  = 0
    var engine: CHHapticEngine?
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var flowermove: UIImageView!
    @IBOutlet weak var lblminutes: UILabel!
    @IBOutlet weak var Startbreathingoutlet: UIButton!
    @IBOutlet weak var minutelabel: UILabel!
    @IBOutlet weak var letsstartbreathing: UILabel!
    
    override func viewDidLoad(){
            super.viewDidLoad()
            timeTransfered = Int(timeremaining) ?? 0
            timecompleted = Int(timeremaining) ?? 0
            if timeTransfered == 1 {
                minutelabel.text = "Minute"
            }
            else{
                minutelabel.text = "Minutes"
            }
            lblTimer.text = self.timeFormatted(self.timeTransfered*60)
        
        }
    
    //MARK: - START TIMER, ANIMATION AND HAPTIC
    @IBAction func trythisout(_ sender: AnyObject) {
        startOtpTimer()
        callhaptic()
        UIView.animate(withDuration: 5, delay: 2.0, options: [.repeat, .autoreverse], animations: {
            let animationToRotate = CGAffineTransform(rotationAngle: 360);
            let animationToScale = CGAffineTransform(scaleX: 0.2, y: 0.2);
            self.flowermove.transform = animationToScale.concatenating(animationToRotate);
        }, completion: nil)
        Startbreathingoutlet.isHidden = true
        lblminutes.isHidden = true
    }
    
    //MARK: - CANCEL ANIMATIONS AND TIME
    @IBAction func cancelbutton(_ sender: Any) {
        timer?.invalidate()
        self.view.layer.removeAllAnimations()
    }
    
    //MARK: - STARTS TIMER
    private func startOtpTimer() {
        self.totalTime = timeTransfered * 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    
    }
    
    //MARK: - STARTS HAPTIC
    func callhaptic(){
        let haptictime = ((timeTransfered * 60) / 15)
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
            
        }
        var events = [CHHapticEvent]()
        for _ in 1...haptictime{
        for i in stride(from: 0, to: 5, by: 0.1) {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(5 - i))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(5 - i))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
                events.append(event)
            }
        }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern")
        }
    }
    
    //MARK: - TRANSFERS TIME COMPLETED TO COMPLETIONVIEWCONTROLLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? CompletionViewController
        {
            vc.timetransferedagain = timeTransfered
        }
    }

    //MARK: - UPDATES THE TIME AND INFO TO THE LABELS
    @objc func updateTimer(){
        lblTimer.text = self.timeFormatted(self.totalTime)
        
        if totalTime != 0 {
            totalTime -= 1
            counterInt += 1
            if counterInt <= 5 {
                letsstartbreathing.text = "Exhale..."
            }
            else if counterInt >= 6 && counterInt <= 10 {
                letsstartbreathing.text = "Inhale..."
            }
            else if counterInt >= 11 && counterInt <= 15 {
                letsstartbreathing.text = "Exhale..."
            }
            else if counterInt >= 16 && counterInt <= 20 {
                letsstartbreathing.text = "Inhale..."
            }
            else{
                letsstartbreathing.text = " "
            }
        }
        else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                self.performSegue(withIdentifier: "CompletionScreen", sender: self)
            }
        }
    }

    //MARK: - FORMATS THE TIME CORRECTLY
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

//MARK: - EXTENSION FOR HAPTIC
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
}
