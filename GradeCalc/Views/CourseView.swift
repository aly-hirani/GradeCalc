//
//  CourseView.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/29/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var course: Course
    
    @State var showingEditCourseView = false
    
    var editButton: some View {
        Button(action: {
            self.showingEditCourseView = true
        }) {
            Text("Edit")
        }
    }
    
    var body: some View {
        NavigationHelper(destination: EditCourseView(course: course).environment(\.managedObjectContext, self.managedObjectContext), isActive: $showingEditCourseView)
            .navigationBarTitle(course.name)
            .navigationBarItems(trailing: editButton)
    }
}

private struct NavigationHelper<Destination: View>: View {
    var destination: Destination
    var isActive: Binding<Bool>
    
    var body: some View {
        NavigationLink(destination: destination, isActive: isActive) {
            EmptyView()
        }
        .frame(width: 0, height: 0)
        .disabled(true)
        .hidden()
    }
}
