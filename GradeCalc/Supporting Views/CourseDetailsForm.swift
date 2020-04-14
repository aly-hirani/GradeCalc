//
//  CourseDetailsForm.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/14/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct CourseDetailsForm: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var name: String
    @State var cutoffs: [Cutoff]
    
    var saveChanges: (String, [Cutoff]) -> Void
    
    @State private var showingNameAlert = false
    @State private var showingCutoffsAlert = false
    
    private var doneButton: some View {
        Button(action: donePressed, label: { Text("Done") })
    }
    
    var body: some View {
        Form {
            Section(header: Text("Course Details")) {
                TextField("Course Name", text: $name)
            }
            .alert(isPresented: $showingNameAlert) {
                Alert(title: Text("Error"), message: Text("Course Name cannot be empty"))
            }
            
            Section(header: Text("Grade Cutoffs")) {
                CutoffsSection($cutoffs)
            }
            .alert(isPresented: $showingCutoffsAlert) {
                Alert(title: Text("Error"), message: Text("Please add at least 1 Grade Cutoff"))
            }
        }
        .navigationBarItems(trailing: doneButton)
    }
    
    private func donePressed() {
        guard !name.isEmpty else {
            showingNameAlert = true
            return
        }
        
        guard !cutoffs.isEmpty else {
            showingCutoffsAlert = true
            return
        }
        
        saveChanges(name, cutoffs)
        presentationMode.wrappedValue.dismiss()
    }
}
