//
//  CogwheelView.swift
//  Cogwheel
//
//  Created by Artem on 17.10.2024.
//

import UIKit

final class CogwheelView: UIView {
    
    private enum TextFieldType: Int {
        case innerRadius = 1
        case outerRadius
        case linkRadius
        case numberOfTeeth
    }
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.contentInsetAdjustmentBehavior = .never
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        sv.bounces = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        label.text = Localization.mainTitleLabel.value
        return label
    }()
    
    private lazy var innerRadiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.text = Localization.mainInnerRadiusLabel.value
        return label
    }()
    
    private lazy var innerRadiusField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.addTarget(self, action: #selector(valueTextFieldDidEdited(_:)), for: .editingDidEnd)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.tag = TextFieldType.innerRadius.rawValue
        textField.isExclusiveTouch = true
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    private lazy var outerRadiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.text = Localization.mainOuterRadiusLabel.value
        return label
    }()
    
    private lazy var outerRadiusField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.addTarget(self, action: #selector(valueTextFieldDidEdited(_:)), for: .editingDidEnd)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.tag = TextFieldType.outerRadius.rawValue
        textField.isExclusiveTouch = true
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    private lazy var linkRadiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.text = Localization.mainLinkRadiusLabel.value
        return label
    }()
    
    private lazy var linkRadiusField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.addTarget(self, action: #selector(valueTextFieldDidEdited(_:)), for: .editingDidEnd)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.tag = TextFieldType.linkRadius.rawValue
        textField.isExclusiveTouch = true
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    private lazy var numberOfTeethLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.text = Localization.mainNumberOfTeethLabel.value
        return label
    }()
    
    private lazy var numberOfTeethField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.addTarget(self, action: #selector(valueTextFieldDidEdited(_:)), for: .editingDidEnd)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.tag = TextFieldType.numberOfTeeth.rawValue
        textField.isExclusiveTouch = true
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    
    private lazy var buildButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(onBuildDidTap(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.backgroundColor = .blue
        button.setTitle(Localization.mainBuildButton.value, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cogwheelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightText
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.shouldRasterize = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    weak var delegate: CogwheelViewDelegate?
    private lazy var currentParameters: CogwheelParameters = CogwheelParameters()
    
    // MARK: - Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTitleView(in superView: UIView) {
        superView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: Constants.top),
            titleLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: Constants.leading),
            titleLabel.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: Constants.trailing),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.TitleLabel.height)
        ])
    }
    
    private func addScrollView(in superView: UIView) {
        superView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.top),
            scrollView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: Constants.bottom),
        ])
    }
    
    private func addSubViewsInScrollView(in superView: UIView) {
        let innerRadiusView = createView(label: innerRadiusLabel, textField: innerRadiusField, in: superView, to: scrollView.topAnchor)
        let outerRadiusView = createView(label: outerRadiusLabel, textField: outerRadiusField, in: superView, to: innerRadiusView.bottomAnchor)
        let linkRadiusView = createView(label: linkRadiusLabel, textField: linkRadiusField, in: superView, to: outerRadiusView.bottomAnchor)
        let numberOfTeethView = createView(label: numberOfTeethLabel, textField: numberOfTeethField, in: superView, to: linkRadiusView.bottomAnchor)
        
        scrollView.addSubview(buildButton)
        NSLayoutConstraint.activate([
            buildButton.topAnchor.constraint(equalTo: numberOfTeethView.bottomAnchor, constant: Constants.top),
            buildButton.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: Constants.Button.leading),
            buildButton.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: Constants.Button.trailing),
            buildButton.heightAnchor.constraint(equalToConstant: Constants.Button.height)
        ])
        
        scrollView.addSubview(cogwheelImageView)
        NSLayoutConstraint.activate([
            cogwheelImageView.topAnchor.constraint(equalTo: buildButton.bottomAnchor, constant: Constants.ImageView.top),
            cogwheelImageView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: Constants.leading),
            cogwheelImageView.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: Constants.trailing),
            cogwheelImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.bottom),
            cogwheelImageView.widthAnchor.constraint(equalTo: cogwheelImageView.heightAnchor)
        ])
    }
    
    private func createView(label: UILabel, textField: UITextField, in superView: UIView, to anchor: NSLayoutYAxisAnchor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            view.heightAnchor.constraint(equalToConstant: Constants.View.height),
            view.topAnchor.constraint(equalTo: anchor, constant: Constants.top)
        ])
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.trailing),
            textField.widthAnchor.constraint(equalToConstant: Constants.TextField.width),
        ])
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leading),
            label.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: Constants.trailing),
            label.heightAnchor.constraint(equalToConstant: Constants.Label.height)
        ])
        return view
    }
}


