//
//  CogwheelViewProtocol.swift
//  Cogwheel
//
//  Created by Artem on 17.10.2024.
//

import UIKit

protocol CogwheelViewProtocol: AnyObject {
    func setParameters(_ parameters: CogwheelParameters)
    func addSubviews(in superView: UIView)
    func setCogwheelImage(_ image: UIImage?)
}
