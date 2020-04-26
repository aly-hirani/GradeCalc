//
//  ViewCourse.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/29/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct ViewCourse: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var course: Course
    
    @State private var showingEditCourse = false
    @State private var showingCalculations = false
    
    private var editButton: some View {
        Button(action: {
            self.showingEditCourse = true
        }) {
            Text("Edit").bold()
        }
    }
    
    private var calculateButton: some View {
        Button(action: {
            self.showingCalculations = true
        }) {
            Text("Calculate my Grades").bold().frame(maxWidth: .infinity)
        }
    }
    
    private var editCourse: some View {
        EditCourse(course: course).environment(\.managedObjectContext, moc)
    }
    
    var body: some View {
        VStack {
            Form {
                calculateButton
                
                ForEach(course.categories) { category in
                    if !category.isDeleted {
                        EditGrades(category: category).environment(\.managedObjectContext, self.moc)
                    }
                }
            }
            
            NavigationHelper(destination: editCourse, isActive: $showingEditCourse)
            NavigationHelper(destination: Calculations(course: course), isActive: $showingCalculations)
        }
        .navigationBarTitle(course.name)
        .navigationBarItems(trailing: editButton)
    }
}

private struct Calculations: View {
    @ObservedObject var course: Course
    
    var body: some View {
        var accumulatedPoints: Float = 0
        var accumulatedWeight: Float = 0
        var totalWeight: Float = 0
        
        for c in course.categories {
            let individualWeight = c.weight / Float(c.count)
            for g in c.grades {
                accumulatedPoints += (g.grade / 100) * individualWeight
            }
            accumulatedWeight += individualWeight * Float(c.grades.count)
            totalWeight += c.weight
        }
        
        let calc: (Float) -> Float = { n in
            let remainingPoints = (n / 100) * totalWeight - accumulatedPoints
            let remainingWeight = totalWeight - accumulatedWeight
            return remainingPoints / remainingWeight * 100
        }
        
        return Form {
            ForEach(course.cutoffs) { cutoff in
                HStack {
                    Text(cutoff.letter).bold()
                    Spacer()
                    Text(String(format: "%.2f%%", calc(cutoff.number)))
                }
            }
        }
        .navigationBarTitle("Calculations")
    }
}
