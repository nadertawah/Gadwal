//
//  TableView.swift
//  Gadwal
//
//  Created by nader said on 15/09/2022.
//

import SwiftUI

struct TableView: View
{
    @Environment(\.dismiss) var dismiss
    @State private var isPresentingNext = false
    @State private var isPresentingCreditsAlert = false
    @State private var credits = ""
    @State private var creditsAreValid = false
    @State private var isPresentingErrorAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false

    @ObservedObject var VM : TableVM
    
    init(student : Student,dbInstance : DBProtocol)
    {
        self.VM = TableVM(student: student, dbInstance: dbInstance)
    }
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.gray,Color.GadwalBGColor,Color.GadwalBGColor]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack
            {
                StepsView(stepsCount: 3, currentStepIndex: 1)
                    .frame(width: 100, height: 20, alignment: .center)
                    .padding(.top)
                
                Text("Available courses for the semester")
                    .foregroundColor(.white)
                    .fontWeight(Font.Weight.bold)
                
                List
                {
                    ForEach(0..<VM.availableCourses.count , id : \.self)
                    {
                        index in
                        
                        let type = VM.availableCourses[index].type
                        let color = Color.getTypeColor(type: type, subDepartmentNumber: VM.student.subDepartments.firstIndex(of: type), mandatory: VM.availableCourses[index].required)
                        
                        VStack
                        {
                            HStack
                            {
                                Text(VM.availableCourses[index].courseCode)
                                    .font(.system(size: 15))
                                
                                Spacer()

                                Text(VM.availableCourses[index].courseName)
                                    
                            }
                            .foregroundColor(color)
                            
                            Spacer()
                            
                            Text(String(format:"%.f",VM.availableCourses[index].credits) + " ساعة معتمدة ")

                            Text(VM.availableCourses[index].prof)
                                
                            Picker("",selection: $VM.availableCourses[index].desiredIndex )
                            {
                                Text("Neutral").tag(0)
                                Text("Desired").tag(1)
                                Text("Undesired").tag(2)
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: VM.availableCourses[index].desiredIndex)
                            {
                                if $0 == 1
                                {
                                    var creditCounter = VM.availableCourses[index].credits
                                    for indx in 0..<VM.availableCourses.count      //check if there's a conflict
                                    {
                                        if(indx != index && VM.availableCourses[indx].desiredIndex == 1)   //not the same course and also desired
                                        {
                                            alertMessage = ""
                                            creditCounter += VM.availableCourses[indx].credits
                                            if(VM.availableCourses[indx].courseCode.uppercased() == VM.availableCourses[index].courseCode.uppercased())
                                            {
                                                alertMessage = "Duplicate course selected.\n\(VM.availableCourses[index].courseName)"
                                            }
                                            else if(creditCounter > 18)
                                            {
                                                alertMessage = "These desired courses can't be in the same schedule.\nExceeded credit hours limit (18)."
                                            }
                                            
                                            else if(VM.availableCourses[indx].isConflicted(with : VM.availableCourses[index]))
                                            {
                                                alertMessage = "\(VM.availableCourses[indx].courseName)\nand\n\(VM.availableCourses[index].courseName)\nCan't be in the same schedule.\nTime Conflict!"
                                            }
                                            if(alertMessage.count > 1)
                                            {
                                                VM.availableCourses[index].desiredIndex = 0 //reset to neutral
                                                isPresentingErrorAlert = true
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                            HStack
                            {
                                Text(Helper.getTimeLabelStr(from: VM.availableCourses[index].from, to: VM.availableCourses[index].to))
                                    .font(.system(size: 15))

                                Spacer()

                                Text(VM.availableCourses[index].day)
                            }
                        }
                        .foregroundColor(color)
                        .padding()
                        
                    }
                }
                .onAppear()
                {
                    UITableView.appearance().backgroundColor = .clear
                }
                .onChange(of: $VM.availableCourses.count)
                {
                    _ in
                    isLoading = false
                }
                .lineLimit(1)
                .environment(\.defaultMinListRowHeight, 170)
                .minimumScaleFactor(0.3)
                
                
                HStack
                {
                    Group
                    {
                        Button("Back")
                        {
                            dismiss()
                        }
                        .frame(width: 70, height: 35, alignment: .center)
                        .background(.white)
                        
                        Spacer()
                        
                        Button("Next")
                        {
                            withAnimation
                            {
                                isPresentingCreditsAlert = true

                            }
                        }
                        .frame(width: 70, height: 35, alignment: .center)
                        .background(.white)
                        
                    }
                    .foregroundColor(.black)
                    .cornerRadius(20)
                    .padding(20)

                    NavigationLink("",destination: NavigationLazyView(SchedulesView(availableCourses: VM.availableCourses, schedulesCreditHours: Float(credits)!, student: VM.student,dbInstance:VM.dbInstance)) , isActive: $isPresentingNext)
                }
            }
            .blur(radius: isPresentingCreditsAlert ? 20 : 0)
            .alert(alertMessage, isPresented: $isPresentingErrorAlert){}
            
            
            CustomAlert(textEntered: $credits, showingAlert: $isPresentingCreditsAlert, isValid: $creditsAreValid,okPressed: $isPresentingNext, message: "How many credit hours do you want in a schedule?")
                                .opacity(isPresentingCreditsAlert ? 1 : 0)
            
            if isLoading
            {
                LoadingView()
            }
            
            SideMenu(subDepartments: VM.student.subDepartments)
                
        }
        .navigationBarHidden(true)
        .onAppear()
        {
            if VM.availableCourses.isEmpty
            {
                isLoading = true
            }
        }
        
    }
}
