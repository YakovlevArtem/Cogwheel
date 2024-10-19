//
//  CogwheelModelProtocol.swift
//  Cogwheel
//
//  Created by Artem on 18.10.2024.
//

import UIKit

protocol CogwheelModelProtocol: AnyObject {
    var parameters: CogwheelParameters { get }
    
    func buildWheelWithParameters(_ parameters: CogwheelParameters) -> Result<UIImage, CogwheelError>
}
