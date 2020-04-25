//
//  Course+CoreDataClass.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Course)
public class Course: NSManagedObject {
    
    static func createIn(_ moc: NSManagedObjectContext, name: String) -> Course {
        let course = Course(context: moc)
        course.id = UUID()
        course.name = name
        return course
    }

}
