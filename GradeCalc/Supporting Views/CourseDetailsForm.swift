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
    @State private var showingWeightAlert = false
    
    private var doneButton: some View {
        Button(action: donePressed, label: { Text("Done").bold() })
    }
    
    private var weightErrorOptions: [ActionSheet.Button] {
        let refactor = ActionSheet.Button.default(Text("Refactor Weights"), action: refactorWeights)
        let save = ActionSheet.Button.default(Text("Save Anyways"), action: saveAndReturn)
        let cancel = ActionSheet.Button.cancel()
        return [refactor, save, cancel]
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
        .actionSheet(isPresented: $showingWeightAlert) {
            ActionSheet(title: Text("Total Weight is not 100"), buttons: weightErrorOptions)
        }
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
        
        let totalWeight = categories.reduce(0, { r, c in r + c.weight })
        guard (totalWeight * 100).rounded() / 100 == 100 else {
            showingWeightAlert = true
            return
        }
        
        saveAndReturn()
    }
    
    private func refactorWeights() {
        let totalWeight = categories.reduce(0, { r, c in r + c.weight })
        categories.forEach { c in c.refactorWeight(totalCourseWeight: totalWeight) }
        saveAndReturn()
    }
    
    private func saveAndReturn() {
        saveChanges(name, cutoffs, categories)
        presentationMode.wrappedValue.dismiss()
    }
}
