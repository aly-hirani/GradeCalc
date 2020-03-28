//
//  Course+CoreDataClass.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Course)
public class Course: NSManagedObject {
    
    func construct(name: String) {
        self.id = UUID()
        self.name = name
    }

}
