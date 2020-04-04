//
//  AddCourseSheet.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct AddCourseSheet: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var showingAlert = false
    @State private var cutoffs: [Cutoff] = []
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    private var doneButton: some View {
        Button(action: saveChanges, label: { Text("Done") })
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Details")) {
                    TextField("Course Name", text: $name)
                }
                
                Section(header: Text("Grade Cutoffs")) {
                    AddCourseCutoffsView(cutoffs: $cutoffs)
                }
            }
            .navigationBarTitle("Add Course")
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Course Name cannot be empty"), dismissButton: .cancel(Text("Dismiss")))
        }
    }
    
    private func saveChanges() {
        if name.isEmpty {
            showingAlert = true
        } else {
            let course = Course(context: managedObjectContext)
            course.id = UUID()
            course.name = name
            for cutoff in cutoffs {
                let gradeCutoff = GradeCutoff(context: managedObjectContext)
                gradeCutoff.course = course
                gradeCutoff.id = UUID()
                gradeCutoff.letter = cutoff.letterGrade()
                gradeCutoff.number = cutoff.numberGrade()
            }
            save(context: managedObjectContext)
            presentationMode.wrappedValue.dismiss()
        }
    }
}
