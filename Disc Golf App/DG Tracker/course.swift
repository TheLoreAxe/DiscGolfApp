//
//  Course.swift
//  Disc Golf Tracker
//
//  Created by Matthew Steffan on 11/20/21.
//

import Foundation

class Course
{
    var name:       String? = ""
    var hole_count: Int?    = 0
    var course_ID:  Int?    = 0
    
    init(ID:Int? = nil, name:String? = nil, hole_count:Int? = nil)
    {
        self.name = name
        self.hole_count = hole_count
        self.course_ID = ID
    }
    
}
