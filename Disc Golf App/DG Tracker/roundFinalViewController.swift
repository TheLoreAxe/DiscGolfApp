import UIKit

class roundFinalViewController: UIViewController {
    
    @IBOutlet weak var hole10to18img: UIImageView!
    @IBOutlet weak var hole19to27img: UIImageView!
    
    // Connection to text labels
    @IBOutlet weak var holeText2: UILabel!
    @IBOutlet weak var parText2: UILabel!
    @IBOutlet weak var scoreText2: UILabel!
    @IBOutlet weak var holeText3: UILabel!
    @IBOutlet weak var parText3: UILabel!
    @IBOutlet weak var scoreText3: UILabel!
    
    // Connection to all hole number labels
    @IBOutlet weak var hole1: UILabel!
    @IBOutlet weak var hole2: UILabel!
    @IBOutlet weak var hole3: UILabel!
    @IBOutlet weak var hole4: UILabel!
    @IBOutlet weak var hole5: UILabel!
    @IBOutlet weak var hole6: UILabel!
    @IBOutlet weak var hole7: UILabel!
    @IBOutlet weak var hole8: UILabel!
    @IBOutlet weak var hole9: UILabel!
    @IBOutlet weak var hole10: UILabel!
    @IBOutlet weak var hole11: UILabel!
    @IBOutlet weak var hole12: UILabel!
    @IBOutlet weak var hole13: UILabel!
    @IBOutlet weak var hole14: UILabel!
    @IBOutlet weak var hole15: UILabel!
    @IBOutlet weak var hole16: UILabel!
    @IBOutlet weak var hole17: UILabel!
    @IBOutlet weak var hole18: UILabel!
    @IBOutlet weak var hole19: UILabel!
    @IBOutlet weak var hole20: UILabel!
    @IBOutlet weak var hole21: UILabel!
    @IBOutlet weak var hole22: UILabel!
    @IBOutlet weak var hole23: UILabel!
    @IBOutlet weak var hole24: UILabel!
    @IBOutlet weak var hole25: UILabel!
    @IBOutlet weak var hole26: UILabel!
    @IBOutlet weak var hole27: UILabel!
    
    
    // Connection to all par labels
    @IBOutlet weak var par1: UILabel!
    @IBOutlet weak var par2: UILabel!
    @IBOutlet weak var par3: UILabel!
    @IBOutlet weak var par4: UILabel!
    @IBOutlet weak var par5: UILabel!
    @IBOutlet weak var par6: UILabel!
    @IBOutlet weak var par7: UILabel!
    @IBOutlet weak var par8: UILabel!
    @IBOutlet weak var par9: UILabel!
    @IBOutlet weak var par10: UILabel!
    @IBOutlet weak var par11: UILabel!
    @IBOutlet weak var par12: UILabel!
    @IBOutlet weak var par13: UILabel!
    @IBOutlet weak var par14: UILabel!
    @IBOutlet weak var par15: UILabel!
    @IBOutlet weak var par16: UILabel!
    @IBOutlet weak var par17: UILabel!
    @IBOutlet weak var par18: UILabel!
    @IBOutlet weak var par19: UILabel!
    @IBOutlet weak var par20: UILabel!
    @IBOutlet weak var par21: UILabel!
    @IBOutlet weak var par22: UILabel!
    @IBOutlet weak var par23: UILabel!
    @IBOutlet weak var par24: UILabel!
    @IBOutlet weak var par25: UILabel!
    @IBOutlet weak var par26: UILabel!
    @IBOutlet weak var par27: UILabel!
    
