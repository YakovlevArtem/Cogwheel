//
//  CogwheelModel.swift
//  Cogwheel
//
//  Created by Artem on 18.10.2024.
//

import UIKit

final class CogwheelModel {
    
    private lazy var currentParameters = CogwheelParameters(linkRadius: Constants.linkRadiusDefault,
                                                            innerRadius: Constants.innerRadiusDefault,
                                                            outerRadius: Constants.outerRadiusDefault,
                                                            numberOfTeeth: Constants.numberOfTeethDefault)
    
    var parameters: CogwheelParameters {
        get {
            currentParameters
        }
    }
    
    private let math = Math()
    
    private func addWheelCenterPoint(point: CGPoint, center: CGPoint, angle: CGFloat) -> CGPoint {
        return CGPointMake((point.x * cos(angle) - point.y * sin(angle)) + center.x,
                           (point.y * cos(angle) + point.x * sin(angle)) + center.y)
    }
    
    private func CGPointMakeFromInt(_ x: UInt, _ y: UInt) -> CGPoint {
        return CGPointMake(CGFloat(x), CGFloat(y))
    }
    
    private func createCogWheel(_ parameters: CogwheelParameters) -> Result<UIImage, CogwheelError> {
        let data: UnsafeMutableRawPointer? = nil
        let size = Int(parameters.outerRadius + Constants.spaceWheel) * 2
        let context = CGContext(data: data,
                                width: size,
                                height: size,
                                bitsPerComponent: 8,
                                bytesPerRow: size * 8,
                                space: CGColorSpaceCreateDeviceGray(),
                                bitmapInfo: CGImageAlphaInfo.none.rawValue)
        guard let context  else { return .failure(.failImage)}
        let amplitude = Double(parameters.outerRadius - parameters.innerRadius) / 2
        let angleStep = Double.pi / Double(parameters.numberOfTeeth)
        var angle = 0.0
        let wheelCenter = CGPointMakeFromInt(parameters.outerRadius + Constants.spaceWheel,
                                             parameters.outerRadius + Constants.spaceWheel)
        let radius = Double(parameters.innerRadius) + amplitude
        
        //вычисляем координаты точек отрезков для сопряжения
        let startPoint = CGPointMake(radius * cos(angleStep),
                                     radius * sin(-angleStep))
        let endPoint = CGPointMake(radius * cos(angleStep),
                                   radius * sin(angleStep))
        
        guard let linkPointsOut = getLinkingPoints(first: startPoint, second: endPoint,
                                             center: CGPointMakeFromInt(parameters.innerRadius,0),
                                             vertex: CGPointMakeFromInt(parameters.outerRadius,0), radius: CGFloat(parameters.linkRadius)),
              let linkPointsIn = getLinkingPoints(first: startPoint, second: endPoint,
                                            center: CGPointMakeFromInt(parameters.outerRadius,0),
                                                  vertex: CGPointMakeFromInt(parameters.innerRadius,0), radius: CGFloat(parameters.linkRadius)) else {
            return .failure(.wheelDoestExist)
        }
        
        if parameters.linkRadius > 0 &&
            (linkPointsOut.center.x >= CGFloat(parameters.outerRadius) ||
             linkPointsOut.point1.x >= CGFloat(parameters.outerRadius) ||
             linkPointsOut.point2.x >= CGFloat(parameters.outerRadius)) {
            //если точки сопряжения находятся за внешниим радиусом - колесо не существует
            return .failure(.wheelDoestExist)
        }
        let deltaOut = linkPointsOut.point2.y - linkPointsOut.point1.y
        let deltaIn = linkPointsIn.point2.y - linkPointsOut.point1.y
        if (deltaOut + deltaIn) * CGFloat(parameters.numberOfTeeth) > 2 * Double.pi * radius {
            //если длина отрезков сопряжения больше длины окружности - колесо не существует
            return .failure(.wheelDoestExist)
        }
        
        var isOut = true
        context.move(to: addWheelCenterPoint(point: linkPointsIn.point2, center: wheelCenter, angle: angle - angleStep))
        while angle < 2 * Double.pi {
            if isOut {
                context.addArc(center: addWheelCenterPoint(point: linkPointsOut.center, center: wheelCenter, angle: angle), radius: CGFloat(parameters.linkRadius), startAngle:  -linkPointsOut.angle + angle, endAngle: linkPointsOut.angle + angle, clockwise: false)
            } else {
                context.addArc(center: addWheelCenterPoint(point: linkPointsIn.center, center: wheelCenter, angle: angle), radius: CGFloat(parameters.linkRadius), startAngle:  Double.pi + linkPointsIn.angle + angle, endAngle: Double.pi - linkPointsOut.angle + angle, clockwise: true)
                
            }
            angle += angleStep
            isOut = !isOut
        }
        context.setStrokeColor(UIColor.green.cgColor)
        context.strokePath()
        guard let image = context.makeImage() else {
            return .failure(.failImage)
        }
        currentParameters = parameters
        return .success(UIImage(cgImage: image))
    }
    
    private func getLinkingPoints(first: CGPoint,
                                  second: CGPoint,
                                  center: CGPoint,
                                  vertex: CGPoint,
                                  radius: CGFloat) -> LinkPoints? {
        //получаем уравнение прямой первого отрезка
        let firstSegment = SegmentFormula(p1: first, p2: vertex)
        //получаем уравнение прямой второго отрезка
        let secondSegment = SegmentFormula(p1: second, p2: vertex)
        //получаем прямые параллельные отрезкам
        let firstSegmentLineParallel = math.getParallelLine(firstSegment, segmentStart: center, segmentEnd: vertex, with: radius)
        let secondSegmentLineParallel = math.getParallelLine(secondSegment, segmentStart: center, segmentEnd: vertex, with: radius)
        //находим центр сопряжения и получаем точки сопряжения на отрезках
        guard let centerLink = math.lineIntersect(line1: firstSegmentLineParallel, line2: secondSegmentLineParallel),
              let firstLink = math.getIntersectPointAtNormalLine(segment: firstSegment, point: centerLink),
              let secondLink = math.getIntersectPointAtNormalLine(segment: secondSegment, point: centerLink) else {
            //прямые параллельны - сопряжение не возможно
            return nil
        }
        let angle = math.getLinkAngle(firstLink, secondLink, with: radius)
        return LinkPoints(point1: firstLink, point2: secondLink, center: centerLink, angle: angle)
    }

}


extension CogwheelModel: CogwheelModelProtocol {
    
    func buildWheelWithParameters(_ parameters: CogwheelParameters) -> Result<UIImage, CogwheelError> {
        if parameters.outerRadius <= parameters.innerRadius {
            //внешний радиус меньше или равен врутреннему
            return .failure(.incorrectInnerRadius)
        }
        if parameters.numberOfTeeth < 4 {
            //количество зубьев слишком мало
            return .failure(.incorrectTeeth)
        }
        return createCogWheel(parameters)
    }
}


//MARK: - Constants

private extension CogwheelModel {
    
    enum Constants {
        static let linkRadiusDefault: UInt = 10
        static let innerRadiusDefault: UInt = 150
        static let outerRadiusDefault: UInt = 180
        static let numberOfTeethDefault: UInt = 20
        
        static let spaceWheel: UInt = 20
    }
}
