//
//  CategoriesSection.swift
//  GradeCalc
//
//  Created by Aly Hirani on 4/18/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

class Category: Identifiable, Comparable {
    let id: UUID
    
    fileprivate(set) var type: String
    fileprivate(set) var weight: Float
    fileprivate(set) var count: Int
    
    fileprivate var averageWeight: Float { weight / Float(count) }
    
    init(id: UUID = UUID(), type: String, weight: Float, count: Int) {
        self.id = id
        self.type = type
        self.weight = weight
        self.count = count
    }
    
    static func < (a: Category, b: Category) -> Bool {
        a.type < b.type
    }
    
    static func == (a: Category, b: Category) -> Bool {
        a.type == b.type && a.weight == b.weight && a.count == b.count
    }
}

struct CategoriesSection: View {
    @Binding private var categories: [Category]
    
    private var addCategoryButton: some View {
        Button(action: addCategory, label: { Text("Add Grade Category").bold() })
    }
    
    init(_ categories: Binding<[Category]>) {
        _categories = categories
    }
    
    var body: some View {
        List {
            ForEach(categories) { category in
                CategoryView(category) {
                    self.categories.sort()
                }
            }
            .onDelete { o in self.categories.remove(atOffsets: o) }
            
            addCategoryButton
        }
    }
    
    private func addCategory() {
        categories.append(Category(type: "Exams", weight: 25, count: 2))
        categories.sort()
    }
}

private struct CategoryView: View {
    var category: Category
    
    @State var type: String
    @State var weight: String
    @State var count: Int
    
    var doneEditing: () -> Void
    
    @State var showingEditForm = false
    @State var showingTypeAlert = false
    @State var showingWeightAlert = false
    
    init(_ c: Category, doneEditing: @escaping () -> Void) {
        category = c
        _type = State(initialValue: c.type)
        _weight = State(initialValue: String(c.weight))
        _count = State(initialValue: c.count)
        self.doneEditing = doneEditing
    }
    
    var doneButton: some View {
        Button(action: saveChanges, label: { Text("Done").bold() })
    }
    
    var editCategory: some View {
        Form {
            Section(header: Text("Category Details")) {
                HStack {
                    Text("Type")
                    TextField("Quizzes", text: $type)
                        .multilineTextAlignment(.trailing)
                        .frame(maxHeight: .infinity)
                }
                .alert(isPresented: $showingTypeAlert) {
                    Alert(title: Text("Error"), message: Text("Category Type cannot be empty"))
                }
                
                HStack {
                    Text("Weight")
                    TextField("25", text: $weight)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxHeight: .infinity)
                    Text("%")
                        .foregroundColor(weight.isEmpty ? .secondary : .primary)
                        .padding(.leading, -5)
                }
                .alert(isPresented: $showingWeightAlert) {
                    Alert(title: Text("Error"), message: Text("Category Weight must be a valid number"))
                }
            }
            
            Section(header: Text("Count")) {
                Stepper(String(count), value: $count, in: 1...Int.max)
            }
        }
        .navigationBarTitle("Edit Category")
        .navigationBarItems(trailing: doneButton)
        .onDisappear {
            self.type = self.category.type
            self.weight = String(self.category.weight)
            self.count = self.category.count
        }
    }
    
    var body: some View {
        NavigationLink(destination: editCategory, isActive: $showingEditForm) {
            HStack {
                Text(category.type + ":").bold()
                Text(String(category.count))
                Spacer()
                Text(String(format: "%.2f%% each", category.averageWeight))
            }
        }
    }
    
    func saveChanges() {
        guard !type.isEmpty else {
            showingTypeAlert = true
            return
        }
        
        guard let weight = Float(weight) else {
            self.weight = ""
            showingWeightAlert = true
            return
        }
        
        category.type = type
        category.weight = weight
        category.count = count
        
        doneEditing()
        
        showingEditForm = false
    }
}
