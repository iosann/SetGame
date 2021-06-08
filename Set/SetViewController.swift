//
//  ViewController.swift
//  Set
//
//  Created by Anna Belousova on 03.06.2021.
//

import UIKit

class SetViewController: UIViewController {

	
	@IBOutlet private var cardButtons: [UIButton]!
	@IBOutlet private var deal3Button: UIButton!
	private let deck = Deck()
	private var verticalSpacing: CGFloat {
		return cardButtons[0].bounds.insetBy(dx: 0, dy: Constants.verticalOffsetInsideButton).size.height / CGFloat(Card.Quantity.allCases.maxRawValue!)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		customizeUI()
	}

	private func customizeUI() {
		
		for button in cardButtons {
			button.layer.cornerRadius = Constants.cornerRadius
			button.layer.borderWidth = Constants.borderWidth
			button.layer.borderColor = Constants.borderColor
			button.titleLabel?.numberOfLines = 0
		}
		for (index, button) in cardButtons.enumerated() {
			if index > 11 {
				button.isHidden = true
			} else {
				button.setAttributedTitle(createTitle(from: deck.cards[index]), for: .normal)
			}
		}
		deal3Button.layer.cornerRadius = Constants.cornerRadius
		deal3Button.layer.borderWidth = Constants.borderWidth
		deal3Button.layer.borderColor = Constants.borderColor
	}

	private func createTitle(from card: Card) -> NSAttributedString {

		func createStringWithBreaks(from card: Card) -> String {
			switch card.quantity {
			case .one:
				return card.type.rawValue
			case .two:
				return card.type.rawValue + "\n" + card.type.rawValue
			case .three:
				return card.type.rawValue + "\n" + card.type.rawValue + "\n" + card.type.rawValue
			}
		}

		let attemptedString = createAttributedString(string: card.type.rawValue, fontSize: verticalSpacing, card: card)
		let probablyOkayStringFontSize = verticalSpacing / (attemptedString.size().height / verticalSpacing)
		let probablyOkayString = createAttributedString(string: createStringWithBreaks(from: card), fontSize: probablyOkayStringFontSize, card: card)
		return probablyOkayString
	}

	private func createAttributedString(string: String, fontSize: CGFloat, card: Card) -> NSAttributedString {
		let color: UIColor
		let strokeWidth: CGFloat
		var strokeColor: UIColor? = nil
		switch card.shading {
		case .shadingOne:
			color = UIColor(hex: card.color.rawValue) ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			strokeWidth = -6.0
		case .shadingTwo:
			color = UIColor(hex: card.color.rawValue)?.withAlphaComponent(0.15) ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			strokeWidth = -4.0
			strokeColor = UIColor(hex: card.color.rawValue)
		case .shadingThree:
			color = UIColor(hex: card.color.rawValue) ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			strokeWidth = 6.0
		}
		var font = UIFont.systemFont(ofSize: fontSize)
		font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
		return NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: color, .strokeWidth: strokeWidth, .strokeColor: strokeColor as Any])
	}

	@IBAction private func cardTapped(_ sender: UIButton) {
	}

	@IBAction private func deal3MoreCardsTapped(_ sender: UIButton) {
	}
}

