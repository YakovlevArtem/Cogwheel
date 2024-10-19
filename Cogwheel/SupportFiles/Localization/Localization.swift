//
//  Localization.swift
//  Cogwheel
//
//  Created by Artem on 19.10.2024.
//

import Foundation

enum Localization {
    case errorIncorrectInnerRadius
    case errorWheelDoestExist
    case errorIncorrectTeeth
    case errorFailImage
    case alertActionClose
    case mainBuildButton
    case mainLinkRadiusLabel
    case mainInnerRadiusLabel
    case mainOuterRadiusLabel
    case mainNumberOfTeethLabel
    case mainTitleLabel
    
    var key: String {
        switch self {
        case .errorIncorrectInnerRadius:
            return "error.incorrectInnerRadius.description"
        case .errorWheelDoestExist:
            return "error.wheelDoestExist.description"
        case .errorIncorrectTeeth:
            return "error.incorrectTeeth.description"
        case .errorFailImage:
            return "error.failImage.description"
        case .alertActionClose:
            return "alert.action.close"
        case .mainBuildButton:
            return "main.build.button"
        case .mainLinkRadiusLabel:
            return "main.linkRadius.label"
        case .mainInnerRadiusLabel:
            return "main.innerRadius.label"
        case .mainOuterRadiusLabel:
            return "main.outerRadius.label"
        case .mainNumberOfTeethLabel:
            return "main.numberOfTeeths.label"
        case .mainTitleLabel:
            return "main.title.label"
        }
    }
    
    var value: String {
        return NSLocalizedString(self.key, comment: "")
    }
}
