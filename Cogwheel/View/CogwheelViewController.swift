//
//  CogwheelViewController.swift
//  Cogwheel
//
//  Created by Artem on 17.10.2024.
//

import UIKit

class CogwheelViewController: UIViewController {

    var presenter: CogwheelPresenterProtocol?
    
    private lazy var contentView: CogwheelViewProtocol = {
        let view = CogwheelView()
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    
    // MARK: - Init & Deinit
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = CogwheelPresenter(with: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(_colorLiteralRed: 187/255, green: 223/255, blue: 225/255, alpha: 1)
        contentView.addSubviews(in: view)
        presenter?.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


//MARK: - CogwheelViewControllerProtocol

extension CogwheelViewController: CogwheelViewControllerProtocol {
    
    func setParameters(_ parameters: CogwheelParameters) {
        contentView.setParameters(parameters)
    }
    
    func redrawCogwheel(_ image: UIImage?) {
        contentView.setCogwheelImage(image)
    }
    
    func showAlert(_ error: CogwheelError) {
        let alertViewController = UIAlertController(title: error.textError, message: nil, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: Localization.alertActionClose.value, style: .cancel)
        alertViewController.addAction(closeAction)
        self.present(alertViewController, animated: true)
    }
}


//MARK: - CogwheelViewDelegate

extension CogwheelViewController: CogwheelViewDelegate {
  
    func updateParameters(_ parameters: CogwheelParameters) {
        presenter?.updateCogwheel(parameters)
        view.endEditing(true)
    }
}
