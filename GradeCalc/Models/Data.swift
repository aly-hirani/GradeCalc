//
//  Data.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/28/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import Foundation
import CoreData

func save(context: NSManagedObjectContext) {
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
}
