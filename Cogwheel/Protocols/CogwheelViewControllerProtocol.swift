//
//  CogwheelViewControllerProtocol.swift
//  Cogwheel
//
//  Created by Artem on 17.10.2024.
//

import UIKit

protocol CogwheelViewControllerProtocol: AnyObject {
    func setParameters(_ parameters: CogwheelParameters)
    func redrawCogwheel(_ image: UIImage?)
    func showAlert(_ error: CogwheelError)
}
