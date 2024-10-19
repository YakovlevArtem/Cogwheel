//
//  CogwheelPresenter.swift
//  Cogwheel
//
//  Created by Artem on 17.10.2024.
//

import Foundation

final class CogwheelPresenter {
    
    weak var view: CogwheelViewControllerProtocol?
    private lazy var model: CogwheelModelProtocol = CogwheelModel()
    
    
    init(with view: CogwheelViewControllerProtocol) {
        self.view = view
    }
    
    private func createCogwheel(_ parameter: CogwheelParameters?) {
        let result = model.buildWheelWithParameters(parameter ?? model.parameters)
        switch result {
        case .success(let image):
            view?.redrawCogwheel(image)
        case .failure(let error):
            view?.showAlert(error)
            view?.setParameters(model.parameters)
        }
    }
}


//MARK: - CogwheelPresenterProtocol

extension CogwheelPresenter: CogwheelPresenterProtocol {
    
    func viewDidLoad() {
        view?.setParameters(model.parameters)
        createCogwheel(nil)
    }
    
    func updateCogwheel(_ parameters: CogwheelParameters) {
        createCogwheel(parameters)
    }
    
}
