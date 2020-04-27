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
    var earned: String
    var possible: String
    
    init(index: Int, earned: String, possible: String) {
        self.index = index
        self.earned = earned
        self.possible = possible
    }
}

struct EditGrades: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var category: CourseCategory
    
    @State private var gradesEntered: [Grade] = []
    
    @State private var showingEditGrades = false
    
    private var gradeNumbers: [(e: Float, p: Float)?] {
        var grades = [(e: Float, p: Float)?](repeating: nil, count: category.count)
        for g in category.grades {
            if grades.startIndex <= g.index && g.index < grades.endIndex {
                grades[g.index] = (g.pointsEarned, g.pointsPossible)
            } else {
                moc.delete(g)
                save(context: moc)
            }
        }
        return grades
    }
    
    private var grades: [Grade] {
        gradeNumbers.enumerated().map { i, g in
            if let g = g {
                return Grade(index: i, earned: String(g.e), possible: String(g.p))
            } else {
                return Grade(index: i, earned: "", possible: String(100.0))
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
                Section(header: Text("#\(g.index + 1)")) {
                    HStack {
                        Text("Points Earned").bold()
                        Spacer()
                        TextField("100.0", text: .init(get: { g.earned }, set: { e in g.earned = e }))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxHeight: .infinity)
                    }
                    HStack {
                        Text("Points Possible").bold()
                        Spacer()
                        TextField("100.0", text: .init(get: { g.possible }, set: { p in g.possible = p }))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxHeight: .infinity)
                    }
                }
            }
        }
        .navigationBarTitle(category.type)
        .navigationBarItems(trailing: doneButton)
    }
    
    var body: some View {
        let grades: [Float] = gradeNumbers.compactMap { grade in
            guard let grade = grade else { return nil }
            return grade.e / grade.p * 100
        }
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
            if let earned = Float(g.earned) {
                let possible = Float(g.possible) ?? 100
                category.addToCategoryGrades(.createIn(moc, index: g.index, earned: earned, possible: possible))
            }
        }
        
        save(context: moc)
        
        showingEditGrades = false
    }
}
