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
        return String(self[index(startIndex, offsetBy: i)])
    }
}
