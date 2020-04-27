//
//  CutoffsSection.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/31/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

class Cutoff: Identifiable, Comparable {
    let id: UUID
    
    fileprivate var letterIndex: Int
    fileprivate var number: Float
    
    var letterGrade: String { Constants.LetterGrades[letterIndex] }
    var numberGrade: Float { number }
    
    init(id: UUID = UUID(), letterIndex: Int, number: Float) {
        self.id = id
        self.letterIndex = letterIndex
        self.number = number
    }
    
    static func < (a: Cutoff, b: Cutoff) -> Bool {
        a.letterIndex < b.letterIndex
    }
    
    static func == (a: Cutoff, b: Cutoff) -> Bool {
        a.letterIndex == b.letterIndex && a.number == b.number
    }
}

struct CutoffsSection: View {
    @Binding private var cutoffs: [Cutoff]
    
    @State private var letterIndicesLeft: [Int]
    
    private var addCutoffButton: some View {
        Button(action: addCutoff, label: { Text("Add Grade Cutoff").bold() })
    }
    
    init(_ cutoffs: Binding<[Cutoff]>) {
        _cutoffs = cutoffs
        _letterIndicesLeft = State(initialValue: {
            Set(Constants.LetterGrades.indices).subtracting(cutoffs.wrappedValue.map { c in c.letterIndex }).sorted()
        }())
    }
    
    var body: some View {
        List {
            ForEach(cutoffs) { cutoff in
                CutoffView(cutoff, indices: self.$letterIndicesLeft) {
                    self.cutoffs.sort()
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
        cutoffs.sort()
    }
    
    private func deleteCutoffs(offsets: IndexSet) {
        letterIndicesLeft += offsets.map { i in cutoffs[i].letterIndex }
        letterIndicesLeft.sort()
        cutoffs.remove(atOffsets: offsets)
    }
}

private struct CutoffView: View {
    var cutoff: Cutoff
    
    @Binding var letterIndicesLeft: [Int]
    
    @State var selectedIndex: Int
    @State var numberEntered: String
    
    var doneEditing: () -> Void
    
    @State var showingEditForm = false
    @State var showingAlert = false
    
    var currentIndices: [Int] { (letterIndicesLeft + [cutoff.letterIndex]).sorted() }
    
    init(_ c: Cutoff, indices: Binding<[Int]>, doneEditing: @escaping () -> Void) {
        cutoff = c
        _letterIndicesLeft = indices
        _selectedIndex = State(initialValue: c.letterIndex)
        _numberEntered = State(initialValue: String(c.number))
        self.doneEditing = doneEditing
    }
    
    var doneButton: some View {
        Button(action: saveChanges, label: { Text("Done").bold() })
    }
    
    var editCutoff: some View {
        Form {
            Section(header: Text("Letter Grade")) {
                Picker("Select from the following", selection: $selectedIndex) {
                    ForEach(currentIndices, id: \.self) { i in
                        Text(Constants.LetterGrades[i])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity)
            }
            
            Section(header: Text("Number Grade")) {
                HStack {
                    Spacer()
                    TextField("100.0", text: $numberEntered)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("%")
                        .foregroundColor(numberEntered.isEmpty ? .secondary : .primary)
                        .padding(.leading, -5)
                }
            }
        }
        .navigationBarTitle("Edit Cutoff")
        .navigationBarItems(trailing: doneButton)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a valid number"))
        }
        .onDisappear {
            self.selectedIndex = self.cutoff.letterIndex
            self.numberEntered = String(self.cutoff.number)
        }
    }
    
    var body: some View {
        NavigationLink(destination: editCutoff, isActive: $showingEditForm) {
            HStack {
                Text(Constants.LetterGrades[cutoff.letterIndex]).bold()
                Spacer()
                Text(String(cutoff.number) + "%")
            }
        }
    }
    
    func saveChanges() {
        guard let number = Float(numberEntered) else {
            numberEntered = String(cutoff.number)
            showingAlert = true
            return
        }
        
        cutoff.number = number
        if cutoff.letterIndex != selectedIndex {
            letterIndicesLeft = currentIndices
            letterIndicesLeft.removeAll { i in i == selectedIndex }
            cutoff.letterIndex = selectedIndex
        }
        
        doneEditing()
        
        showingEditForm = false
    }
}
