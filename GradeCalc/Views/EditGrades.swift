//
//  CategoryGrades.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/25/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

private class Grade: Identifiable {
    let index: Int
    var entry: String
    
    init(index: Int, entry: String) {
        self.index = index
        self.entry = entry
    }
}

struct EditGrades: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var category: CourseCategory
    
    @State private var gradesEntered: [Grade] = []
    
    @State private var showingEditGrades = false
    
    private var gradeNumbers: [Float?] {
        var grades = [Float?](repeating: nil, count: category.count)
        for g in category.grades {
            if grades.startIndex <= g.index && g.index < grades.endIndex {
                grades[g.index] = g.grade
            } else {
                moc.delete(g)
                save(context: moc)
            }
        }
        return grades
    }
    
    private var grades: [Grade] {
        gradeNumbers.enumerated().map { index, grade in
            if let grade = grade {
                return Grade(index: index, entry: String(grade))
            } else {
                return Grade(index: index, entry: "")
            }
        }
    }
    
    private var doneButton: some View {
        Button(action: saveChanges, label: { Text("Done").bold() })
    }
    
    private var editButton: some View {
        ZStack {
            Button(action: {
                self.gradesEntered = self.grades
                self.showingEditGrades = true
            }) {
                Text("Enter Grades").bold()
            }
            NavigationHelper(destination: editGrades, isActive: $showingEditGrades)
        }
    }
    
    private var editGrades: some View {
        Form {
            ForEach(gradesEntered) { g in
                HStack {
                    Text("#\(g.index + 1)").bold()
                    Spacer()
                    TextField("100.0", text: .init(get: { g.entry }, set: { e in g.entry = e }))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxHeight: .infinity)
                }
            }
        }
        .navigationBarTitle(category.type)
        .navigationBarItems(trailing: doneButton)
    }
    
    var body: some View {
        let grades = gradeNumbers.compactMap { g in g }
        let average = grades.reduce(0, +) / Float(grades.count)
        
        return Section(header: Text(category.type)) {
            HStack {
                Text("Grades Entered").bold()
                Spacer()
                Text("\(grades.count) of \(category.count)")
            }
            
            HStack {
                Text("Average").bold()
                Spacer()
                if grades.isEmpty {
                    Text("N/A")
                } else {
                    Text(String(format: "%.2f%%", average))
                }
            }
            
            editButton
        }
    }
    
    private func saveChanges() {
        for g in category.grades {
            moc.delete(g)
        }
        
        for g in gradesEntered {
            if let grade = Float(g.entry) {
                category.addToCategoryGrades(.createIn(moc, index: g.index, grade: grade))
            }
        }
        
        save(context: moc)
        
        showingEditGrades = false
    }
}
