//
//  CategoryGrade+CoreDataProperties.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/25/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryGrade {

    @NSManaged public var index: Int
    @NSManaged public var pointsEarned: Float
    @NSManaged public var pointsPossible: Float
    
    @NSManaged private var category: CourseCategory

}
