//
//  SchedulesView.swift
//  Gadwal
//
//  Created by nader said on 17/09/2022.
//

import SwiftUI

struct SchedulesView: View
{
    @Environment(\.dismiss) var dismiss
    @ObservedObject var VM : ScheduleVM
    @State private var isLoading = false
    
    init(availableCourses : [AvailableCourse],schedulesCreditHours : Float,student:Student,dbInstance : DBProtocol)
    {
        self.VM = ScheduleVM(availableCourses: availableCourses, schedulesCreditHours: schedulesCreditHours, student: student, dbInstance: dbInstance)
    }
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.gray,Color.GadwalBGColor,Color.GadwalBGColor]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack
            {
                StepsView(stepsCount: 3, currentStepIndex: 2)
                    .frame(width: 100, height: 20, alignment: .center)
                    .padding(.top)
                
                Text("Generated schedules")
                    .foregroundColor(.white)
                    .fontWeight(Font.Weight.bold)
                
                List
                {
                    ForEach( 0..<VM.currentSchedule.count , id : \.self)
                    {
                        index in
                        
                        VStack
                        {
                            HStack
                            {
                                Text(String(format:"%.2f",VM.currentSchedule[index].credits))
                                
                                Spacer()
                                
                                Text(VM.currentSchedule[index].courseCode)
                            }
                            
                            Text(VM.currentSchedule[index].courseName)
                            Text(VM.currentSchedule[index].prof)
                            
                            HStack
                            {
                                Text(Helper.getTimeLabelStr(from: VM.currentSchedule[index].from, to: VM.currentSchedule[index].to) )
                                
                                Spacer()
                                
                                Text(VM.currentSchedule[index].day)
                            }
                        }
                    }
                }
                .onAppear()
                {
                    UITableView.appearance().backgroundColor = .clear
                }
                .onChange(of: VM.currentIndex)
                {
                    _ in
                    isLoading = false
                }
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
                        .foregroundColor(.black)
                        
                        Spacer()
                        
                        Stepper
                        {
                            Text("\(VM.currentIndex)/\(VM.allSchedules.isEmpty ? 0 : VM.allSchedules.count-1)")
                        } onIncrement:
                        {
                            VM.changeScheduleIndex(isIncreasing: true)
                        } onDecrement:
                        {
                            VM.changeScheduleIndex(isIncreasing: false)
                        }
                        .fixedSize()
                        .frame(height: 35, alignment: .center)
                        .padding(.horizontal, 10)
                        .background(.white)
                    }
                    .cornerRadius(20)

                }
                .padding(20)
            }
            
            if isLoading
            {
                LoadingView()
            }
        }
        .navigationBarHidden(true)
        .onAppear()
        {
            isLoading = true
        }
    }
}

