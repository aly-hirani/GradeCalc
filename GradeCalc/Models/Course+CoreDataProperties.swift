//
//  Course+CoreDataProperties.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData


extension Course: Identifiable {

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    
    @NSManaged private var courseCutoffs: NSSet
    @NSManaged private var courseCategories: NSSet

    public var cutoffs: [CourseCutoff] {
        let set = courseCutoffs as? Set<CourseCutoff> ?? []
        return set.sorted { a, b in
            let aInd = Constants.LetterGrades.firstIndex(of: a.letter) ?? Int.max
            let bInd = Constants.LetterGrades.firstIndex(of: b.letter) ?? Int.max
            return aInd < bInd
        }
    }
    
    public var categories: [CourseCategory] {
        let set = courseCategories as? Set<CourseCategory> ?? []
        return set.sorted { a, b in a.type < b.type }
    }

}

// MARK: Generated accessors for courseCutoffs
extension Course {

    @objc(addCourseCutoffsObject:)
    @NSManaged public func addToCourseCutoffs(_ value: CourseCutoff)

}

// MARK: Generated accessors for courseCategories
extension Course {

    @objc(addCourseCategoriesObject:)
    @NSManaged public func addToCourseCategories(_ value: CourseCategory)
    
}
