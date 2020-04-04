//
//  GradeCutoff+CoreDataProperties.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/30/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData


extension GradeCutoff: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GradeCutoff> {
        return NSFetchRequest<GradeCutoff>(entityName: "GradeCutoff")
    }

    @NSManaged public var id: UUID
    @NSManaged public var letter: String
    @NSManaged public var number: Float
    @NSManaged public var course: Course

}
