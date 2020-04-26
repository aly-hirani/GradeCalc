//
//  Constants.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/3/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import Foundation
import SwiftUI

enum Constants {
    static let AppUIColor = UIColor.systemTeal
    static let AppColor = Color(AppUIColor)
    
    static let LetterGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-"]
}

struct NavigationHelper<Destination: View>: View {
    var destination: Destination
    var isActive: Binding<Bool>
    
    var body: some View {
        NavigationLink(destination: destination, isActive: isActive) {
            EmptyView()
        }
        .frame(width: 0, height: 0)
        .disabled(true)
        .hidden()
    }
}
