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
            Text("Edit Course").bold()
        }
    }
    
    private var editCourse: some View {
        EditCourse(course: course).environment(\.managedObjectContext, self.moc)
    }
    
    var body: some View {
        VStack {
            List {
                Text("Course Cutoffs")
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity)
                ForEach(course.cutoffs) { cutoff in
                    if !cutoff.isDeleted {
                        HStack {
                            Text(cutoff.letter).bold()
                            Spacer()
                            Text(String(cutoff.number))
                        }
                    }
                }
                
                Text("Course Categories")
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity)
                ForEach(course.categories) { category in
                    if !category.isDeleted {
                        HStack {
                            Text(category.type + ":").bold()
                            Text(String(category.count))
                            Spacer()
                            Text(String(format: "%.2f%% each", category.weight / Float(category.count)))
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            
            NavigationHelper(destination: editCourse, isActive: $showingEditCourse)
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
