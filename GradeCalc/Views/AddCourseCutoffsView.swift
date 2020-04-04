//
//  AddCourseCutoffsView.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/31/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

class Cutoff: ObservableObject, Identifiable {
    @Published fileprivate var letterIndex: Int
    @Published fileprivate var number: Float
    
    func letterGrade() -> String { Constants.letterGrades[letterIndex] }
    func numberGrade() -> Float { number }
    
    fileprivate init(letterIndex: Int, number: Float) {
        self.letterIndex = letterIndex
        self.number = number
    }
}

struct AddCourseCutoffsView: View {
    @Binding var cutoffs: [Cutoff]
    
    @State private var letterIndicesLeft = [Int](Constants.letterGrades.indices)
    
    private var addCutoffButton: some View {
        Button(action: addCutoff, label: { Text("Add Grade Cutoff") })
    }
    
    var body: some View {
        List {
            ForEach(cutoffs) { cutoff in
                CutoffView(cutoff, indices: self.$letterIndicesLeft) {
                    self.cutoffs.sort { a, b in a.letterIndex < b.letterIndex }
                }
            }
            .onDelete(perform: deleteCutoffs)
            if !letterIndicesLeft.isEmpty {
                addCutoffButton
            }
        }
    }
    
    private func addCutoff() {
        let nextInd = letterIndicesLeft.remove(at: 0)
        let prevNum = nextInd == 0 ? 100 : cutoffs[nextInd - 1].number
        cutoffs.append(Cutoff(letterIndex: nextInd, number: prevNum - 5))
        cutoffs.sort { a, b in a.letterIndex < b.letterIndex }
    }
    
    private func deleteCutoffs(offsets: IndexSet) {
        for index in offsets {
            letterIndicesLeft.append(cutoffs[index].letterIndex)
        }
        letterIndicesLeft.sort()
        cutoffs.remove(atOffsets: offsets)
    }
}

private struct CutoffView: View {
    @ObservedObject var cutoff: Cutoff
    
    @Binding var letterIndicesLeft: [Int]
    
    var onIndexChange: () -> Void
    
    @State var selectedIndex: Int
    @State var numberEntered: String
    
    @State var showingEditForm = false
    @State var showingAlert = false
    
    var currentIndices: [Int] { (letterIndicesLeft + [cutoff.letterIndex]).sorted() }
    
    init(_ c: Cutoff, indices: Binding<[Int]>, onIndexChange perform: @escaping () -> Void) {
        cutoff = c
        _letterIndicesLeft = indices
        _selectedIndex = State(initialValue: c.letterIndex)
        _numberEntered = State(initialValue: String(c.number))
        onIndexChange = perform
    }
    
    var doneButton: some View {
        Button(action: saveChanges, label: { Text("Done") })
    }
    
    var editCutoffView: some View {
        Form {
            Section(header: Text("Letter Grade")) {
                Picker("Select from the following", selection: $selectedIndex) {
                    ForEach(currentIndices, id: \.self) { i in
                        Text(Constants.letterGrades[i])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity)
            }
            
            Section(header: Text("Number Grade")) {
                TextField("Enter number here", text: $numberEntered)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationBarTitle("Edit Cutoff")
        .navigationBarItems(trailing: doneButton)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a valid number"), dismissButton: .cancel(Text("Dismiss")))
        }
        .onDisappear {
            self.selectedIndex = self.cutoff.letterIndex
            self.numberEntered = String(self.cutoff.number)
        }
    }
    
    var body: some View {
        NavigationLink(destination: editCutoffView, isActive: $showingEditForm) {
            HStack {
                Text(Constants.letterGrades[cutoff.letterIndex])
                Spacer()
                Text(String(cutoff.number))
            }
        }
    }
    
    func saveChanges() {
        if let number = Float(numberEntered) {
            cutoff.number = number
            if cutoff.letterIndex != selectedIndex {
                letterIndicesLeft = currentIndices
                letterIndicesLeft.removeAll { i in i == selectedIndex }
                cutoff.letterIndex = selectedIndex
                onIndexChange()
            }
            showingEditForm = false
        } else {
            numberEntered = String(cutoff.number)
            showingAlert = true
        }
    }
}
