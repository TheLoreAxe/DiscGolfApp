//
//  hole.swift
//  DG Tracker
//
//  Created by Matthew Steffan on 11/30/21.
//

import Foundation

class hole
{
    var number: Int?    = 0
    var par:    Int?    = 0
    var score:  Int?    = 0
    
    init(Number:Int? = nil, Par:Int? = nil, Score:Int? = nil)
    {
        self.number = Number
        self.par    = Par
        self.score  = Score
    }
    
}
