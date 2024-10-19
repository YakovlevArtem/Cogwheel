//
//  MathStruct.swift
//  Cogwheel
//
//  Created by Artem on 18.10.2024.
//

import Foundation

struct LinkPoints {
    var point1: CGPoint
    var point2: CGPoint
    var center: CGPoint
    var angle: CGFloat
}

struct SegmentFormula: Equatable {
    let a: CGFloat
    let b: CGFloat
    var c: CGFloat
    
    init(p1: CGPoint, p2: CGPoint) {
        self.a = p1.y - p2.y
        self.b = p2.x - p1.x
        self.c = p1.x * p2.y - p2.x * p1.y
    }
    
    init(a: CGFloat, b: CGFloat, c: CGFloat) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    init(x: CGFloat, y: CGFloat, offsetX: CGFloat, offsetY: CGFloat) {
        let p1 = CGPoint(x: x, y: y)
        let p2 = CGPoint(x: x + offsetX, y: y + offsetY)
        self.a = p1.y - p2.y
        self.b = p2.x - p1.x
        self.c = p1.x * p2.y - p2.x * p1.y
    }
    
    mutating func addDistance(_ distance: CGFloat) {
        c += distance * sqrt(a*a + b*b)
    }
}

class Math {
    
    func getParallelLine(_ line: SegmentFormula, segmentStart: CGPoint,  segmentEnd: CGPoint, with distance: CGFloat) -> SegmentFormula {
        var lineNew = line
        // получаем параллельную прямую
        lineNew.addDistance(distance)
        //находим точку пересечения с прямой проходящую через отрезок
        let intersectionPoint = lineIntersect(line: lineNew, segmentStart: segmentStart, segmentEnd: segmentEnd)
        //проверяем лежит ли точка пересечения на отрезке
        guard let intersectionPoint else {
            return lineNew
        }
        if checkedOwnSegment(point: intersectionPoint, pointStart: segmentStart, pointEnd: segmentEnd) {
            //если да возвращаем эту параллельную прямую
            return lineNew
        }
        //получаем и возвращаем параллельную прямую с другой стороны
        lineNew = line
        lineNew.addDistance(-distance)
        return lineNew
    }
    
    func lineIntersect(line: SegmentFormula, segmentStart: CGPoint,  segmentEnd: CGPoint) -> CGPoint? {
        let segmentLine = SegmentFormula(p1: segmentStart, p2: segmentEnd)
        let zn = calculateDeterminate(a: line.a, b: line.b, c: segmentLine.a, d: segmentLine.b)
        guard zn != 0 else {
            return nil
        }
        let x = -1 * calculateDeterminate(a: line.c, b: line.b, c: segmentLine.c, d: segmentLine.b) / zn
        let y = -1 * calculateDeterminate(a: line.a, b: line.c, c: segmentLine.a, d: segmentLine.c) / zn
        return CGPoint(x: x, y: y)
    }
    
    func lineIntersect(line1: SegmentFormula, line2: SegmentFormula) -> CGPoint? {
        let zn = calculateDeterminate(a: line1.a, b: line1.b, c: line2.a, d: line2.b)
        guard zn != 0 else {
            return nil
        }
        let x = -1 * calculateDeterminate(a: line1.c, b: line1.b, c: line2.c, d: line2.b) / zn
        let y = -1 * calculateDeterminate(a: line1.a, b: line1.c, c: line2.a, d: line2.c) / zn
        return CGPoint(x: x, y: y)
    }
    
    func calculateDeterminate(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat) -> CGFloat {
        return a * d - b * c
    }
    
    func checkedOwnSegment(point: CGPoint, pointStart: CGPoint, pointEnd: CGPoint) -> Bool {
        var minX = pointStart.x
        var maxX = pointEnd.x
        if minX > maxX {
            minX = pointEnd.x
            maxX = pointStart.x
        }
        var minY = pointStart.y
        var maxY = pointEnd.y
        if minY > maxY {
            minY = pointEnd.y
            maxY = pointStart.y
        }
        if minX <= CGFloat(roundf(Float(point.x))) && CGFloat(roundf(Float(point.x))) <= maxX && minY <= CGFloat(roundf(Float(point.y))) && CGFloat(roundf(Float(point.y))) <= maxY {
            let line = SegmentFormula(p1: pointStart, p2: pointEnd)
            if line.a * point.x + line.b * point.y + line.c == 0 {
                return true
            }
        }
        return false
    }
    
    func getIntersectPointAtNormalLine(segment: SegmentFormula, point: CGPoint) -> CGPoint? {
        let a = -segment.b
        let b = segment.a
        let c = segment.b * point.x - segment.a * point.y
        let lineNormal = SegmentFormula(a: a, b: b, c: c)
        return lineIntersect(line1: segment, line2: lineNormal)
    }
    
    func getLinkAngle(_ point1: CGPoint, _ point2: CGPoint, with radius: CGFloat) -> CGFloat {
        let lenght = sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
        return radius == 0 ? 0 : asin((lenght/2)/radius)
    }
}
