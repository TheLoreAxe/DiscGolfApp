//
//  editCoursesViewController.swift
//  DG Tracker
//
//  Created by Matthew Steffan on 11/22/21.
//

import UIKit

class editCoursesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!

    let cellReuseIdentifier = "cell"
    
    var db:databaseManager = databaseManager()
    var courses:[Course] = []

    override func viewDidLoad() {
    super.viewDidLoad()
        courses = db.get_courses()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //courseTable.delegate   = self
        table.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = (courses[indexPath.row].name ?? "Course Name") + ": " + String(courses[indexPath.row].hole_count ?? 0)
        
        return cell
    }
}


