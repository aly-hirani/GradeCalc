//
//  ContentView.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: Course.fetchRequest()) var courses
    
    @State var showAddCourseSheet = false
    
    var addButton: some View {
        Button(action: {
            self.showAddCourseSheet = true
        }) {
            Text("Add")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(courses) { course in
                        if !course.isDeleted {
                            NavigationLink(destination: CourseView(course: course).environment(\.managedObjectContext, self.managedObjectContext)) {
                                Text(course.name)
                            }
                        }
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            self.managedObjectContext.delete(self.courses[index])
                            save(context: self.managedObjectContext)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddCourseSheet) {
                AddCourseSheet().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .navigationBarTitle("Courses")
            .navigationBarItems(trailing: addButton)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
