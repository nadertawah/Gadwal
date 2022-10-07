//
//  CombinationIndexerTests.swift
//  GadwalTests
//
//  Created by nader said on 02/10/2022.
//

import XCTest
@testable import Gadwal

class CombinationIndexerTests: XCTestCase
{
    var indexer = GroupCombinationsIndexer(lengths: [])

    func testWithEmptyLengthsArray()
    {
        XCTAssertEqual(indexer.indexes.count, 0)
        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes.count, 0)
    }
    
    func testWithNegativeLength()
    {
        indexer = GroupCombinationsIndexer(lengths: [-1])
        XCTAssertEqual(indexer.indexes.count, 0)
        
        indexer = GroupCombinationsIndexer(lengths: [2,-1])
        XCTAssertEqual(indexer.indexes.count, 0)
        
        indexer = GroupCombinationsIndexer(lengths: [2,-1,1])
        XCTAssertEqual(indexer.indexes.count, 0)
        
        indexer = GroupCombinationsIndexer(lengths: [2,1,-1])
        XCTAssertEqual(indexer.indexes.count, 0)
    }

    func testWithOneLength()
    {
        indexer = GroupCombinationsIndexer(lengths: [1])
        XCTAssertEqual(indexer.indexes.count, 1)
        XCTAssertEqual(indexer.indexes[0], 0)
        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 0)

        indexer = GroupCombinationsIndexer(lengths: [2])
        XCTAssertEqual(indexer.indexes.count, 1)
        XCTAssertEqual(indexer.indexes[0], 0)
        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 1)
        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 0)
    }
    
    func testWithMoreThanOneLength()
    {
        indexer = GroupCombinationsIndexer(lengths: [2,3])
        XCTAssertEqual(indexer.indexes.count, 2)
        XCTAssertEqual(indexer.indexes[0], 0)
        XCTAssertEqual(indexer.indexes[1], 0)

        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 1)
        XCTAssertEqual(indexer.indexes[1], 0)

        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 0)
        XCTAssertEqual(indexer.indexes[1], 1)
        
        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 1)
        XCTAssertEqual(indexer.indexes[1], 1)
        
        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 0)
        XCTAssertEqual(indexer.indexes[1], 2)
        
        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 1)
        XCTAssertEqual(indexer.indexes[1], 2)
        
        indexer.nextCombinations()
        XCTAssertEqual(indexer.indexes[0], 0)
        XCTAssertEqual(indexer.indexes[1], 0)
    }

}
