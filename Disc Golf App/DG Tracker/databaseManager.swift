import Foundation
import SQLite3

// Class that manages the database and db manipulation
class databaseManager
{

    // String to database
    let courses_DB_Path: String = "courseDatabase.sqlite"
    static var DB:OpaquePointer?
    
    // Initializes the class
    init()
    {
        databaseManager.DB = open_database()
        
        enableFK()
        
        //drop_holes_table()
        //drop_rounds_table()
        //drop_course_table()
        
        createCourseTable()
        createRoundsTable()
        createHolesTable()
        
    }

    
    // Opens the database
    func open_database() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(courses_DB_Path)
        var coursesDB: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &coursesDB) != SQLITE_OK{
            print("error opening database")
            return nil
        }
        else {
            return coursesDB
        }
    }
    
    // Enables Forign Keys
    func enableFK() {
        let fkTableString = "PRAGMA foreign_keys = ON;"
        
        var fkTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(databaseManager.DB, fkTableString, -1, &fkTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(fkTableStatement) == SQLITE_DONE
            {
                //print("fk enabled")
            } else {
                print("fk enable could not be done.")
            }
        } else {
            print("PRAGMA foreign_keys = ON; statement could not be prepared.")
        }
        sqlite3_finalize(fkTableStatement)
        
    }
    
    
    /*##################################
                  Courses
     ##################################*/
    
    
    // Creates the course table
    func createCourseTable() {
        
        let createTableString = "CREATE TABLE IF NOT EXISTS course(course_ID INTEGER PRIMARY KEY, name TEXT, hole_count INTEGER);"
        
        //let createTableString = "DROP TABLE course;"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(databaseManager.DB, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //print("course table created.")
            } else {
                print("course table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    // Adds course to the database
    func add_course(name:String, hole_count:Int)
    {
        
        // Creates the insert statement
        let insertStatementString = "INSERT INTO course(name, hole_count) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(databaseManager.DB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            //sqlite3_bind_int (insertStatement, 1, Int32(NextCourseID))
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int (insertStatement, 2, Int32(hole_count))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Successfully added course.")
            }
            else{
                print("Could not insert row.")
            }
        }
        else
        {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    // Gets the list of courses and creates a course class to put them in
    func get_courses() -> [Course] {
        let queryStatementString = "SELECT * FROM course;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Course] = []
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let hole_count = sqlite3_column_int(queryStatement, 2)
                
                psns.append(Course(ID: Int(id), name: name, hole_count: Int(hole_count)))
                //print("Query Result:")
                //print("\(id) | \(name) | \(hole_count)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    
    // Gets the information from the course supplied
    func get_course(courseID: Int) -> Course {
        let queryStatementString = "SELECT * FROM course WHERE course_ID = ?;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Course] = []
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(courseID))
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let hole_count = sqlite3_column_int(queryStatement, 2)
                
                psns.append(Course(ID: Int(id), name: name, hole_count: Int(hole_count)))
                //print("Query Result:")
                //print("\(id) | \(name) | \(hole_count)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns[0]
    }
    
    
    // Gets the course average round score
    func getCourseAverage(courseID: Int) -> Double {
        
        let queryStatementString = "SELECT avg(round_score) FROM rounds WHERE course_ID = ?;"
        var queryStatement: OpaquePointer? = nil
        var rounds: Double = 0
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(courseID))
            // Somereason still needed a while loop
            while(sqlite3_step(queryStatement) == SQLITE_ROW){
                rounds = sqlite3_column_double(queryStatement, 0)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return Double(rounds)
    }
    
    
    // Gets the course best round score
    func getCourseBest(courseID: Int) -> Int {
        
        let queryStatementString = "SELECT MIN(round_score) FROM rounds where course_ID = ?;"
        var queryStatement: OpaquePointer? = nil
        var courseBest: Int = 0
        
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int (queryStatement, 1, Int32(courseID))
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                courseBest = Int(sqlite3_column_int(queryStatement, 0))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        return courseBest
    }
    
    
    // Deletes the course from the table
    func delete_course(courseID:Int) {
        let deleteStatementStirng = "DELETE FROM course WHERE course_ID = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(databaseManager.DB, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(courseID))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted course.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    // Drops the course table
    func drop_course_table() {
        
        let deleteStatementStirng = "DROP TABLE course"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(databaseManager.DB, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully dropped table.")
            } else {
                print("Could not drop course table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    /*##################################
                  Rounds
     ##################################*/
    
    
    // Creates the rounds table
    func createRoundsTable() {
        
        let createTableString = "CREATE TABLE IF NOT EXISTS rounds(round_ID INTEGER PRIMARY KEY, course_ID INTEGER, round_score INTEGER, FOREIGN KEY(course_ID) REFERENCES course(course_ID));"
        
        //let createTableString = "DROP TABLE rounds;"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(databaseManager.DB, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //print("rounds table created.")
            } else {
                print("round table could not be created.")
            }
        } else {
            print("CREATE TABLE rounds statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    // Creates a new round
    func createNewRound(courseID: Int, roundScore: Int) -> Int {
        
        // Gets list of courses, finds the next available ID
        let round_IDs = get_rounds()
    
        // No ID can be 0
        var NextRoundID = 0
        var tryID = 0
        
        // Loops through IDs finding the next available
        while NextRoundID == 0
        {
            // If it found a new ID, set it
            if !round_IDs.contains(tryID)
            {
                NextRoundID = tryID
            }
            tryID += 1
        }
        
        let insertStatementString = "INSERT INTO rounds(round_ID, course_ID, round_score) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(databaseManager.DB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insertStatement, 1, Int32(NextRoundID))
            sqlite3_bind_int(insertStatement, 2, Int32(courseID))
            sqlite3_bind_int(insertStatement, 3, Int32(roundScore))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                //print("Successfully inserted round row.", NextRoundID, id)
            }
            else{
                print("Could not insert round row.")
            }
        }
        else{
            print("INSERT round statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
        return NextRoundID
    }
    
    
    func get_rounds() -> [Int] {
        let queryStatementString = "SELECT round_ID FROM rounds;"
        var queryStatement: OpaquePointer? = nil
        var roundIDs : [Int] = []
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                
                roundIDs.append(Int(id))
                //print("Query Result:")
                //print("\(id) ")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return roundIDs
    }
    
    
    // gets the rounds played by the course ID
    func getCourseRounds(courseID: Int) -> Int {
        let queryStatementString = "SELECT COUNT(round_ID) FROM rounds WHERE course_ID = ?;"
        var queryStatement: OpaquePointer? = nil
        var rounds: Int32 = 0
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(courseID))
            // Somereason still needed a while loop
            while(sqlite3_step(queryStatement) == SQLITE_ROW){
                rounds = sqlite3_column_int(queryStatement, 0)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return Int(rounds)
    }
    
    
    // Drops the course table
    func drop_rounds_table() {
        
        let deleteStatementStirng = "DROP TABLE rounds"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(databaseManager.DB, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully dropped table.")
            } else {
                print("Could not drop rounds table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    /*##################################
                   Holes
     ##################################*/
    
    
    // Creates the Holes table
    func createHolesTable() {
        
        let createTableString = "CREATE TABLE IF NOT EXISTS holes(hole_ID INTEGER PRIMARY KEY, hole_number INTEGER, round_ID INTEGER, par INTEGER, score DECIMAL(10,2), course_ID, FOREIGN KEY(round_ID) REFERENCES rounds(round_ID), FOREIGN KEY(course_ID) REFERENCES course(course_ID));"

        //let createTableString = "DROP TABLE holes;"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(databaseManager.DB, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //print("holes table created.")
            } else {
                print("holes table could not be created.")
            }
        } else {
            print("CREATE TABLE holes statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    // Adds a completed hole to the database
    func addHole(holeNumber: Int, holeScore: Int, par: Int, roundID: Int, courseID: Int) -> Void {
        
        let insertStatementString = "INSERT INTO holes(hole_number, par, score, round_ID, course_ID) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(databaseManager.DB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int (insertStatement, 1, Int32(holeNumber))
            sqlite3_bind_int (insertStatement, 2, Int32(par))
            sqlite3_bind_double(insertStatement, 3, Double(holeScore))
            sqlite3_bind_int (insertStatement, 4, Int32(roundID))
            sqlite3_bind_int (insertStatement, 5, Int32(courseID))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                //print("Successfully inserted hole row.")
            }
            else{
                print("Could not insert hole row.")
            }
        }
        else
        {
            print("INSERT hole statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    // Gets the holes most recent par
    func getHolePar(courseID: Int, holeNumber: Int) -> Int {
        
        let queryStatementString = "SELECT par FROM holes where course_ID = ? and hole_number = ?;"
        var queryStatement: OpaquePointer? = nil
        var roundPar: Int = 0
        
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int (queryStatement, 1, Int32(courseID))
            sqlite3_bind_int (queryStatement, 2, Int32(holeNumber))
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                roundPar = Int(sqlite3_column_int(queryStatement, 0))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        return roundPar
    }
    
    
    // Gets the holes best score
    func getHoleBest(courseID: Int, holeNumber: Int) -> Int {
        
        let queryStatementString = "SELECT MIN(score) FROM holes where course_ID = ? and hole_number = ?;"
        var queryStatement: OpaquePointer? = nil
        var roundBest: Int = 0
        
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int (queryStatement, 1, Int32(courseID))
            sqlite3_bind_int (queryStatement, 2, Int32(holeNumber))
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                roundBest = Int(sqlite3_column_int(queryStatement, 0))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        return roundBest
    }
    
    
    // Gets the holes average score
    func getHoleAverage(courseID: Int, holeNumber: Int) -> Double {
        
        let queryStatementString = "SELECT avg(score) FROM holes where course_ID = ? and hole_number = ?;"
        var queryStatement: OpaquePointer? = nil
        var roundAvg: Double = 0
        
        if sqlite3_prepare_v2(databaseManager.DB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int (queryStatement, 1, Int32(courseID))
            sqlite3_bind_int (queryStatement, 2, Int32(holeNumber))
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                roundAvg = Double(sqlite3_column_double(queryStatement, 0))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        return roundAvg
    }
    
    // Drops the holes table
    func drop_holes_table() {
        
        let deleteStatementStirng = "DROP TABLE holes"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(databaseManager.DB, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully dropped table.")
            } else {
                print("Could not drop holes table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
