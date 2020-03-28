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
    
    @FetchRequest(entity: Course.entity(), sortDescriptors: []) var courses: FetchedResults<Course>
    
    @State var showAddCourseSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(courses) { course in
                        Text(course.name)
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            self.managedObjectContext.delete(self.courses[index])
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddCourseSheet) {
                AddCourseSheet().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .navigationBarTitle("Courses")
            .navigationBarItems(trailing: Button(action: {
                self.showAddCourseSheet = true
            }, label: {
                Text("Add")
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
