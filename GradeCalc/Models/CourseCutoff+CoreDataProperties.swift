//
//  CourseCutoff+CoreDataProperties.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/30/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData


extension CourseCutoff: Identifiable {

    @NSManaged public var id: UUID
    @NSManaged public var letter: String
    @NSManaged public var number: Float
    
    @NSManaged private var course: Course

}
