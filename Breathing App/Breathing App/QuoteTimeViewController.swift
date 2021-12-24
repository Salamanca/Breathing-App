//
//  QuoteTimeViewController.swift
//  Breathing App
//
//  Created by Kevin Salamanca
//

import UIKit
import CoreData


class QuoteTimeViewController: UIViewController {
    
    var quotetimepage : [NSManagedObject] = []
    var quotetimepage1 : [NSManagedObject] = []
    var quotetimepage2 : [NSManagedObject] = []
    var quotetimepage3 : [NSManagedObject] = []
    var quotetimetransfer: String = ""
    var quotetimeproperly: String = ""
    var timelocation1: Int = 0
    var timecollected1: Int = 0
    @IBOutlet weak var quotelabel: UITextView!
    @IBOutlet weak var timelabel: UITextView!
    @IBOutlet weak var helperlabel1: UITextView!
    @IBOutlet weak var helperlabel2: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quotetimeproperly = quotetimetransfer
        quotefetch()
        timefetch()
    }

    // MARK: - FECTH QUOTE FROM CORE DATA
    func quotefetch(){
    let appD = UIApplication.shared.delegate as! AppDelegate
    let context = appD.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppBreathingData")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateappisopened", ascending: true)]
        do {
            quotetimepage = try context.fetch(fetchRequest)
            for item in quotetimepage {
                let coredatadate = item.value(forKey: "dateappisopened")
                if quotetimeproperly == coredatadate as? String {
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppBreathingData")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "quoteoftheday", ascending: true)]
                    do {
                        quotetimepage1 = try context.fetch(fetchRequest)
                        for item in quotetimepage1 {
                            let coredatadate = item.value(forKey: "quoteoftheday")
                            quotelabel.text = (coredatadate as? String ?? " ")
                            helperlabel1.text = "Quote For That Day:"
                         }
                    }catch {
                        print("Error from Core Data")
                    }
                }
                else{
                    quotelabel.text = "There is no available quotes or time completed for this date, don't forget to breath everyday!"
                }
             }
        }catch {
            print("Error from Core Data")
        }
    }

    // MARK: - FECTH TIME FROM CORE DATA
    func timefetch(){
    let appD = UIApplication.shared.delegate as! AppDelegate
    let context = appD.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppBreathingData")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateappisopened", ascending: true)]
        do {
            quotetimepage2 = try context.fetch(fetchRequest)
            var counter: Int = 0
            var hitcounter: Int = 0
            for item in quotetimepage2 {
                let coredatadate = item.value(forKey: "dateappisopened")
                if quotetimeproperly == coredatadate as? String {
                    timelocation1 = counter
                    hitcounter+=1
                        let fetchRequesttime = NSFetchRequest<NSManagedObject>(entityName: "AppBreathingData")
                        fetchRequesttime.sortDescriptors = [NSSortDescriptor(key: "timecompletedpd", ascending: true)]
                        do {
                            quotetimepage2 = try context.fetch(fetchRequesttime)
                            var counter1: Int = 0
                            for item in quotetimepage2 {
                                let coredatatime = item.value(forKey: "timecompletedpd")
                                if timelocation1 == counter1 {
                                    timecollected1 = coredatatime as? Int ?? 0
                                    if timecollected1 == 1 {
                                        timelabel.text = String(timecollected1) + " Minute"
                                        helperlabel2.text = "Time Completed:"
                                    }
                                    else{
                                        timelabel.text = String(timecollected1) + " Minutes"
                                        helperlabel2.text = "Time Completed:"
                                    }
                                }
                                else{
                                    counter1 += 1
                                }
                            }
                        }catch {
                            print("Error from Core Data")
                        }
                }
                else{
                    counter+=1
                }
             }
        }catch {
            print("Error from Core Data")
        }
    }
}
