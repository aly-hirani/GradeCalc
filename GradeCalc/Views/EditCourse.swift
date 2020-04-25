//
//  EditCourse.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/29/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct EditCourse: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var course: Course
    
    var body: some View {
        CourseDetailsForm(name: course.name, cutoffs: cutoffsIn(course), categories: categoriesIn(course), saveChanges: saveChanges)
            .navigationBarTitle("Edit Course")
    }
    
    private func saveChanges(name: String, cutoffs: [Cutoff], categories: [Category]) {
        if name != course.name {
            course.objectWillChange.send()
            course.name = name
        }
        
        if cutoffs.sorted() != cutoffsIn(course) {
            course.objectWillChange.send()
            course.cutoffs.forEach { c in moc.delete(c) }
            for c in cutoffs {
                course.addToCourseCutoffs(.createIn(moc, letter: c.letterGrade, number: c.numberGrade))
            }
        }
        
        if categories.sorted() != categoriesIn(course) {
            course.objectWillChange.send()
            course.categories.forEach { c in moc.delete(c) }
            for c in categories {
                course.addToCourseCategories(.createIn(moc, type: c.type, weight: c.weight, count: c.count))
            }
        }
        
        save(context: moc)
    }
    
    private func cutoffsIn(_ course: Course) -> [Cutoff] {
        course.cutoffs.compactMap { g in
            guard let ind = Constants.LetterGrades.firstIndex(of: g.letter) else { return nil }
            return Cutoff(letterIndex: ind, number: g.number)
        }
    }
    
    private func categoriesIn(_ course: Course) -> [Category] {
        course.categories.map { c in Category(type: c.type, weight: c.weight, count: Int(c.count)) }
    }
}
