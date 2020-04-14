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
            Text("Edit Course")
        }
    }
    
    private var editCourse: some View {
        EditCourse(course: course).environment(\.managedObjectContext, self.moc)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(course.cutoffs) { cutoff in
                    if !cutoff.isDeleted {
                        HStack {
                            Text(cutoff.letter)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(String(cutoff.number))
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
