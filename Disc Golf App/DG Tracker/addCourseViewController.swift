//
//  addCourseViewController.swift
//  DG Tracker
//
//  Created by Matthew Steffan on 11/25/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class addCourseViewController: UIViewController {

    @IBOutlet weak var courseNameField: UITextField!
    @IBOutlet weak var numberHolesField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func AddCourseButtonAction(_ sender: Any) {
        
        let db:databaseManager = databaseManager()
        let cName = String(courseNameField.text ?? "Course Name")
        guard let holes = Int(numberHolesField.text ?? "0") else { return }
        
        // Make 27 the highest
        
        db.add_course(name: cName, hole_count: holes)
        
        courseNameField.text = ""
        numberHolesField.text = ""
        
        
        /*
        let messageVC = self.storyboard?.instantiateViewController(withIdentifier: "courseTableViewController") as! courseTableViewController
        let MynavController = UINavigationController(rootViewController: messageVC)
        self.present(MynavController, animated: true, completion: nil)
         */
        
    }
}


