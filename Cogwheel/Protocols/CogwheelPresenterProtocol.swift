//
//  CogwheelPresenterProtocol.swift
//  Cogwheel
//
//  Created by Artem on 17.10.2024.
//

import Foundation

protocol CogwheelPresenterProtocol: AnyObject {
    func viewDidLoad()
    func updateCogwheel(_ parameters: CogwheelParameters)
}
