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
        let request = NSFetchRequest<Course>(entityName: "Course")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        return request
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String

}
