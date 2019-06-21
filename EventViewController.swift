//
//  EventViewController.swift
//  TimeShare MessagesExtension
//
//  Created by Frank Bara on 6/16/19.
//  Copyright © 2019 BaraLabs. All rights reserved.
//

import UIKit
import Messages

class EventViewController: UIViewController {
    
    var dates = [Date]()
    var allVotes = [Int]()
    var ourVotes = [Int]()
    // delegate to pass info back and forth
    weak var delegate: MessagesViewController!

    @IBOutlet weak var EventTable: UITableView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveSelectedDates(_ sender: Any) {
        var finalVotes = [Int]()
        
        for (index, votes) in allVotes.enumerated() {
            finalVotes.append(votes + ourVotes[index])
        }
        
        delegate.createMessage(with: dates, votes: finalVotes)
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
    
    // MARK: - Get Dates & Votes
    
    func load(from message: MSMessage?) {
        // check that everything we need is available
        guard let message = message else { return }
        guard let messageURL = message.url else { return }
        guard let urlComponents = URLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return }
        guard let queryItems = urlComponents.queryItems else { return }
        
        for item in queryItems {
            if item.name .hasPrefix("date-") {
                dates.append(date(from: item.value ?? ""))
            } else if item.name .hasPrefix("vote-") {
                //That means “if the item has a value use it, otherwise use an empty string;
                //then create an integer out of that value, but if that fails use 0.”
                //It’s not pretty, but it would have been a darn sight worse without nil coalescing!
                let voteCount = Int(item.value ?? "") ?? 0
                allVotes.append(voteCount)
                ourVotes.append(0)
            }
        }
    }

    // MARK: - Helper Functions
    
    func date(from string: String)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        
        return dateFormatter.date(from: string) ?? Date()
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
