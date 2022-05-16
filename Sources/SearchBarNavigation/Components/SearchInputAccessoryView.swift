//
//  SearchInputAccessoryView.swift
//  
//
//  Created by Franklyn Weber on 15/03/2021.
//

import SwiftUI
import Combine
import ButtonConfig


class SearchInputAccessoryView: UIView {
    
    @IBOutlet weak var coloredBackgroundView: UIView!
    @IBOutlet weak var leadingButtonsStackView: UIStackView!
    @IBOutlet weak var trailingButtonsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var keyboardDismissButton: UIButton!
    
    var updateLabel: (() -> ())?
    
    private var textPublisher: AnyCancellable?
    
    static func withAccessory(_ inputAccessory: SearchInputAccessory, buttonColor: UIColor?, dismissKeyboard: @escaping () -> ()) -> SearchInputAccessoryView {
        
        let view = Bundle.module.loadNibNamed("SearchInputAccessoryView", owner: nil, options: nil)!.first as! SearchInputAccessoryView
        view.keyboardDismissButton.tintColor = buttonColor
        view.titleLabel.textColor = buttonColor
        
        func configureKeyboardDismissButton(_ keyboardDismissButtonConfig: ImageButtonConfig?) {
            switch keyboardDismissButtonConfig {
            case .some(let buttonConfig):
                buttonConfig.configureButton(view.keyboardDismissButton, additionalAction: dismissKeyboard)
            case .none:
                let buttonConfig = ImageButtonConfig(systemImage: "keyboard.chevron.compact.down", action: dismissKeyboard)
                buttonConfig.configureButton(view.keyboardDismissButton)
            }
        }
        
        switch inputAccessory {
        case .buttons(let leadingButtons, let trailingButtons, let keyboardDismissButtonConfig, let backgroundColor):
            
            func addButtons(_ buttons: [ImageButtonConfig], to stackView: UIStackView) {
                buttons.forEach { buttonConfig in
                    let button = buttonConfig.uiButton
                    button.tintColor = buttonColor
                    stackView.addArrangedSubview(button)
                }
            }
            
            addButtons(leadingButtons, to: view.leadingButtonsStackView)
            addButtons(trailingButtons, to: view.trailingButtonsStackView)
            configureKeyboardDismissButton(keyboardDismissButtonConfig)
            view.coloredBackgroundView.backgroundColor = UIColor(backgroundColor ?? Color(.systemBackground))
            
        case .title(let title, let keyboardDismissButtonConfig, let backgroundColor):
        
            title.applyToLabel(view.titleLabel)
            configureKeyboardDismissButton(keyboardDismissButtonConfig)
            view.coloredBackgroundView.backgroundColor = UIColor(backgroundColor ?? Color(.systemBackground))
            
        case .textWithButton(let textPublisher, let buttonConfig, let keyboardDismissButtonConfig, let backgroundColor):
            
            let button = buttonConfig.uiButton
            button.tintColor = buttonColor
            view.trailingButtonsStackView.addArrangedSubview(button)
            configureKeyboardDismissButton(keyboardDismissButtonConfig)
            view.coloredBackgroundView.backgroundColor = UIColor(backgroundColor ?? Color(.systemBackground))
            
            view.textPublisher = textPublisher
                .sink {
                    let numberOfLines = CGFloat($0.components(separatedBy: "\n").count)
                    let fontSize = 17 - numberOfLines * 2
                    view.titleLabel.text = $0
                    view.titleLabel.font = .systemFont(ofSize: fontSize)
                }
        }
        
        return view
    }
}
