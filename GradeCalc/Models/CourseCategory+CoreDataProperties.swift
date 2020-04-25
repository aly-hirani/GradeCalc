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
    @NSManaged public var count: Int64
    
    @NSManaged public var course: Course

}
