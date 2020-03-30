//
//  EditCourseView.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/29/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct EditCourseView: View {
    var course: Course
    
    @State private var showingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Course Details")) {
                TextField(course.name, text: .init(get: { self.course.name }, set: setName))
            }
        }
        .navigationBarTitle("Edit Course")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Course Name cannot be empty"), dismissButton: .cancel(Text("Dismiss")))
        }
    }
    
    private func setName(_ name: String) {
        if name.isEmpty {
            showingAlert = true
        } else {
            course.objectWillChange.send()
            course.name = name
        }
    }
}
