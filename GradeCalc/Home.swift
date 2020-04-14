//
//  Home.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct Home: View {
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(entity: Course.entity(), sortDescriptors: [.init(keyPath: \Course.name, ascending: true)]) private var courses: FetchedResults<Course>
    
    @State private var showNewCourse = false
    
    private var newCourseButton: some View {
        Button(action: {
            self.showNewCourse = true
        }) {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
            Text("New Course")
                .fontWeight(.bold)
        }
        .foregroundColor(Constants.AppColor)
        .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if !courses.isEmpty {
                    List {
                        ForEach(courses) { course in
                            if !course.isDeleted {
                                NavigationLink(destination: ViewCourse(course: course)) {
                                    Text(course.name)
                                }
                            }
                        }
                        .onDelete(perform: deleteCourses)
                    }
                }
                newCourseButton
            }
            .navigationBarTitle("Courses")
        }
        .sheet(isPresented: $showNewCourse) {
            NewCourse().environment(\.managedObjectContext, self.moc)
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: Constants.AppUIColor]
    }
    
    private func deleteCourses(offsets: IndexSet) {
        for index in offsets {
            moc.delete(courses[index])
        }
        save(context: moc)
    }
}
