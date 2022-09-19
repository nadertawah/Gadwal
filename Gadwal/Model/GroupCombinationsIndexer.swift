//
//  GroupCombinationsIndexer.swift
//  Gadwal
//
//  Created by nader said on 17/09/2022.
//

import Foundation

struct GroupCombinationsIndexer
{
    var  lengths : [Int], indexes : [Int]
    init(lengths : [Int])
    {
        self.lengths = lengths
        indexes = [Int]()
        for _ in 0..<lengths.count
        {
            indexes.append(0)
        }
    }
    
    mutating func nextCombinations()
    {
        if (indexes.count > 0)
        {
            indexes[0] += 1
            for i in 0..<indexes.count
            {
                if (indexes[i] == lengths[i])
                {
                    indexes[i] = 0
                    if (i != indexes.count - 1)
                    {
                        indexes[i + 1] += 1
                    }
                }
                else {break}
            }
        }
    }
}
