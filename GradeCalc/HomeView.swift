//
//  HomeView.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(entity: Course.entity(), sortDescriptors: [.init(keyPath: \Course.name, ascending: true)]) private var courses: FetchedResults<Course>
    
    @State private var showAddCourseSheet = false
    
    private var addCourseButton: some View {
        Button(action: {
            self.showAddCourseSheet = true
        }) {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
            Text("Add Course")
                .fontWeight(.bold)
        }
        .foregroundColor(.init(UIColor.systemTeal))
        .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(courses) { course in
                        if !course.isDeleted {
                            NavigationLink(destination: CourseView(course: course)) {
                                Text(course.name)
                            }
                        }
                    }
                    .onDelete(perform: deleteCourses)
                }
                addCourseButton
            }
            .navigationBarTitle("Courses")
        }
        .sheet(isPresented: $showAddCourseSheet) {
            AddCourseSheet()
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemTeal]
    }
    
    private func deleteCourses(offsets: IndexSet) {
        for index in offsets {
            managedObjectContext.delete(courses[index])
        }
        save(context: managedObjectContext)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
