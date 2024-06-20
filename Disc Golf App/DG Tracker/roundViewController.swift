//
//  roundViewController.swift
//  DG Tracker
//
//  Created by Matthew Steffan on 11/22/21.
//

import UIKit

class roundViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var courseIDSelected = 0
    var numberOfHoles    = 0
    var currentHoleIndex = 0
    var currentScore     = 0
    var maxPar           = 12
    var holeBest         = 0
    var holeAverage      = 0.0
    var listOfHoles: [hole] = []
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var courseNameLabel:   UILabel!
    @IBOutlet weak var holeNumberLabel:   UILabel!
    @IBOutlet weak var holeScoreLabel:    UILabel!
    @IBOutlet weak var holeBestLabel:     UILabel!
    @IBOutlet weak var holeAverageLabel:  UILabel!
    @IBOutlet weak var holeParLabel:      UITextField!
    @IBOutlet weak var prevButton:        UIButton!
    @IBOutlet weak var nextButton:        UIButton!
    @IBOutlet weak var finishButton:      UIButton!
    @IBOutlet weak var pickerView:        UIPickerView!
    
    
    // Creates the databse
    let db:databaseManager = databaseManager()
    
    // Called when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect the picker view
        pickerView.delegate   = self
        pickerView.dataSource = self
        
        // Sets picker view to -
        pickerView.selectRow(maxPar, inComponent: 0, animated: false)
        
        overrideUserInterfaceStyle = .dark
        
        // Puts a curve on the score label
        currentScoreLabel.layer.masksToBounds = true
        currentScoreLabel.layer.cornerRadius  = 25
        
        // Gets the current course and number of holes in course
        let courseSelected:Course = db.get_course(courseID:courseIDSelected)
        numberOfHoles = courseSelected.hole_count!
        
        // Creates hole objects for each hole in course
        for i in 1 ... numberOfHoles {
            // Checks if par was already set for this hole
            let par = db.getHolePar(courseID: courseIDSelected, holeNumber: i)
            // If par is found, set to it
            if par != 0{
                listOfHoles.append(hole(Number: i, Par: par))
            }
            // Else leave par as nil and append to list
            else{
                listOfHoles.append(hole(Number: i))
            }
        }
        
        // Sets the page texts
        courseNameLabel.text = courseSelected.name! + " " + String(numberOfHoles) + " Hole"
        refreshLabels()
    }
    
    // Called when the previous button is pressed
    @IBAction func prevButtonAction(_ sender: Any) {
        // Goes to the previous hole
        currentHoleIndex -= 1
        refreshLabels()
    }
    
    // Called when the next button is pressed
    @IBAction func nextButtonAction(_ sender: Any) {
        
        // Goes to the next hole
        currentHoleIndex += 1
        refreshLabels()
    }
    
    // Called when the subtract button is pressed
    @IBAction func subScoreAction(_ sender: Any) {
        
        // If no score was entered
        if listOfHoles[currentHoleIndex].score == nil {
            
            // If hole doesn't have par, set to 2
            if listOfHoles[currentHoleIndex].par == nil{
                listOfHoles[currentHoleIndex].score = 2
            }
            // If hole has par, set to par - 1
            else{
                listOfHoles[currentHoleIndex].score = listOfHoles[currentHoleIndex].par! - 1
            }
        }
        // If score was entered already, subtract one as long as it isnt going to be 0
        else if listOfHoles[currentHoleIndex].score! > 1{
            listOfHoles[currentHoleIndex].score! -= 1
        }

        refreshLabels()
    }
    
    // Called when the Plus button is pressed
    @IBAction func addToScoreAction(_ sender: Any) {
        
        // If no score is entered yet, set to par
        if listOfHoles[currentHoleIndex].score == nil {
            
            // If hole doesnt have par, set to 3
            if listOfHoles[currentHoleIndex].par == nil{
                listOfHoles[currentHoleIndex].score = 3
            }
            // If hole has par, set to par
            else{
                listOfHoles[currentHoleIndex].score = listOfHoles[currentHoleIndex].par
            }
        }
        // If already entered score, check if it is less than the max and add one
        else if listOfHoles[currentHoleIndex].score! < (listOfHoles[currentHoleIndex].par ?? maxPar) * 2{
            listOfHoles[currentHoleIndex].score! += 1
        }

        refreshLabels()
    }
    
    // Changes all of the labels in the view to the appropriate value
    func refreshLabels() {
        
        // Sets the hole label
        holeNumberLabel.text = "Hole " + String(currentHoleIndex + 1)
        
        // If no par has been set yet, set to -
        if listOfHoles[currentHoleIndex].par == nil {
            pickerView.selectRow(maxPar, inComponent: 0, animated: false)
        }
        // If the round has a par, set the picker view
        else{
            pickerView.selectRow(maxPar - (listOfHoles[currentHoleIndex].par ?? 0), inComponent: 0, animated: false)
        }
        
        // If no score has been entered, set label to -
        if listOfHoles[currentHoleIndex].score == nil {
            holeScoreLabel.text = "-"
        }
        
        // else, set it to the value in the object
        else{
            holeScoreLabel.text = String(listOfHoles[currentHoleIndex].score ?? Int())
        }
        
        // Calculates the current score
        currentScore = 0
                
        for score in listOfHoles{
            if (score.score != nil && score.par != nil){
                currentScore += (score.score ?? 0) - (score.par ?? 0)
            }
        }
                
        currentScoreLabel.text = String(currentScore)
        
        // Gets the hole best score and sets the label
        holeBest = db.getHoleBest(courseID: courseIDSelected, holeNumber: currentHoleIndex + 1)
        holeBestLabel.text = String(holeBest)
        
        // Gets the hole average and sets the label
        holeAverage = db.getHoleAverage(courseID: courseIDSelected, holeNumber: currentHoleIndex + 1)
        holeAverageLabel.text = String(round(holeAverage * 10) / 10 )
         
        // Hides the buttons based on the current status
        hideButtons()
    }
    
    // Hides the buttons according to what hole it is on
    func hideButtons(){

        // Sets previous button
        if currentHoleIndex == 0{
            prevButton.isEnabled = false
        }
        else{
            prevButton.isEnabled = true
        }
    
        // If no score or no par is set, hide next button
        if currentHoleIndex == numberOfHoles - 1 || listOfHoles[currentHoleIndex].score == nil || listOfHoles[currentHoleIndex].par == nil{
            nextButton.isEnabled = false
        }
        else{
            nextButton.isEnabled = true
        }
        
        // Sets the finish button if last hole
        if currentHoleIndex == numberOfHoles - 1 && listOfHoles[currentHoleIndex].score != nil && listOfHoles[currentHoleIndex].par != nil{
            finishButton.isEnabled = true
        }
        else{
            finishButton.isEnabled = false
        }
    }
    
    // Returns the number of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxPar + 1
    }
    
    // Number of columns in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Used to ajust how the picker view is displayed
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Futura", size: 30)
            
            pickerLabel?.textAlignment = .center
        }
        if row == maxPar{
            pickerLabel?.text = "-"
        }
        else{
            pickerLabel?.text = String(maxPar - row)
        }
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }
    
    // Sets the row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
                return 35
    }
    
    // Called when the picker changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow: Int, inComponent: Int) -> Void {
    
        listOfHoles[currentHoleIndex].par = maxPar - pickerView.selectedRow(inComponent: 0)
        
        // If changed and score is higher than double par, adjust
        if (listOfHoles[currentHoleIndex].score ?? 0) > (listOfHoles[currentHoleIndex].par ?? maxPar) * 2{
            listOfHoles[currentHoleIndex].score = (listOfHoles[currentHoleIndex].par ?? maxPar)  * 2
        }
        
        refreshLabels()
    }
    
    // Called when the finish button is pressed
    @IBAction func finishRoundButtonAction(_ sender: Any) {
        
        // Gives the new round an ID
        let rID: Int = db.createNewRound(courseID: courseIDSelected, roundScore: currentScore)

        // ADDS HOLES
        for hole in listOfHoles {
            db.addHole(holeNumber: hole.number!,
                       holeScore: hole.score!,
                       par: hole.par!,
                       roundID: rID,
                       courseID: courseIDSelected)
        }
    }
    
    // Used to send values to the new screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is roundFinalViewController {
            let vc = segue.destination as? roundFinalViewController
            vc?.listOfHoles = listOfHoles
        }
    }
}
