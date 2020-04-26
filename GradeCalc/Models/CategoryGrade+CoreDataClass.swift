//
//  CategoryGrade+CoreDataClass.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/25/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CategoryGrade)
public class CategoryGrade: NSManagedObject {
    
    static func createIn(_ moc: NSManagedObjectContext, index: Int, grade: Float) -> CategoryGrade {
        let categoryGrade = CategoryGrade(context: moc)
        categoryGrade.index = index
        categoryGrade.grade = grade
        return categoryGrade
    }

}
