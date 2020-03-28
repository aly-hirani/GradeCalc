//
//  AddCourseSheet.swift
//  GradeCalc
//
//  Created by Aly Hirani on 3/26/20.
//  Copyright © 2020 Aly Hirani. All rights reserved.
//

import SwiftUI

struct AddCourseSheet: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    
    @State var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Details")) {
                    TextField("Course Name", text: $name)
                }
            }
            .navigationBarTitle("Add Course")
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                }, trailing: Button(action: {
                    if self.name.isEmpty {
                        self.showingAlert = true
                    } else {
                        let newCourse = Course(context: self.managedObjectContext)
                        newCourse.id = UUID()
                        newCourse.name = self.name
                        do {
                            try self.managedObjectContext.save()
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            fatalError("\(error)")
                        }
                    }
                }) {
                    Text("Done")
            })
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Course Name cannot be empty"), dismissButton: .cancel(Text("Dismiss")))
        }
    }
}

struct AddCourseSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddCourseSheet()
    }
}
