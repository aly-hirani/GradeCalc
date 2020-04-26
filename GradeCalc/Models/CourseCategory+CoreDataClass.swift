//
//  CourseCategory+CoreDataClass.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/20/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CourseCategory)
public class CourseCategory: NSManagedObject {
    
    static func createIn(_ moc: NSManagedObjectContext, type: String, weight: Float, count: Int) -> CourseCategory {
        let courseCategory = CourseCategory(context: moc)
        courseCategory.id = UUID()
        courseCategory.type = type
        courseCategory.weight = weight
        courseCategory.count = count
        return courseCategory
    }

}
