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
// MARK: - TableView Methods

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath)
        
        // pull out the corresponding date and format it neatly
        let date = dates[indexPath.row]
        cell.textLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .short)
        
        // add a checkmark if we voted for this date
        if ourVotes[indexPath.row] == 1 {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        // add a vote count if other people voted for this date
        if allVotes[indexPath.row] > 0 {
            cell.detailTextLabel?.text = "Votes: \(allVotes[indexPath.row])"
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                ourVotes[indexPath.row] = 0
            } else {
                cell.accessoryType = .checkmark
                ourVotes[indexPath.row] = 1
            }
            
        }
    }
}
