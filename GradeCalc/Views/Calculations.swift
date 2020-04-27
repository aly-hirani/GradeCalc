//
//  Calculations.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct Calculations: View {
    @ObservedObject var course: Course
    
    var body: some View {
        var accumulatedPoints: Float = 0
        var accumulatedWeight: Float = 0
        var totalWeight: Float = 0
        
        for c in course.categories {
            let individualWeight = c.weight / Float(c.count)
            for g in c.grades {
                accumulatedPoints += g.pointsEarned / g.pointsPossible * individualWeight
            }
            accumulatedWeight += individualWeight * Float(c.grades.count)
            totalWeight += c.weight
        }

        let calc: (Float) -> Float = { cutoff in
            if accumulatedWeight == totalWeight {
                return cutoff
            } else {
                return (cutoff / 100 * totalWeight - accumulatedPoints) / (totalWeight - accumulatedWeight) * 100
            }
        }
        
        let canCalculate = 0 < accumulatedWeight && accumulatedWeight < totalWeight
        
        return Form {
            Section(header: Text("Course Info")) {
                if accumulatedWeight <= 0 {
                    Text("No Grades Entered Yet").bold()
                } else if accumulatedWeight >= totalWeight {
                    Text("All Grades Entered").bold()
                    HStack {
                        Text("Course Average").bold()
                        Spacer()
                        Text(String(format: "%.2f%%", accumulatedPoints / accumulatedWeight * 100))
                    }
                } else {
                    HStack {
                        Text("Average of Grades Entered").bold()
                        Spacer()
                        Text(String(format: "%.2f%%", accumulatedPoints / accumulatedWeight * 100))
                    }
                    
                    HStack {
                        Text("Remaining Weight").bold()
                        Spacer()
                        Text(String(format: "%.2f", totalWeight - accumulatedWeight))
                    }
                    
                    HStack {
                        Text("Total Weight").bold()
                        Spacer()
                        Text(String(format: "%.2f", totalWeight))
                    }
                }
            }
            
            Section(header: Text(canCalculate ? "Averages Necessary for Remaining Grades" : "Course Cutoffs")) {
                ForEach(course.cutoffs) { cutoff in
                    HStack {
                        Text(cutoff.letter).bold()
                        Spacer()
                        Text(String(format: "%.2f%%", calc(cutoff.number)))
                    }
                }
            }
        }
        .navigationBarTitle("Calculations")
    }
}
