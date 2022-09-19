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

    @ObservedObject var VM = TableVM(student: Student(id: "", name: "", department: "", email: "", subDepartments: [], studentCourses: [], courseTypeStatus: []))
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.gray,Color.GadwalBGColor,Color.GadwalBGColor]), startPoint: .top, endPoint: .bottom)
            
            VStack
            {
               
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
                                Text(VM.availableCourses[index].courseName)

                                Spacer()

                                Text(VM.availableCourses[index].courseCode)
                                
                            }
                            .foregroundColor(color)
                            
                            Spacer()
                            
                            Text(String(format:"%.2f",VM.availableCourses[index].credits) + " ساعة معتمدة ")

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

                                Spacer()

                                Text(VM.availableCourses[index].day)
                            }
                        }.foregroundColor(color)
                        
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
                
                Text("متطلبات جامعة")
                    .foregroundColor(.gray)
                
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        Text("اختياري تخدم التخصص")
                            .foregroundColor(.color1)
                        Text("اختياري متطلبات كلية")
                            .foregroundColor(.color2)
                        Text("اختيارى " + VM.student.subDepartments[0] )
                            .foregroundColor(.color3)
                        Text(VM.student.subDepartments.count > 1 ? "اختيارى " + VM.student.subDepartments[1] : "اختيارى "   )
                            .foregroundColor(.color4)
                            .opacity(VM.student.subDepartments.count > 1 ? 1 : 0)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing)
                    {
                        Text("اجباري تخدم التخصص")
                            .foregroundColor(.color5)
                        Text("اجباري متطلبات كلية")
                            .foregroundColor(.color6)
                        Text("اجبارى " + VM.student.subDepartments[0])
                            .foregroundColor(.color7)
                        Text(VM.student.subDepartments.count > 1 ? "اجبارى " + VM.student.subDepartments[1] : "اجبارى ")
                            .foregroundColor(.color8)
                            .opacity(VM.student.subDepartments.count > 1 ? 1 : 0)
                    }
                }
                .padding(.horizontal)
                .lineLimit(1)
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    NavigationLink("",destination: NavigationLazyView(SchedulesView(VM: ScheduleVM(availableCourses: VM.availableCourses, schedulesCreditHours: Float(credits)!, student: VM.student))) , isActive: $isPresentingNext)
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

struct TableView_Previews: PreviewProvider
{
    static var previews: some View
    {
        TableView()
    }
}
