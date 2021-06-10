//
//  ViewController.swift
//  Set
//
//  Created by Anna Belousova on 03.06.2021.
//

import UIKit
import Lottie

class SetViewController: UIViewController {

	
	@IBOutlet private var cardButtons: [UIButton]!
	@IBOutlet private var deal3Button: UIButton!
	private var deck = Deck()
	private var verticalSpacing: CGFloat {
		let cards = buttonsAndCardsDictionary.values
		let cardsSortedByQuantity = cards.sorted { (a, b) -> Bool in
			a.quantity.rawValue > b.quantity.rawValue
		}
		guard let maxQuantity = cardsSortedByQuantity.first?.quantity.rawValue else { return 3 }
		return cardButtons[0].bounds.insetBy(dx: 0, dy: Constants.verticalOffsetInsideButton).size.height / CGFloat(maxQuantity)
	}
	private var buttonsAreSelectedArray = [UIButton]()
	private var buttonsAndCardsDictionary = [UIButton: Card]()
	private let successAnimation = AnimationView(name: "success-animation")
	private let failAnimation = AnimationView(name: "fail-animation")
	private let darkenedBackground = UIView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		for (button, card) in zip(cardButtons, deck.dealInitialCards()) {
			buttonsAndCardsDictionary[button] = card
		}
		customizeUI()
		addAnimation()
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
				button.setAttributedTitle(createTitle(from: buttonsAndCardsDictionary[button]!), for: .normal)
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

	private func addAnimation() {
		view.addSubview(darkenedBackground)
		darkenedBackground.frame = view.bounds
		darkenedBackground.isHidden = true

		darkenedBackground.addSubview(successAnimation)
		successAnimation.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width/2, height: view.bounds.size.width/2)
		successAnimation.center = view.center
		successAnimation.contentMode = .scaleAspectFit

		darkenedBackground.addSubview(failAnimation)
		failAnimation.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width/2, height: view.bounds.size.width/2)
		failAnimation.center = view.center
		failAnimation.contentMode = .scaleAspectFit
	}

	@IBAction private func cardTapped(_ sender: UIButton) {
		if !buttonsAreSelectedArray.contains(sender), buttonsAreSelectedArray.count < 3 {
			buttonsAreSelectedArray.append(sender)
		} else {
			guard let index = buttonsAreSelectedArray.firstIndex(of: sender) else { return }
			buttonsAreSelectedArray.remove(at: index)
		}
		if buttonsAreSelectedArray.contains(sender) {
			sender.layer.borderWidth = Constants.borderWidthButtonIsSelected
			sender.layer.borderColor = Constants.borderColorButtonIsSelected
			sender.backgroundColor = Constants.backgroundColorButtonIsSelected
		} else {
			sender.layer.borderWidth = Constants.borderWidth
			sender.layer.borderColor = Constants.borderColor
			sender.backgroundColor = .white
		}

		if buttonsAreSelectedArray.count == 3 {
			var cards = [Card]()
			for button in buttonsAreSelectedArray {
				for buttonDict in buttonsAndCardsDictionary.keys {
					if button == buttonDict {
						cards.append(buttonsAndCardsDictionary[button]!)
					}
				}
			}
			let cardsAreMatched = deck.threeCardsAreSelected(cards)
			if cardsAreMatched == true {
				darkenedBackground.isHidden = false
				darkenedBackground.backgroundColor = UIColor.green.withAlphaComponent(0.1)
				successAnimation.play()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
					successAnimation.stop()
					darkenedBackground.isHidden = true
				}
			} else {
				darkenedBackground.isHidden = false
				darkenedBackground.backgroundColor = UIColor.red.withAlphaComponent(0.1)
				failAnimation.play()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
					failAnimation.stop()
					darkenedBackground.isHidden = true
				}
			}
		}

	}

	@IBAction private func deal3MoreCardsTapped(_ sender: UIButton) {
	}
}

