//
//  CourseCutoff+CoreDataClass.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/30/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CourseCutoff)
public class CourseCutoff: NSManagedObject {
    
    static func createIn(_ moc: NSManagedObjectContext, letter: String, number: Float) -> CourseCutoff {
        let courseCutoff = CourseCutoff(context: moc)
        courseCutoff.id = UUID()
        courseCutoff.letter = letter
        courseCutoff.number = number
        return courseCutoff
    }

}
