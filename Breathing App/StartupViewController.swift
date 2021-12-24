//
//  StartupViewController.swift
//  Breathing App
//
//  Created by Kevin Salamanca
//

import UIKit
import CoreData

class StartupViewController: UIViewController {
    
    var itemsName : [NSManagedObject] = []
    var strquote: String = " "
    var savedstring: String = " "
    var transferringdata: String = " "
    var quotefromfunc: String = " "
    var quoteofthedayvar: String = " "
    var todaysdatevar: String = " "
    var quoteURL: String = " "

    @IBOutlet weak var quoteview: UITextView!
    @IBOutlet weak var todaysdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startData()
        gettingtodaysquote()
        todaysdatevar = todaysDateAsString()
        todaysdate.text = todaysdatevar
    }
    
    //MARK: - GETS TODAY DATES
    func todaysDateAsString() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return (formatter.string(from: today))
    }
    
    //MARK: - GETS TODAY DATES
    func gettingtodaysquote(){
        quoteURL = "https://quotes.rest/qod.json?category=inspire"
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
    func savecoredatehelper(savehelpervar:String){
        quoteofthedayvar = savehelpervar
        DispatchQueue.main.async {
            self.savecoredata()
        }
    }
    
    // MARK: - API CALL AND PARSING
    func setupQuote(_ completion: @escaping (String) -> ()){
        
        // CALLING QUOTE REST API THAT CAN BE USED AT THE STARTUP PAGE AND FOR THE HISTORY.
        guard let url = URL(string: quoteURL) else {
            return print("Error setting URL")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {(data, reponse, error) in
            do {
        
                // PARSING THE JSON RESULT FROM THE API
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    guard let quotes = (jsonResult["contents"] as? [String: Any])?["quotes"] as? [Any],
                        let firstQuote = quotes[0] as? [String: Any],
                        let quoteText = firstQuote["quote"] as? String,
                        let quoteAuthor = firstQuote["author"] as? String else { return
                    }

                    // OUTPUTTING THE QUOTE
                    DispatchQueue.main.async {
                        self.strquote = "\(quoteText)\n\n- \(quoteAuthor)"
                        self.quoteview!.text = self.strquote
                        self.quoteview.centerVerticalText()
                        completion(self.strquote)
                    }
                }
                else{
                    print("Parsing from API")
                }
            } catch{
                print("Error calling API")
            }
        })
        task.resume()
    }
    
    // MARK: - SAVE TO CORE DATA
    func savecoredata(){
        let appD = UIApplication.shared.delegate as! AppDelegate
        let context = appD.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AppBreathingData", in : context)!
        let date = NSManagedObject(entity: entity, insertInto: context)
        date.setValue(quoteofthedayvar, forKey: "quoteoftheday")
        do {
            try context.save()
        }
        catch {
            print("Error Saving Quote to quoteoftheday")
        }
        date.setValue(todaysdatevar, forKey: "dateappisopened")
        do {
            try context.save()
        }
        catch {
            print("Error Saving Date to dateappisopened")
        }
    }
    
    // MARK: - FECTH FROM CORE DATA
    func fetchcoredata(){
    let appD = UIApplication.shared.delegate as! AppDelegate
    let context = appD.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppBreathingData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateappisopened", ascending: true)]
        do {
            itemsName = try context.fetch(fetchRequest)
            var counter: Int = 0
            var hitcounter: Int = 0
            for item in itemsName {
                let coredatadate = item.value(forKey: "dateappisopened")
                if todaysdatevar == coredatadate as? String {
                    counter+=1
                    hitcounter+=1
                }
                else{
                    counter+=1
                }
             }
            if hitcounter == 0{
                setupQuote { (string) in
                    self.quotefromfunc = self.strquote
                    self.savecoredatehelper(savehelpervar: self.quotefromfunc)
                }
            }
            else {
                setupQuote { (string) in
                    self.quotefromfunc = self.strquote
                }
            }
        }catch {
            print("Error from Core Data")
        }
    }
}

// MARK: - UITextView extension TO CENTER TEXTVIEW
extension UITextView {

    func centerVerticalText() {
        self.textAlignment = .center
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let calculate = (bounds.size.height - size.height * zoomScale) / 2
        let offset = max(1, calculate)
        contentOffset.y = -offset
    }
}
