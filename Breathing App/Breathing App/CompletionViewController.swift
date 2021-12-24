//
//  CompletionViewController.swift
//  Breathing App
//
//  Created by Kevin Salamanca
//

import UIKit
import CoreData

class CompletionViewController: UIViewController {

    var itemsNamecompletionpage : [NSManagedObject] = []
    var itemsNamecompletionpagetime : [NSManagedObject] = []
    var timetransferedagain: Int = 0
    var timecollected: Int = 0
    var todaysdatevarcompletion: String = " "
    var savehelpervar2: Int = 0
    var timelocation: Int = 0
    var completedtimetoday: Int = 0
    let formatter1 = DateFormatter()
    
    
    @IBOutlet weak var lblcompleted: UILabel!
    @IBOutlet weak var minutelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todaysdatevarcompletion = todaysDateAsString()
        completedtimetoday = timetransferedagain
        startData()
    }
    
    //MARK: - GETS TODAYS DATE
    func todaysDateAsString() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return (formatter.string(from: today))
    }
    
    //MARK: - STARTS DATA COLLECTION
    func startData(){
        fetchcoredatehelper()
    }
    
    //MARK: - HELPER FUNC FOR FECTCHES FROM COREDATA
    func fetchcoredatehelper(){
        DispatchQueue.main.async {
                self.fetchcoredata()
        }
    }
    
    //MARK: - HELPER FUNC FOR SAVES TO COREDATA
    func savecoredatehelper(savehelpervar:Int){
            savehelpervar2 = savehelpervar
            if savehelpervar2 == 1 {
                minutelabel.text = "Minute"
            }
            else{
                minutelabel.text = "Minutes"
            }
            lblcompleted!.text = String(savehelpervar2)
            DispatchQueue.main.async {
                self.saveLoginData()
            }
        }
    
    // MARK: - FECTH FROM CORE DATA
    func fetchcoredata(){
    let appD = UIApplication.shared.delegate as! AppDelegate
    let context = appD.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppBreathingData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateappisopened", ascending: true)]
        do {
            itemsNamecompletionpage = try context.fetch(fetchRequest)
            var counter: Int = 0
            var hitcounter: Int = 0
            for item in itemsNamecompletionpage {
                let coredatadate = item.value(forKey: "dateappisopened")
                if todaysdatevarcompletion == coredatadate as? String {
                    timelocation = counter
                    hitcounter+=1
                    let fetchRequesttime = NSFetchRequest<NSManagedObject>(entityName: "AppBreathingData")
                    fetchRequesttime.sortDescriptors = [NSSortDescriptor(key: "timecompletedpd", ascending: true)]
                    do {
                        itemsNamecompletionpagetime = try context.fetch(fetchRequesttime)
                        var counter1: Int = 0
                        for item in itemsNamecompletionpagetime {
                            let coredatatime = item.value(forKey: "timecompletedpd")
                            if timelocation == counter1 {
                                timecollected = coredatatime as? Int ?? 0
                                self.savecoredatehelper(savehelpervar: completedtimetoday + timecollected)
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

    // MARK: - SAVE TO CORE DATA
    func savecoredata(){
        let appD = UIApplication.shared.delegate as! AppDelegate
        let context = appD.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AppBreathingData", in : context)!
        let date = NSManagedObject(entity: entity, insertInto: context)
        date.setValue(completedtimetoday, forKey: "timecompletedpd")
        do {
            try context.save()
        }
        catch {
            print("Error Saving Quote to quoteoftheday")
        }
    }
    
    // MARK: - UPDATING TIME TO COREDATA
    func saveLoginData() {
        let appD = UIApplication.shared.delegate as! AppDelegate
        let context = appD.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppBreathingData")
        fetchRequest.predicate = NSPredicate(format: "dateappisopened == %@", todaysdatevarcompletion)
        do {
            let test = try context.fetch(fetchRequest)
            if test.count == 1 {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(savehelpervar2, forKey: "timecompletedpd")
                appD.saveContext()
            }
        }catch{
            print("Error updating time correctly")
        }
    }
}
