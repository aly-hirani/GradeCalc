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
    @State var categories: [Category]
    
    var saveChanges: (String, [Cutoff], [Category]) -> Void
    
    @State private var showingNameAlert = false
    @State private var showingCutoffsAlert = false
    @State private var showingCategoriesAlert = false
    
    private var doneButton: some View {
        Button(action: donePressed, label: { Text("Done").bold() })
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
            
            Section(header: Text("Grade Categories")) {
                CategoriesSection($categories)
            }
            .alert(isPresented: $showingCategoriesAlert) {
                Alert(title: Text("Error"), message: Text("Please add at least 1 Grade Category"))
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
        
        guard !categories.isEmpty else {
            showingCategoriesAlert = true
            return
        }
        
        saveChanges(name, cutoffs, categories)
        presentationMode.wrappedValue.dismiss()
    }
}