    // Connection to all score labels
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var score3: UILabel!
    @IBOutlet weak var score4: UILabel!
    @IBOutlet weak var score5: UILabel!
    @IBOutlet weak var score6: UILabel!
    @IBOutlet weak var score7: UILabel!
    @IBOutlet weak var score8: UILabel!
    @IBOutlet weak var score9: UILabel!
    @IBOutlet weak var score10: UILabel!
    @IBOutlet weak var score11: UILabel!
    @IBOutlet weak var score12: UILabel!
    @IBOutlet weak var score13: UILabel!
    @IBOutlet weak var score14: UILabel!
    @IBOutlet weak var score15: UILabel!
    @IBOutlet weak var score16: UILabel!
    @IBOutlet weak var score17: UILabel!
    @IBOutlet weak var score18: UILabel!
    @IBOutlet weak var score19: UILabel!
    @IBOutlet weak var score20: UILabel!
    @IBOutlet weak var score21: UILabel!
    @IBOutlet weak var score22: UILabel!
    @IBOutlet weak var score23: UILabel!
    @IBOutlet weak var score24: UILabel!
    @IBOutlet weak var score25: UILabel!
    @IBOutlet weak var score26: UILabel!
    @IBOutlet weak var score27: UILabel!
    
    // Initializes the list of holes to be set from previous segue
    var listOfHoles: [hole] = []
    
    // When the view loads
    override func viewDidLoad() {
        
        // Sets to dark mode
        overrideUserInterfaceStyle = .dark
        
        //hole19to27img.layer.position = CGPoint.init(x: 40, y: 40)
        
        // Makes a list of all the hole number labels
        let holeLabels:[UILabel]=[hole1, hole2, hole3, hole4, hole5, hole6, hole7, hole8, hole9, hole10, hole11, hole12, hole13, hole14, hole15, hole16, hole17, hole18, hole19, hole20, hole21, hole22, hole23, hole24, hole25, hole26, hole27]
        
        // Makes a list of all the par labels
        let parLabels:[UILabel]=[par1, par2, par3, par4, par5, par6, par7, par8, par9, par10, par11, par12, par13, par14, par15, par16, par17, par18, par19, par20, par21, par22, par23, par24, par25, par26, par27]
        
        // Makes a list of all the score labels
        let scoreLabels:[UILabel]=[score1, score2, score3, score4, score5, score6, score7, score8, score9, score10, score11, score12, score13, score14, score15, score16, score17, score18, score19, score20, score21, score22, score23, score24, score25, score26, score27]
        
        
        // Initializes the variables
        var i = 0
        var parLabel = parLabels[i]
        var scoreLabel = scoreLabels[i]
        
        // Hides all hole number labels
        for label in holeLabels{
            label.isHidden = true
        }
        
        // Loops through the holes we are using
        for hole in listOfHoles {
            
            // Hides the labels we dont use
            if listOfHoles.count <= 9
            {
                holeText2.isHidden = true
                parText2.isHidden = true
                scoreText2.isHidden = true
                
                // Hides the image
                hole10to18img.isHidden = true
            }
            
            // Hides the labels we dont use
            if listOfHoles.count <= 18
            {
                holeText3.isHidden = true
                parText3.isHidden = true
                scoreText3.isHidden = true
                
                // Hides the image
                hole19to27img.isHidden = true
            }
            
            // Unhides the labels we need
            holeLabels[i].isHidden = false

            // Sets the par labels
            parLabel = parLabels[i]
            parLabel.text = String(hole.par!)

            // Sets the score labels
            scoreLabel = scoreLabels[i]
            scoreLabel.text = String(hole.score!)

            // Changes the color of the score based on how well or bad
            // If hole in one, set green
            if hole.score == 1
            {
                scoreLabel.textColor = UIColor.green
            }
            
            // If score is less than par, set blue
            else if hole.par! > hole.score!
            {
                scoreLabel.textColor = UIColor.blue
            }
            
            // if score is 2x par, set red
            else if hole.score! == hole.par! * 2
            {
                scoreLabel.textColor = UIColor.red
            }
            
            // If score is higher than par, set orange
            else if hole.par! < hole.score!
            {
                scoreLabel.textColor = UIColor.orange
            }
            
            // Increments to next hole
            i += 1
        }
    }
}
