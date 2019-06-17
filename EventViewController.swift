//
//  EventViewController.swift
//  TimeShare MessagesExtension
//
//  Created by Frank Bara on 6/16/19.
//  Copyright © 2019 BaraLabs. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    var dates = [Date]()
    var allVotes = [Int]()
    var ourVotes = [Int]()

    @IBOutlet weak var EventTable: UITableView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveSelectedDates(_ sender: Any) {
        
    }
    
    @IBAction func addDate(_ sender: Any) {
        // add to the arrays.
        dates.append(DatePicker.date)
        allVotes.append(0)
        // automatically vote for our own date
        ourVotes.append(1)
        
        // insert a row in the table using animation.
        let newIndexPath = IndexPath(row: dates.count - 1, section: 0)
        EventTable.insertRows(at: [newIndexPath], with: .automatic)
        
        // scroll the new row into view.
        EventTable.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        
        // flash the scroll bars so the user knows something has changed.
        EventTable.flashScrollIndicators()

    }


}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath)
        cell.textLabel?.text = "Date goes here"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
