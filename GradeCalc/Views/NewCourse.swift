//
//  NewCourse.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct NewCourse: View {
    @Environment(\.managedObjectContext) private var moc
    
    var body: some View {
        NavigationView {
            CourseDetailsForm(name: "", cutoffs: [], saveChanges: saveChanges)
                .navigationBarTitle("New Course")
        }
    }
    
    private func saveChanges(name: String, cutoffs: [Cutoff]) {
        let course = Course.createIn(moc, name: name)
        for c in cutoffs {
            course.addToCourseCutoffs(.createIn(moc, letter: c.letterGrade, number: c.numberGrade))
        }
        save(context: moc)
    }
}
