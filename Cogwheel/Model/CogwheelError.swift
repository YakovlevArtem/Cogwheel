//
//  CogwheelError.swift
//  Cogwheel
//
//  Created by Artem on 19.10.2024.
//

import Foundation

enum CogwheelError: Error {
    case incorrectInnerRadius
    case wheelDoestExist
    case incorrectTeeth
    case failImage
    
    var textError: String {
        switch self {
        case .incorrectInnerRadius:
            return Localization.errorIncorrectInnerRadius.value
        case .wheelDoestExist:
            return Localization.errorWheelDoestExist.value
        case .incorrectTeeth:
            return Localization.errorIncorrectTeeth.value
        case .failImage:
            return Localization.errorFailImage.value
        }
    }
}
