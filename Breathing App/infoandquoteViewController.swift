//
//  quoteselectorTableViewController.swift
//  Breathing App
//
//  Created by Salamanca on 12/11/20.
//

import UIKit

class InfoTableViewController: UITableViewCell {
    @IBOutlet weak var infooutlet: UITextView!
    
}

class infoandquoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var infoandquote: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 600
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infotableviewcell") as! InfoTableViewController
        
                return cell
    }
}

