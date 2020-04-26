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
        
        var cutoffs = cutoffs
        for courseCutoff in course.cutoffs {
            if let cutoff = cutoffs.first(where: { c in c.id == courseCutoff.id }) {
                if cutoff.letterGrade != courseCutoff.letter {
                    course.objectWillChange.send()
                    courseCutoff.letter = cutoff.letterGrade
                }
                if cutoff.numberGrade != courseCutoff.number {
                    course.objectWillChange.send()
                    courseCutoff.number = cutoff.numberGrade
                }
                cutoffs.removeAll { c in c.id == courseCutoff.id }
            } else {
                course.objectWillChange.send()
                moc.delete(courseCutoff)
            }
        }
        for c in cutoffs {
            course.objectWillChange.send()
            course.addToCourseCutoffs(.createIn(moc, letter: c.letterGrade, number: c.numberGrade))
        }
        
        var categories = categories
        for courseCategory in course.categories {
            if let category = categories.first(where: { c in c.id == courseCategory.id }) {
                if category.type != courseCategory.type {
                    course.objectWillChange.send()
                    courseCategory.type = category.type
                }
                if category.weight != courseCategory.weight {
                    course.objectWillChange.send()
                    courseCategory.weight = category.weight
                }
                if category.count != courseCategory.count {
                    course.objectWillChange.send()
                    courseCategory.count = category.count
                }
                categories.removeAll { c in c.id == courseCategory.id }
            } else {
                course.objectWillChange.send()
                moc.delete(courseCategory)
            }
        }
        for c in categories {
            course.objectWillChange.send()
            course.addToCourseCategories(.createIn(moc, type: c.type, weight: c.weight, count: c.count))
        }
        
        save(context: moc)
    }
    
    private func cutoffsIn(_ course: Course) -> [Cutoff] {
        course.cutoffs.compactMap { g in
            guard let ind = Constants.LetterGrades.firstIndex(of: g.letter) else {
                course.objectWillChange.send()
                moc.delete(g)
                save(context: moc)
                return nil
            }
            return Cutoff(id: g.id, letterIndex: ind, number: g.number)
        }
    }
    
    private func categoriesIn(_ course: Course) -> [Category] {
        course.categories.map { c in Category(id: c.id, type: c.type, weight: c.weight, count: c.count) }
    }
}
