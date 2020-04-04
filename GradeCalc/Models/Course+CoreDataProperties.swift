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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var cutoffs: NSSet

    public var cutoffsArray: [GradeCutoff] {
        let set = cutoffs as? Set<GradeCutoff> ?? []
        return set.sorted { a, b in
            let aInd = Constants.letterGrades.firstIndex(of: a.letter) ?? Int.max
            let bInd = Constants.letterGrades.firstIndex(of: b.letter) ?? Int.max
            return aInd < bInd
        }
    }

}

// MARK: Generated accessors for cutoffs
extension Course {

    @objc(addCutoffsObject:)
    @NSManaged public func addToCutoffs(_ value: GradeCutoff)

    @objc(removeCutoffsObject:)
    @NSManaged public func removeFromCutoffs(_ value: GradeCutoff)

    @objc(addCutoffs:)
    @NSManaged public func addToCutoffs(_ values: NSSet)

    @objc(removeCutoffs:)
    @NSManaged public func removeFromCutoffs(_ values: NSSet)

}
