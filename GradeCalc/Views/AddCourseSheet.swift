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
    
    var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    var doneButton: some View {
        Button(action: {
            if self.name.isEmpty {
                self.showingAlert = true
            } else {
                let course = Course(context: self.managedObjectContext)
                course.construct(name: self.name)
                save(context: self.managedObjectContext)
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Done")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Details")) {
                    TextField("Course Name", text: $name)
                }
            }
            .navigationBarTitle("Add Course")
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
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
