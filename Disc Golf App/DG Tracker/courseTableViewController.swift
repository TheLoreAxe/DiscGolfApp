//
//  courseTableViewController.swift
//  DG Tracker
//
//  Created by Matthew Steffan on 11/27/21.
//

import UIKit

class courseTableViewController: UITableViewController {
    
    // Declares course array
    var courses:[Course] = []
    
    // Declares database object
    var db:databaseManager = databaseManager()

    // Every time it loads it will refresh the courses
    override func viewWillAppear(_ animated: Bool) {
        overrideUserInterfaceStyle = .dark
        courses = db.get_courses()
        tableView.reloadData()
    }
    
    // Creates the slider to delete the row
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath.row)")
            self.db.delete_course(courseID: self.courses[indexPath.row].course_ID!)
            self.courses = self.db.get_courses()
            self.tableView.reloadData()
            
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}

extension courseTableViewController {
    
    // Cell identifier
    static let cellIdentifier = "ListCell"

    // Tells how many cells to make
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    // Creates the table view and fills it with cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath) as? CourseCell else {
            print("it broke")
            fatalError("Unable to dequeue ReminderCell")
        }
        
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        cell.holesLabel.text = String(course.hole_count!)
        return cell
    }
}
