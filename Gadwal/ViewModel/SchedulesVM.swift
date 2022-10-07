//
//  SchedulesVM.swift
//  Gadwal
//
//  Created by nader said on 17/09/2022.
//

import Foundation
import SwiftUI

class ScheduleVM : ObservableObject
{
   
    init(availableCourses : [AvailableCourse],schedulesCreditHours : Float,student:Student,dbInstance : DBProtocol)
    {
        self.dbInstance = dbInstance
        self.availableCourses = availableCourses
        self.schedulesCreditHours = schedulesCreditHours
        self.student = student
        
        getSchedulesArr()
    }
    
    //MARK: - Var(s)
    @Published var currentSchedule = [AvailableCourse]()
    var allSchedules = [[AvailableCourse]]()
    var availableCourses = [AvailableCourse]()
    var schedulesCreditHours : Float = 0
    var student:Student = Student(id: "", name: "", department: "", email: "", subDepartments: [], studentCourses: [], courseTypeStatus: [])
    var currentIndex : Int = -1
    var dbInstance : DBProtocol

    //MARK: - intent(s)
    func changeScheduleIndex(isIncreasing:Bool)
    {
        if allSchedules.count > 0
        {
            currentIndex = currentIndex < (allSchedules.count - 1) && isIncreasing ? currentIndex + 1 : currentIndex > 0 && !isIncreasing ? currentIndex - 1 : 0
            currentSchedule = allSchedules[currentIndex]
        }
    }
    
    //MARK: - Helper Funcs
    func getSchedulesArr()
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            [weak self] in
            guard let self = self else {return}
            
            var neutralCourses = [AvailableCourse]() , desiredCourses = [AvailableCourse]() , creditResidue = self.schedulesCreditHours, neutralCoursesCreditSum:Float = 0
            
            self.availableCourses.forEach //remove undesired courses and sort
            {
                course in
                if course.desiredIndex == 1
                {
                    desiredCourses.append(course)
                    creditResidue -= course.credits
                }
                else if course.desiredIndex == 0
                {
                    neutralCourses.append(course)
                    neutralCoursesCreditSum += course.credits
                }
            }
            
            //group conflicted courses togther
            let conflictedGroups = self.groupConflicted(neutralCourses: neutralCourses)
            
            //seperate groups with count of 1 from groups with higher count
            var firstGroups = [[AvailableCourse]]()  //groups with lengths of more than one
            ,secondGroups = [AvailableCourse]()  //list of groups with lengths of one
            
            for group in conflictedGroups
            {
                if (group.count > 1) {firstGroups.append(group)}
                else {secondGroups.append(group[0])}
            }
            
            //create combinations of firstGroups and adding secondGroups to every one of those combinations
            let groupCombinations = self.createCombinations(groups: firstGroups, singles: secondGroups)
            
            //get max and minimum number of courses in one schedule besides desired courses
            let minAndMax = self.getMinAndMax(firstGroups: firstGroups, secondGroups: secondGroups, creditResidue: creditResidue)
            