//MARK: - Action

extension CogwheelView {
    
    @objc func onBuildDidTap(_ sender: UIButton) {
        guard let linkRadius = UInt(linkRadiusField.text ?? ""),
              let innerRadius = UInt(innerRadiusField.text ?? ""),
              let outerRadius = UInt(outerRadiusField.text ?? ""),
              let numberOfTeeth = UInt(numberOfTeethField.text ?? "") else {
            return
        }
        delegate?.updateParameters(.init(linkRadius: linkRadius, innerRadius: innerRadius, outerRadius: outerRadius, numberOfTeeth: numberOfTeeth))
    }
    
    @objc func valueTextFieldDidEdited(_ sender: UITextField) {
        guard let textFieldType = TextFieldType(rawValue: sender.tag),
        let text = sender.text else {
            return
        }
        if text.isEmpty {
            switch textFieldType {
            case .innerRadius: innerRadiusField.text = "\(currentParameters.innerRadius)"
            case .outerRadius: outerRadiusField.text = "\(currentParameters.outerRadius)"
            case .linkRadius: linkRadiusField.text = "\(currentParameters.linkRadius)"
            case .numberOfTeeth: numberOfTeethField.text = "\(currentParameters.numberOfTeeth)"
            }
        } else {
            switch textFieldType {
            case .innerRadius: currentParameters.innerRadius = UInt(text) ?? 0
            case .outerRadius: currentParameters.outerRadius = UInt(text) ?? 0
            case .linkRadius: currentParameters.linkRadius = UInt(text) ?? 0
            case .numberOfTeeth: currentParameters.numberOfTeeth = UInt(text) ?? 0
            }
        }
    }
}


//MARK: - CogwheelViewProtocol

extension CogwheelView: CogwheelViewProtocol {
    
    func addSubviews(in superView: UIView) {
        addTitleView(in: superView)
        addScrollView(in: superView)
        addSubViewsInScrollView(in: superView)
    }
    
    func setParameters(_ parameters: CogwheelParameters) {
        currentParameters = parameters
        innerRadiusField.text = "\(parameters.innerRadius)"
        outerRadiusField.text = "\(parameters.outerRadius)"
        linkRadiusField.text = "\(parameters.linkRadius)"
        numberOfTeethField.text = "\(parameters.numberOfTeeth)"
    }
    
    func setCogwheelImage(_ image: UIImage?) {
        guard let image else {
            return
        }
        cogwheelImageView.image = image
    }
}


//MARK: - UITextFieldDelegate

extension CogwheelView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text =  textField.text else {
            return true
        }
        guard let stringRange = Range(range, in: text) else {
            return false
        }
        if string.contains(where: {$0 == ","})  {
            //запрещаем ввод запятой
            return false
        }
        let set = CharacterSet.decimalDigits
        if text.count == Constants.TextField.maxSymbol &&
            string.rangeOfCharacter(from: set) != nil {
            //запрещаем ввод еще одной цифры если уже введено 3
            return false
        }
        return true
    }
}


//MARK: - Constants

private extension CogwheelView {
    
    enum Constants {
        static let top: CGFloat = 16
        static let leading: CGFloat = 16
        static let trailing: CGFloat = -16
        static let bottom: CGFloat = -16
        
        enum TitleLabel {
            static let height: CGFloat = 40
        }
        
        enum View {
            static let height: CGFloat = 32
        }
        
        enum Label {
            static let height: CGFloat = 20
        }
        
        enum TextField {
            static let width: CGFloat = 80
            static let maxSymbol: Int = 3
        }
        
        enum Button {
            static let leading: CGFloat = 48
            static let trailing: CGFloat = -48
            static let height: CGFloat = 40
        }
        
        enum ImageView {
            static let top: CGFloat = 32
        }
    }
}
