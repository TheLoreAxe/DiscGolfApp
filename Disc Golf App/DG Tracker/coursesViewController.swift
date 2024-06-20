//
//  ViewController.swift
//  Disc Golf Tracker
//
//  Created by Matthew Steffan on 11/8/21.
//

import UIKit

class coursesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var roundsPlayedLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var startRoundButton: UIButton!
    @IBOutlet weak var pleaseAddCourseText: UILabel!
    
    var selectedCourseID  = 0
    var selectedPickerRow = 0
    var courses:[Course]  = []
    
    // Inits the database
    var db:databaseManager = databaseManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Hides the back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //db.add_course(name: "Hitzman", hole_count: 2)
    }
    
    
    // Called when the view is about to appear
    override func viewWillAppear(_ animated: Bool) {
        
        // Reloads the components after an edit or delete
        pickerView.reloadAllComponents()
        
        // Gets the courses from the database
        courses = db.get_courses()
        
        // Sets the course ID to the first one if none is selected when started
        if courses.isEmpty == false {
            startRoundButton.isEnabled = true
            pleaseAddCourseText.isHidden = true
            selectedCourseID = courses[selectedPickerRow].course_ID ?? 0
        }
        else{
            startRoundButton.isEnabled = false
            pleaseAddCourseText.isHidden = false
        }
        
        pickerView.selectRow(selectedPickerRow, inComponent: 0, animated: false)
        roundsPlayedLabel.text = String(db.getCourseRounds(courseID: selectedCourseID))
        averageLabel.text      = String(round(db.getCourseAverage(courseID: selectedCourseID) * 10) / 10 )
        bestLabel.text         = String(db.getCourseBest(courseID: selectedCourseID))
    }
    
    
    // Returns number of columns in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // Returns the number of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        courses = db.get_courses()
        return courses.count
    }
    
    
    // Returns the value in each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses[row].name
    }
    
    
    // Used to ajust how the picker view is displayed
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        courses = db.get_courses()

        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Rockwell", size: 30)
            
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = courses[row].name! + ": " + String(courses[row].hole_count!)
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }
    
    
    // Sets the row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
                return 50
            }
    
    
    // Called when the picker changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow: Int, inComponent: Int) -> Void {
        
        selectedPickerRow = didSelectRow
        
        // prevents breaking if none are there
        if courses.isEmpty {
            return
        }
        
        selectedCourseID = courses[didSelectRow].course_ID ?? 0
        roundsPlayedLabel.text = String(db.getCourseRounds(courseID: selectedCourseID))
        averageLabel.text = String(round(db.getCourseAverage(courseID: selectedCourseID) * 10) / 10 )
        bestLabel.text = String(db.getCourseBest(courseID: selectedCourseID))
    }
    
    
    // Used to send values to the new screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is roundViewController {
            let vc = segue.destination as? roundViewController
            vc?.courseIDSelected = selectedCourseID
        }
    }
    
}
