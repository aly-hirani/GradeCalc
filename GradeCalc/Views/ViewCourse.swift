//
//  ViewCourse.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/29/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct ViewCourse: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var course: Course
    
    @State private var showingEditCourse = false
    
    private var editButton: some View {
        Button(action: {
            self.showingEditCourse = true
        }) {
            Text("Edit").bold()
        }
    }
    
    private var editCourse: some View {
        EditCourse(course: course).environment(\.managedObjectContext, moc)
    }
    
    var body: some View {
        VStack {
            Form {
                ForEach(course.categories) { category in
                    if !category.isDeleted {
                        EditGrades(category: category).environment(\.managedObjectContext, self.moc)
                    }
                }
            }
            
            NavigationHelper(destination: editCourse, isActive: $showingEditCourse)
        }
        .navigationBarTitle(course.name)
        .navigationBarItems(trailing: editButton)
    }
}
