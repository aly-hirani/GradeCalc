//
//  CourseView.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/29/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @ObservedObject var course: Course
    
    @State private var showingEditCourseView = false
    
    private var editButton: some View {
        Button(action: {
            self.showingEditCourseView = true
        }) {
            Text("Edit Course")
        }
    }
    
    private var editCourseView: some View {
        EditCourseView(course: course)
            .onDisappear { save(context: self.managedObjectContext) }
    }
    
    var body: some View {
        VStack {
            List(course.cutoffsArray) { cutoff in
                HStack {
                    Text(cutoff.letter)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(cutoff.number))
                }
            }
            .listStyle(GroupedListStyle())
            
            NavigationHelper(destination: editCourseView, isActive: $showingEditCourseView)
        }
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
