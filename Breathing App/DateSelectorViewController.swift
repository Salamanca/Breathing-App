//
//  DateSelectorViewController.swift
//  Breathing App
//
//  Created by Kevin Salamanca
//

import UIKit

class DateSelectorViewController: UIViewController {

    var datebeingsent: String = ""
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerOutlet.setValue(UIColor.white, forKeyPath: "textColor")
        datePickerOutlet.datePickerMode = .countDownTimer
        datePickerOutlet.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }
    
    // MARK: - SELECTING THE DATE
    @IBAction func goactionbutton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let strdate = dateFormatter.string(from: datePickerOutlet.date)
        datebeingsent = strdate
    }
    
    // MARK: - SEND DATE TO QUOTETIMEVIEWCONTROLLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? QuoteTimeViewController
        {
            vc.quotetimetransfer = datebeingsent
        }
    }
}
