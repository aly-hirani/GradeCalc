//
//  CourseCategory+CoreDataProperties.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/20/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData


extension CourseCategory: Identifiable {
    
    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var weight: Float
    @NSManaged public var count: Int
    
    @NSManaged private var categoryGrades: NSSet
    
    @NSManaged private var course: Course
    
    public var grades: [CategoryGrade] {
        [CategoryGrade](categoryGrades as? Set<CategoryGrade> ?? [])
    }

}

// MARK: Generated accessors for categoryGrades
extension CourseCategory {

    @objc(addCategoryGradesObject:)
    @NSManaged public func addToCategoryGrades(_ value: CategoryGrade)

}
