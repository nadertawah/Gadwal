//
//  String.swift
//  Gadwal
//
//  Created by nader said on 18/09/2022.
//

import Foundation

extension String
{
    subscript(i: Int) -> String
    {
        
        return i < 0 || i >= self.count ? "" : String(self[index(startIndex, offsetBy: i)])
    }
}