            if(minAndMax.0 != -1 && minAndMax.1 != -1)
            {
                //create bits mask using max and min number of courses
                //lower and higher bound of binary numbers with N(courses count) bits
                for i in minAndMax.0...minAndMax.1
                {
                    let mask = self.buildMask(maskLength: conflictedGroups.count, bitsCount: i)
                    for j in 0..<groupCombinations.count
                    {
                        var changedIndxs = [Int]()
                        for q in 0..<groupCombinations[0].count
                        {
                            if (groupCombinations[0][q].courseCode != groupCombinations[j][q].courseCode)
                            {
                                changedIndxs.append(q)
                            }
                        }
                        let filteredMask = self.filterMask(mask: mask, changedIndxs: changedIndxs)
                        for k in 0..<filteredMask.count
                        {
                            var sum :Float = 0
                            var temp = [AvailableCourse]()
                            for l in  0..<conflictedGroups.count
                            {
                                if (filteredMask[k][l] == "1")
                                {
                                    temp.append(groupCombinations[j][l])
                                    if (groupCombinations[j][l].type != "متطلبات جامعة")
                                    {
                                        sum += groupCombinations[j][l].credits
                                    }
                                }
                            }
                            if (sum == creditResidue)
                            {
                                self.allSchedules.append(temp)
                            }
                        }
                    }
                }
                
                //add desired courses to schedules and filter conflicted ones
                self.filterAddDesiredToSchedules(desiredCourses)
                
                //remove schedules which will result in more than one excess course in any type
                self.filterOverCreditSchedules()
                
                DispatchQueue.main.async
                {
                    self.currentSchedule = !self.allSchedules.isEmpty ? self.allSchedules[0] : []
                    self.currentIndex = 0
                }
            }
            else
            {
                self.allSchedules.removeAll()
            }
            
        }
    }
    
    func groupConflicted(neutralCourses: [AvailableCourse]) -> [[AvailableCourse]]
    {
        var groups = [[AvailableCourse]]()
        
        for course in neutralCourses
        {
            var groupIndex = -1
            for i in  0..<groups.count
            {
                var isConflictedWithGroup = true
                for j in 0..<groups[i].count
                {
                    if !course.isConflicted(with: groups[i][j])
                    {
                        isConflictedWithGroup = false
                        break
                    }
                }
                
                if isConflictedWithGroup
                {
                    groupIndex = i
                    break
                }
            }
            
            if groupIndex == -1
            {
                var newGroup = [AvailableCourse]()
                newGroup.append(course)
                groups.append(newGroup)
            }
            else
            {
                groups[groupIndex].append(course)
            }
        }
        return groups
    }
    
    func createCombinations(groups : [[AvailableCourse]], singles:[AvailableCourse]) -> [[AvailableCourse]]
    {
        var groupCombinations = [[AvailableCourse]]()
        var groupsLengths = [Int]()                                  //groups lengths
        var permCount = 1
        for i in  0..<groups.count
        {
            groupsLengths.append(groups[i].count)
            permCount *= groups[i].count
        }
        
        var indexes = GroupCombinationsIndexer(lengths: groupsLengths)
        for _ in 0..<permCount
        {
            var temp = [AvailableCourse]()
            for j in  0..<groups.count
            {
                temp.append(groups[j][indexes.indexes[j]])
            }
            temp.append(contentsOf: singles)
            groupCombinations.append(temp)
            
            indexes.nextCombinations();
        }
        return groupCombinations
    }
    
    func getMinAndMax(firstGroups:[[AvailableCourse]],secondGroups:[AvailableCourse],creditResidue:Float) -> (Int, Int)
    {
        var max = 0, min = 0, sum :Float = 0   //getting max and minimum number of courses in one schedule besides desired courses
        var GroupsMax = [Float]() , GroupsMin = [Float]()
        for group in firstGroups
        {
            var groupMax : Float = 0
            var groupMin : Float = (group.first?.credits)!
            for item in group
            {
                if(item.credits > groupMax) {groupMax = item.credits}
                if(item.credits < groupMin) {groupMin = item.credits}
            }
            GroupsMax.append(groupMax)
            GroupsMin.append(groupMin)
        }
        for item in secondGroups
        {
            GroupsMax.append(item.credits)
            GroupsMin.append(item.credits)
        }
        GroupsMax.sort {(x, y) -> Bool in x >= y}
        GroupsMin.sort {(x, y) -> Bool in x <= y}
        
        while(sum < creditResidue)
        {
            if(GroupsMin.count == max)
            {
                break
            }
            sum += GroupsMin[max]
            max += 1
        }
        if(sum > creditResidue){max -= 1}
        
        sum = 0
        while (sum < creditResidue)
        {
            if(GroupsMax.count == min)
            {
                min = -1
                break
            }
            
            sum += GroupsMax[min]
            min += 1
        }
        
        return (min,max)
    }
    
    func buildMask(maskLength:Int,bitsCount:Int) -> [String]
    {
        let lowerBound:Int = Int(powf(Float(2),Float(bitsCount))) - 1                     //lower bound (decimal)
        var higherBound = 0
        
        var mskLength = maskLength
        for _ in 0..<bitsCount
        {
            higherBound += Int(powf(Float(2),Float(mskLength) - 1))
            mskLength -= 1
        }
        
        var mask = [String]()
        
        for j in lowerBound...higherBound
        {
            let str = pad(string: String(j, radix: 2) , toSize: maskLength)
            
            if (bitsChecker(str: str, bits: bitsCount))
            {
                mask.append(str);
            }
        }
        return mask;
    }
    
    func pad(string : String, toSize: Int) -> String
    {
        var padded = string
        for _ in 0..<(toSize - string.count)
        {
            padded = "0" + padded
        }
        return padded
    }
    
    func bitsChecker(str:String,bits:Int) -> Bool
    {
        var count = 0
        for i in  0..<str.count
        {
            if (str[i] == "1")
            {
                count += 1
            }
        }
        return count == bits;
    }
    
    func filterMask(mask:[String],changedIndxs:[Int]) ->[String]
    {
        //returns a mask for an array of combinations without repetition
        if (changedIndxs.count == 0) {return mask}
        var filteredMask = [String]()
        for i in 0..<mask.count
        {
            var valid = true
            for j in 0..<changedIndxs.count
            {
                valid = valid && mask[i][changedIndxs[j]] == "1"
            }
            if (valid){ filteredMask.append(mask[i])}
        }
        return filteredMask;
    }
    
    func filterAddDesiredToSchedules(_ desiredCourses: [AvailableCourse])
    {
        for i in 0..<allSchedules.count
        {
            allSchedules[i].append(contentsOf: desiredCourses)
        }
        filterConflictedSchedule()
    }
    
    func filterConflictedSchedule()
    {
        var toBeRemoved : Bool
        for i in (0..<allSchedules.count).reversed()
        {
            toBeRemoved = false;
            for  k in 0..<allSchedules[i].count
            {
                for j in (k+1..<allSchedules[i].count).reversed()
                {
                    if (allSchedules[i][k].isConflicted(with: allSchedules[i][j]) || allSchedules[i][k].courseCode == allSchedules[i][j].courseCode)
                    {
                        toBeRemoved = true
                    }
                }
                if (toBeRemoved)
                {
                    allSchedules.remove(at: i)
                    break
                }
            }
        }
    }
    
    func filterOverCreditSchedules()
    {
        let types = self.student.courseTypeStatus
        for i in (0..<allSchedules.count).reversed()
        {
            for j in 0..<types.count
            {
                if(types[j].required == false)
                {
                    var sheduleTypeSum:Float = 0
                    var credits = [Float]()
                    for k in 0..<allSchedules[i].count
                    {
                        if(types[j].type == allSchedules[i][k].type && allSchedules[i][k].required == false)
                        {
                            credits.append(allSchedules[i][k].credits)
                            sheduleTypeSum += allSchedules[i][k].credits
                        }
                    }
                    if (credits.count > 1 && types[j].takenHours + sheduleTypeSum > types[j].maxHours )
                    {
                        if (types[j].takenHours + sheduleTypeSum - credits.min()! >= types[j].maxHours)
                        {
                            allSchedules.remove(at:i)
                            break
                        }
                    }
                }
            }
        }
    }
}
