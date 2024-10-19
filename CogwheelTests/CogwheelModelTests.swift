//
//  CogwheelModelTests.swift
//  CogwheelTests
//
//  Created by Artem on 19.10.2024.
//

import XCTest
@testable import Cogwheel

final class CogwheelModelTests: XCTestCase {
    
    var model: Math? = nil
    
    override func setUpWithError() throws {
        model = Math()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLinkAngle() throws {
        var angle = model!.getLinkAngle(CGPoint(x: 100, y: 0), CGPoint(x: 0, y: 100), with: 100)
        XCTAssertEqual(Int(angle * Double(1000)),Int(Double.pi/4 * Double(1000)))
        angle = model!.getLinkAngle(CGPoint(x: 100, y: 100), CGPoint(x: 100, y: 100), with: 100)
        XCTAssertEqual(angle,0)
    }
    
    func testParallelLine() throws {
        var lineNew = model!.getParallelLine(.init(p1: CGPoint(x: 0, y: 0),
                                                   p2:  CGPoint(x: 0, y: 100)),
                                             segmentStart: CGPoint(x: 100, y: 0),
                                             segmentEnd: CGPoint(x: 0, y: 80), with: 50)
        XCTAssertEqual(lineNew,SegmentFormula(p1: CGPoint(x: 50, y: 0),
                                              p2: CGPoint(x: 50, y: 100)))
        
        lineNew = model!.getParallelLine(.init(p1: CGPoint(x: 0, y: 0),
                                               p2:  CGPoint(x: 100, y: 0)),
                                         segmentStart: CGPoint(x: 200, y: 0),
                                         segmentEnd: CGPoint(x: 0, y: 80), with: 50)
        XCTAssertEqual(lineNew,SegmentFormula(p1: CGPoint(x: 0, y: 50),
                                              p2: CGPoint(x: 100, y: 50)))
        
        lineNew = model!.getParallelLine(.init(p1: CGPoint(x: 0, y: 0),
                                               p2:  CGPoint(x: 100, y: 100)),
                                         segmentStart: CGPoint(x: 100, y: 10),
                                         segmentEnd: CGPoint(x: 100, y: 90), with: 50)
        XCTAssertEqual(lineNew,SegmentFormula(a: -100, b: 100, c: 7071.067811865476))
    }
    
    func testIntersectLine() throws {
        var point: CGPoint? = model!.lineIntersect(line: SegmentFormula(p1: CGPoint(x: 0, y: 0),
                                                                        p2: CGPoint(x: 0, y: 100)),
                                                   segmentStart: CGPoint(x: 50, y: 50),
                                                   segmentEnd: CGPoint(x: -50, y: 50))
        
        XCTAssertEqual(point, CGPoint(x: 0, y: 50))
        
        point = model!.lineIntersect(line: SegmentFormula(p1: CGPoint(x: 0, y: 0),
                                                          p2: CGPoint(x: 0, y: 100)),
                                     segmentStart: CGPoint(x: 50, y: 0),
                                     segmentEnd: CGPoint(x: 50, y: 50))
        
        XCTAssertNil(point)
        
        point = model!.lineIntersect(line1:  SegmentFormula(p1: CGPoint(x: 0, y: 0),
                                                            p2: CGPoint(x: 0, y: 100)),
                                     line2:  SegmentFormula(p1: CGPoint(x: 50, y: 50),
                                                            p2: CGPoint(x: -50, y: 50)))
        
        XCTAssertEqual(point, CGPoint(x: 0, y: 50))
        
        point = model!.lineIntersect(line1:  SegmentFormula(p1: CGPoint(x: 0, y: 0),
                                                            p2: CGPoint(x: 0, y: 100)),
                                     line2:  SegmentFormula(p1: CGPoint(x: 50, y: 0),
                                                            p2: CGPoint(x: 50, y: 100)))
        
        XCTAssertNil(point)
    }
    
    func testCheckedOwnSegment() throws {
        var result = model!.checkedOwnSegment(point:  CGPoint(x: 50, y: 50), pointStart: CGPoint(x: 0, y: 0), pointEnd: CGPoint(x: 100, y: 100))
        XCTAssertEqual(result, true)
        
        result = model!.checkedOwnSegment(point:  CGPoint(x: 150, y: 150), pointStart: CGPoint(x: 0, y: 0), pointEnd: CGPoint(x: 100, y: 100))
        XCTAssertEqual(result, false)
        
        result = model!.checkedOwnSegment(point:  CGPoint(x: 100, y: 0), pointStart: CGPoint(x: 0, y: 0), pointEnd: CGPoint(x: 100, y: 100))
        XCTAssertEqual(result, false)
    }
    
    func testGetIntersectPointAtNormalLine() throws {
        var point: CGPoint? = model!.getIntersectPointAtNormalLine(segment: SegmentFormula(p1: CGPoint(x: 0, y: 0),
                                                                                           p2: CGPoint(x: 0, y: 100)),
                                                                   point: CGPoint(x: 50, y: 50))
        
        XCTAssertEqual(point, CGPoint(x: 0, y: 50))
        
        point = model!.getIntersectPointAtNormalLine(segment: SegmentFormula(p1: CGPoint(x: 0, y: 0),
                                                                             p2: CGPoint(x: 0, y: 100)),
                                                                   point: CGPoint(x: 0, y: 50))
        
        XCTAssertEqual(point, CGPoint(x: 0, y: 50))
        
        point = model!.getIntersectPointAtNormalLine(segment: SegmentFormula(p1: CGPoint(x: 0, y: 0),
                                                                             p2: CGPoint(x: 0, y: 100)),
                                                                   point: CGPoint(x: 200, y: 150))
        
        XCTAssertEqual(point, CGPoint(x: 0, y: 150))
    }
    
}
