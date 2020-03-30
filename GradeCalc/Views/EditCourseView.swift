//
//  EditCourseView.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/29/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct EditCourseView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var course: Course
    
    @State var showingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Course Details")) {
                TextField(course.name, text: .init(get: { self.course.name }, set: { name in
                    if name.isEmpty {
                        self.showingAlert = true
                    } else {
                        self.course.objectWillChange.send()
                        self.course.name = name
                        save(context: self.managedObjectContext)
                    }
                }))
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Course Name cannot be empty"), dismissButton: .cancel(Text("Dismiss")))
        }
    }
}
