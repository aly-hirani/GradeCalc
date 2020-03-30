//
//  HomeView.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: Course.fetchRequest()) var courses
    
    @State private var showAddCourseSheet = false
    
    var addCourseButton: some View {
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
                    .onDelete { offsets in
                        for index in offsets {
                            self.managedObjectContext.delete(self.courses[index])
                        }
                        save(context: self.managedObjectContext)
                    }
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
