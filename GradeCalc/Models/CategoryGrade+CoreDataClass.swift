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
    
    static func createIn(_ moc: NSManagedObjectContext, index: Int, earned: Float, possible: Float) -> CategoryGrade {
        let categoryGrade = CategoryGrade(context: moc)
        categoryGrade.index = index
        categoryGrade.pointsEarned = earned
        categoryGrade.pointsPossible = possible
        return categoryGrade
    }

}
