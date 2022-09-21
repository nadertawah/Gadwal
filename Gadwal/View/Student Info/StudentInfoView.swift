//
//  StudentInfoView.swift
//  Gadwal
//
//  Created by nader said on 15/09/2022.
//

import SwiftUI

struct StudentInfoView: View
{
    @Environment(\.dismiss) var dismiss
    @State private var taken = false
    @State private var passed = false
    @State private var isChanged = false
    @State private var isPresentingNext = false
    @State private var isPresentingAlert = false
    @State private var isLoading = false

    @ObservedObject private var VM = StudentInfoVM()
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.gray,Color.GadwalBGColor,Color.GadwalBGColor]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack
            {
                StepsView(stepsCount: 3, currentStepIndex: 0)
                    .frame(width: 100, height: 20, alignment: .center)
                    .padding(.top)
                Text("Your current courses state")
                    .foregroundColor(.white)
                    .fontWeight(Font.Weight.bold)
                GeometryReader
                {
                    geometry in
                    
                    List
                    {
                        ForEach( 0..<VM.student.studentCourses.count , id : \.self)
                        {
                            index in
                            
                            VStack
                            {
                                HStack
                                {
                                    Text(VM.student.studentCourses[index].courseCode)
                                        .font(.system(size: 15))
                                    
                                    Spacer()
                                    
                                    Text(VM.student.studentCourses[index].courseName)
                                }
                                
                                Spacer()
                                
                                HStack
                                {
                                    Toggle("Taken", isOn: $VM.student.studentCourses[index].taken)
                                        .onChange(of: VM.student.studentCourses[index].taken) { _ in self.isChanged = true}
                                    Spacer(minLength: 20)
                                    
                                    Toggle("Passed", isOn: $VM.student.studentCourses[index].passed)
                                        .opacity(VM.student.studentCourses[index].taken ? 1 : 0)
                                        .onChange(of: VM.student.studentCourses[index].passed)
                                    { _ in if(!self.isChanged){self.isChanged = true}}
                                }
                                
                                
                            }
                            .padding()
                        }
                    }
                    .environment(\.defaultMinListRowHeight, geometry.size.height / 4)
                    .onAppear()
                    {
                        UITableView.appearance().backgroundColor = .clear
                    }
                    .onChange(of: $VM.student.studentCourses.count)
                    {
                        _ in
                        isLoading = false
                    }
                }
                HStack
                {
                    Group
                    {
                        Button("Logout")
                        {
                            VM.logout()
                            {
                                dismiss()
                            }
                        }
                        .frame(width: 70, height: 35, alignment: .center)
                        .background(.white)
                        .cornerRadius(20)
                        .padding(20)
                        
                        Spacer()
                        
                        Button("Save")
                        {
                            isChanged = false
                            VM.saveStudent()
                            
                        }
                        .frame(width: 70, height: 35, alignment: .center)
                        .opacity(isChanged ? 1 : 0)
                        .background(isChanged ? .white : Color.GadwalBGColor)
                        .cornerRadius(20)
                        
                        Spacer()
                        
                        Button("Next")
                        {
                            if isChanged
                            {
                                isPresentingAlert = true
                            }
                            else
                            {
                                isPresentingNext = true
                            }
                        }
                        .frame(width: 70, height: 35, alignment: .center)
                        .background(.white)
                        .cornerRadius(20)
                        .padding(20)
                        .alert("You must save changes first!", isPresented: $isPresentingAlert){}
                    }
                    .foregroundColor(.black)
                    
                    NavigationLink("",destination: NavigationLazyView(TableView(VM: TableVM(student: VM.student))), isActive: $isPresentingNext)
                }
            }
            
            if isLoading
            {
                LoadingView()
            }
            
        }
        .navigationBarHidden(true)
        .onAppear()
        {
            if VM.student.studentCourses.isEmpty
            {
                isLoading = true
            }
        }
    }
}

struct StudentInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StudentInfoView()
    }
}
